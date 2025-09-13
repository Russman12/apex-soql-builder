public with sharing class ASB {
  /**
   * Creates new ASB_QueryBuilder instance.
   * @param sObjType Type to make the FROM clause for.
   * @return  `ASB`
   */
  public ASB_QueryBuilder make(Schema.SObjectType sObjType) {
    return new ASB_QueryBuilder(fromSObject(sObjType), selection());
  }

  public ASB_SelectClause selection() {
    return new ASB_SelectClause(null);
  }

  /**
   * Creates a new `ASB_SubQuery` from given relationship field. The relationship field is the field that exists on a child object.
   * @param relationshipField Relationship field from child to parent.
   * @return  `ASB_SubQuery`
   * @example
   * ```apex
   *   // this subquery would be added to an `ASB` which is selecting from Account
   *   asb.subQuery(Contact.AccountId).selectField(Account.Id);
   * ```
   */
  public ASB_SubQueryBuilder subQuery(Schema.sObjectField relationshipField) {
    return new ASB_SubQueryBuilder(fromRelationship(relationshipField), subSelection());
  }

  public ASB_SubSelectClause subSelection() {
    return new ASB_SubSelectClause(null);
  }

  public ASB_WhereClause.Builder filter() {
    return new ASB_WhereClause.Builder();
  }

  /**
   * Sets field in Order By clause.
   * @param field
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderByClause orderByField(Schema.SObjectField field) {
    return orderByFields(new List<Schema.SObjectField>{ field });
  }

  /**
   * Sets 2 fields in Order By clause.
   * @param field1
   * @param field2
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderByClause orderByFields(Schema.SObjectField field1, Schema.SObjectField field2) {
    return orderByFields(new List<Schema.SObjectField>{ field1, field2 });
  }

  /**
   * Sets fields in Order By clause.
   * @param fields
   * @return  `ASB_OrderByClause`
   */
  public ASB_OrderByClause orderByFields(Schema.SObjectField[] fields) {
    return new ASB_OrderByClause(fields);
  }

  /**
   * Returns new ASB_Limit instance for query
   * @param recordLimit
   * @return  `ASB_Limit`
   */
  public ASB_LimitClause recordLimit(Integer recordLimit) {
    return new ASB_LimitClause(recordLimit);
  }

  private ASB_FromSObjectClause fromSObject(Schema.SObjectType sObjType) {
    return new ASB_FromSObjectClause(sObjType);
  }
  private ASB_FromRelationshipClause fromRelationship(Schema.SObjectField relationshipField) {
    return new ASB_FromRelationshipClause(relationshipField);
  }
}
