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
  public ASB selectField(Schema.SObjectField field) {
    return (ASB) superSelect(asbSelect.field(field));
  }

  /**
   * Adds given parent fieldPath to select clause.
   * @param fieldPath field path to add to clause.
   * @return  `ASB`
   *
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectParentField(new List<SObjectField>{Account.OwnerId, User.Name})
   * ```
   */
  public ASB selectParentField(Schema.SObjectField[] fieldPath) {
    return (ASB) superSelect(asbSelect.parent(fieldPath));
  }
  /**
   * Adds given parent fieldPath to select clause.
   * @param relationshipField relationship field to parent.
   * @param field parent field.
   * @return  `ASB`
   *
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectParentField(Account.OwnerId, User.Name)
   * ```
   */
  public ASB selectParentField(Schema.SObjectField relationshipField, Schema.SObjectField field) {
    return (ASB) selectParentField(new List<Schema.SObjectField>{ relationshipField, field });
  }
  /**
   * Adds given parent fieldPath to select clause.
   * @param relationshipField1 relationship field to first parent.
   * @param relationshipField2 relationship field to second parent.
   * @param field parent field.
   * @return  `ASB`
   *
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectParentField(Account.OwnerId, User.ProfileId, Profile.Name)
   * ```
   */
  public ASB selectParentField(
    Schema.SObjectField relationshipField1,
    Schema.SObjectField relationshipField2,
    Schema.SObjectField field
  ) {
    return (ASB) selectParentField(new List<Schema.SObjectField>{ relationshipField1, relationshipField2, field });
  }
  /**
   * Adds given `ASB_SubQuery` to select clause.
   * @param subQuery subquery to add to select clause.
   * @return  `ASB`
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectSubQuery(ASB_SubQuery.relatedBy(Contact.AccountId).field(Contact.Name))
   * ```
   */
  public ASB selectSubQuery(ASB_SubQuery subQuery) {
    return (ASB) superSelect(asbSelect.subQuery(subQuery));
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
