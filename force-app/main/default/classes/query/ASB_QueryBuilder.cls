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
public with sharing class ASB_QueryBuilder {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  public System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;
  @testVisible
  private final ASB_QueryEngine queryEngine;
  private final ASB_SelectClause selectClause;

  public ASB_QueryBuilder(ASB_FromSObjectClause fromSObj, ASB_SelectClause selectClause) {
    this.queryEngine = new ASB_QueryEngine(fromSObj, selectClause);
    this.selectClause = selectClause;
  }

  /**
   * Sets the select portion of query.
   * @param field Field to add to Select Clause.
   * @return  `ASB`
   */
  public ASB_QueryBuilder selection(ASB_SelectClause selectClause) {
    selectClause.mergeInto(this.selectClause);
    return this;
  }

  public ASB_QueryBuilder filter(ASB_WhereClause asbWhere) {
    queryEngine.setWhere(asbWhere);
    return this;
  }

  public ASB_QueryBuilder orderBy(ASB_OrderByClause orderBy) {
    queryEngine.setOrderBy(orderBy);
    return this;
  }

  public ASB_QueryBuilder recordLimit(Integer recordLimit) {
    queryEngine.setLimit(recordLimit);
    return this;
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
    String queryString = queryEngine.queryDetail(bindCtx);
    System.debug(System.LoggingLevel.INFO, 'query: ' + queryString);
    System.debug(System.LoggingLevel.INFO, 'binds: ' + bindCtx.getBinds());

    List<SObject> queryResults = Database.queryWithBinds(queryString, bindCtx.getBinds(), this.accessLevel);

    return queryResults;
  }

  public class LimitException extends Exception {
  }
}
