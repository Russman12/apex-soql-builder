/**
 * Encompasses functionality relating to a SOQL subquery.
 * @author Russell Laboe
 */
public with sharing class ASB_SubQuery extends ASB_Query {
  /**
   * Creates a new `ASB_SubQuery` from given relationship field. The relationship field is the field that exists on a child object.
   * @param relationshipField Relationship field from child to parent.
   * @return  `ASB_SubQuery`
   * @example
   * ```apex
   *   // this subquery would be added to an `ASB` which is selecting from Account
   *   ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Account.Id);
   * ```
   */
  public static ASB_SubQuery relatedBy(Schema.sObjectField relationshipField) {
    return new ASB_SubQuery(relationshipField);
  }
  private ASB_SubQuery(Schema.sObjectField field) {
    super(new ASB_From(field));
  }

  /**
   * Adds given field to select clause.
   * @param field Field to add to Select Clause.
   * @return  `ASB`
   */
  public ASB_SubQuery selectField(Schema.SObjectField field) {
    return (ASB_SubQuery) superSelect(asbSelect.field(field));
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
  public ASB_SubQuery selectParentField(Schema.SObjectField[] fieldPath) {
    return (ASB_SubQuery) superSelect(asbSelect.parent(fieldPath));
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
  public ASB_SubQuery selectParentField(Schema.SObjectField relationshipField, Schema.SObjectField field) {
    return (ASB_SubQuery) selectParentField(new List<Schema.SObjectField>{ relationshipField, field });
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
  public ASB_SubQuery selectSubQuery(ASB_SubQuery subQuery) {
    return (ASB_SubQuery) superSelect(asbSelect.subQuery(subQuery));
  }
  /**
   * Adds given `ASB_Where` clause filter to query.
   * @param asbWhere where clasue to add to query.
   * @return  `ASB`
   */
  public ASB_SubQuery filter(ASB_Where asbWhere) {
    return (ASB_SubQuery) superWhere(asbWhere);
  }
  /**
   * Sets given `ASB_OrderBy` clause to query.
   * @param asbOrder order by clause to add to query.
   * @return  `ASB`
   */
  public ASB_SubQuery orderBy(ASB_OrderBy asbOrder) {
    return (ASB_SubQuery) superOrderBy(asbOrder);
  }
  /**
   * Sets the given `ASB_Limit` to query.
   * @param limitx limit to add to query.
   * @return  `ASB`
   */
  public ASB_SubQuery recordlimit(Integer limitx) {
    return (ASB_SubQuery) superLimit(limitx);
  }

  /**
   * Converts SubQuery to SOQL string.
   * @return  `String`
   */
  public String soqlString() {
    ASB_Clause[] clauses = new List<ASB_Clause>{ this.asbSelect, this.asbFrom, this.asbWhere };

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
