public with sharing class ASB {
  /**
   * Creates new ASB_QueryBuilder instance.
   * @param sObjType Type to make the FROM clause for.
   * @return  `ASB`
   */
  public ASB_QueryBuilder make(Schema.SObjectType sObjType) {
    return new ASB_QueryBuilder(sObjType);
  }

  public ASB_Select selection() {
    return new ASB_Select();
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
  public ASB_SubQuery subQuery(Schema.sObjectField relationshipField) {
    return new ASB_SubQuery(relationshipField);
  }

  /**
   * Creates new instance of ASB_From based on given SObjectType.
   * @param sObjType Type to make the FROM clause for.
   */
  public ASB_From fromx(Schema.SObjectType sObjType) {
    return new ASB_From(sObjType);
  }

  /**
   * Creates new instance of ASB_From based on given relationship field.
   * @param relationshipField the relationship to make the FROM clause for.
   */
  public ASB_From fromx(Schema.SObjectField relationshipField) {
    return new ASB_From(relationshipField);
  }

  public ASB_Where.Builder filter() {
    return new ASB_Where.Builder();
  }

  /**
   * Sets field in Order By clause.
   * @param field
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy orderByField(Schema.SObjectField field) {
    return orderByFields(new List<Schema.SObjectField>{ field });
  }

  /**
   * Sets 2 fields in Order By clause.
   * @param field1
   * @param field2
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy orderByFields(Schema.SObjectField field1, Schema.SObjectField field2) {
    return orderByFields(new List<Schema.SObjectField>{ field1, field2 });
  }

  /**
   * Sets fields in Order By clause.
   * @param fields
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy orderByFields(Schema.SObjectField[] fields) {
    return new ASB_OrderBy(fields);
  }

  /**
   * Returns new ASB_Limit instance for query
   * @param recordLimit
   * @return  `ASB_Limit`
   */
  public ASB_Limit recordLimit(Integer recordLimit) {
    return new ASB_Limit(recordLimit);
  }
}
