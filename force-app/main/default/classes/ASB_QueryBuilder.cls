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
    return (ASB_QueryBuilder) superSelect(asbSelect);
  }

  /**
   * Adds given `ASB_Where` clause filter to query.
   * @param asbWhere where clasue to add to query.
   * @return  `ASB`
   */
  public ASB_QueryBuilder filter(ASB_Where asbWhere) {
    return (ASB_QueryBuilder) superWhere(asbWhere);
  }
  /**
   * Sets given `ASB_OrderBy` clause to query.
   * @param asbOrder order by clause to add to query.
   * @return  `ASB`
   */
  public ASB_QueryBuilder orderBy(ASB_OrderBy asbOrder) {
    return (ASB_QueryBuilder) superOrderBy(asbOrder);
  }
  /**
   * Sets the given `ASB_Limit` to query.
   * @param limitx limit to add to query.
   * @return  `ASB`
   */
  public ASB_QueryBuilder recordLimit(Integer limitx) {
    return (ASB_QueryBuilder) superLimit(limitx);
  }

  /**
   * Executes the SOQL query.
   * @return  `List<SObject>`
   */
  public List<SObject> query() {
    return this.query(new Map<String, Object>());
  }

  /**
   * Executes the SOQL query with variable bindings.
   * @param binds map of bindings to use for query.
   * @return  `List<SObject>`
   */
  public List<SObject> query(Map<String, Object> binds) {
    //TODO: perform check against query limit and throw exception if limit is reached
    List<SObject> queryResults = Database.queryWithBinds(this.soqlString(), binds, this.accessLevel);

    return queryResults;
  }

  /**
   * Converts ASB_QueryBuilder to SOQL string.
   * @return  `String`
   */
  public String soqlString() {
    ASB_Clause[] clauses = new List<ASB_Clause>{
      this.asbSelect,
      this.asbFrom,
      this.asbWhere,
      this.asbOrderBy,
      this.asbLimit
    };

    ASB_Clause[] setClauses = new List<ASB_Clause>{};
    for (ASB_Clause clause : clauses) {
      if (clause != null) {
        setClauses.add(clause);
      }
    }

    String[] strs = new List<String>{};
    for (ASB_Clause clause : setClauses) {
      strs.add(clause.clauseString());
    }
    return String.join(strs, ' ');
  }
}
