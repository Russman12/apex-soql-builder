/**
 * Entry point of Apex SOQL Builder. This class encompasses funcoitnality relating to building a SOQL query.
 *
 * ## Basic Usage
 * ```apex
 * List<Account> testAccs = (List<Account>)ASB.make(Account.getSObjectType())
 *    .selectField(Account.Name)
 *    .wherex(ASB_Where.field(Account.Name).isLike().bind('accName'))
 *    .query(new Map<String, Object>{'accName' => '%test%'})
 * ```
 * @author Russell Laboe
 */
public with sharing class ASB extends ASB_Query {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  /**
   * Creates new ASB instance.
   * @param sObjType Type to make the FROM clause for.
   * @return  `ASB`
   */
  public static ASB sObject(Schema.SObjectType sObjType) {
    return new ASB(sObjType);
  }

  public System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

  private ASB(Schema.SObjectType sObjType) {
    super(new ASB_From(sObjType));
  }

  /**
   * Adds given field to select clause.
   * @param field Field to add to Select Clause.
   * @return  `ASB`
   */
  public ASB selection(ASB_Select asbSelect) {
    return (ASB) superSelect(asbSelect);
  }

  /**
   * Adds given `ASB_Where` clause filter to query.
   * @param asbWhere where clasue to add to query.
   * @return  `ASB`
   */
  public ASB filter(ASB_Where asbWhere) {
    return (ASB) superWhere(asbWhere);
  }
  /**
   * Sets given `ASB_OrderBy` clause to query.
   * @param asbOrder order by clause to add to query.
   * @return  `ASB`
   */
  public ASB orderBy(ASB_OrderBy asbOrder) {
    return (ASB) superOrderBy(asbOrder);
  }
  /**
   * Sets the given `ASB_Limit` to query.
   * @param limitx limit to add to query.
   * @return  `ASB`
   */
  public ASB recordLimit(Integer limitx) {
    return (ASB) superLimit(limitx);
  }

  /**
   * Executes the SOQL query.
   * @return  `List<SObject>`
   */
  public List<SObject> query() {
    return Database.query(this.soqlString(), this.accessLevel);
  }
  /**
   * Executes the SOQL query with variable bindings.
   * @param binds map of bindings to use for query.
   * @return  `List<SObject>`
   */
  public List<SObject> query(Map<String, Object> binds) {
    return Database.queryWithBinds(this.soqlString(), binds, this.accessLevel);
  }

  /**
   * Converts ASB to SOQL string.
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
