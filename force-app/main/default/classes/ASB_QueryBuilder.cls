/**
 * Entry point of Apex SOQL Builder. This class encompasses funcoitnality relating to building a SOQL query.
 *
 * ## Basic Usage
 * ```apex
 * List<Account> testAccs = (List<Account>)ASB.make(Account.getSObjectType())
 *    .selectField(Account.Name)
 *    .wherex(asb.whereField(Account.Name).isLike().bind('accName'))
 *    .query(new Map<String, Object>{'accName' => '%test%'})
 * ```
 * @author Russell Laboe
 */
public with sharing class ASB_QueryBuilder extends ASB_Query {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  public System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

  public ASB_QueryBuilder(Schema.SObjectType sObjType) {
    super(new ASB_From(sObjType));
  }

  /**
   * Sets the select portion of query.
   * @param field Field to add to Select Clause.
   * @return  `ASB`
   */
  public ASB_QueryBuilder selection(ASB_Select asbSelect) {
    return (ASB_QueryBuilder) setSelect(asbSelect);
  }

  /**
   * Adds given `ASB_Where` clause filter to query.
   * @param asbWhere where clasue to add to query.
   * @return  `ASB`
   */
  public ASB_QueryBuilder filter(ASB_Where asbWhere) {
    return (ASB_QueryBuilder) setWhere(asbWhere);
  }
  /**
   * Sets given `ASB_OrderBy` clause to query.
   * @param asbOrder order by clause to add to query.
   * @return  `ASB`
   */
  public ASB_QueryBuilder orderBy(ASB_OrderBy asbOrder) {
    return (ASB_QueryBuilder) setOrderBy(asbOrder);
  }
  /**
   * Sets the given `ASB_Limit` to query.
   * @param limitx limit to add to query.
   * @return  `ASB`
   */
  public ASB_QueryBuilder recordLimit(Integer limitx) {
    return (ASB_QueryBuilder) setLimit(limitx);
  }

  /**
   * Executes the SOQL query.
   * @return  `List<SObject>`
   */
  public List<SObject> query() {
    if (Limits.getQueries() == Limits.getLimitQueries()) {
      throw new LimitException(
        'Executing this 1 query result in exceeding the query limit for this context. Currently ' +
          Limits.getQueries() +
          '/' +
          Limits.getLimitQueries()
      );
    }

    ASB_BindContext bindCtx = new ASB_BindContext();
    String queryString = this.queryDetail(bindCtx);
    System.debug(System.LoggingLevel.INFO, 'query: ' + queryString);
    System.debug(System.LoggingLevel.INFO, 'binds: ' + bindCtx.getBinds());

    List<SObject> queryResults = Database.queryWithBinds(queryString, bindCtx.getBinds(), this.accessLevel);

    return queryResults;
  }

  /**
   * Converts ASB_QueryBuilder to SOQL string.
   * @return  `String`
   */
  public String queryDetail(ASB_BindContext ctx) {
    String[] clauseStrings = new List<String>{};
    Map<String, Object> binds = new Map<String, Object>();
    for (ASB_Clause clause : this.getClauses()) {
      if (clause != null) {
        clauseStrings.add(clause.clauseString(ctx));
      }
    }
    return String.join(clauseStrings, ' ');
  }

  public class LimitException extends Exception {
  }
}
