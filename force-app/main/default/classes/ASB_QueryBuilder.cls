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

    ASB_Query.Detail queryDetail = this.queryDetail();
    System.debug(System.LoggingLevel.INFO, 'query: ' + queryDetail.getQueryString());
    System.debug(System.LoggingLevel.INFO, 'binds: ' + queryDetail.getBindings());

    List<SObject> queryResults = Database.queryWithBinds(
      queryDetail.getQueryString(),
      queryDetail.getBindings(),
      this.accessLevel
    );

    return queryResults;
  }

  /**
   * Converts ASB_QueryBuilder to SOQL string.
   * @return  `String`
   */
  public ASB_Query.Detail queryDetail() {
    ASB_ClauseDetail[] clauseDetails = new List<ASB_ClauseDetail>{};
    for (ASB_Clause clause : this.getClauses()) {
      if (clause != null) {
        clauseDetails.add(clause.clauseDetail());
      }
    }

    String[] clauseStrings = new List<String>{};
    Map<String, Object> bindings = new Map<String, Object>();
    for (ASB_ClauseDetail clauseDetail : clauseDetails) {
      clauseStrings.add(clauseDetail.getClauseString());
      bindings.putAll(clauseDetail.getBindings());
    }
    return new ASB_Query.Detail(String.join(clauseStrings, ' '), bindings);
  }

  public class LimitException extends Exception {
  }
}
