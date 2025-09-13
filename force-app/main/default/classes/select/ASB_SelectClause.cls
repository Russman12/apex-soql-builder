public with sharing class ASB_SelectClause implements ASB_Selectable {
  private final ASB_SelectEngine selectEngine;

  public ASB_SelectClause(Schema.SObjectType sObjType) {
    this.selectEngine = new ASB_SelectEngine(sObjType);
  }

  /**
   * Adds field to `ASB_Selectable` instance.
   * @param field Field to add to select clause.
   * @return  `ASB_Selectable`
   */
  public ASB_SelectClause field(Schema.SObjectField field) {
    selectEngine.addField(field);
    return this;
  }

  /**
   * Adds a parent record field to `ASB_Selectable` instance.
   * @param fieldPath Path to parent field.
   * @return  `ASB_Selectable`
   */
  public ASB_SelectClause parent(List<Schema.SObjectField> fieldPath) {
    selectEngine.addParent(fieldPath);
    return this;
  }
  public ASB_SelectClause parent(Schema.SObjectField fieldPath1, Schema.SObjectField fieldPath2) {
    return parent(new List<Schema.SObjectField>{ fieldPath1, fieldPath2 });
  }
  public ASB_SelectClause parent(
    Schema.SObjectField fieldPath1,
    Schema.SObjectField fieldPath2,
    Schema.SObjectField fieldPath3
  ) {
    return parent(new List<Schema.SObjectField>{ fieldPath1, fieldPath2, fieldPath3 });
  }

  public ASB_SelectClause subquery(ASB_SubQueryBuilder subquery) {
    selectEngine.mergeSubQuery(subquery);
    return this;
  }

  public String clauseString(ASB_BindContext ctx) {
    return selectEngine.clauseString(ctx);
  }

  public void mergeInto(ASB_SelectClause selectClause) {
    selectEngine.mergeInto(selectClause.selectEngine);
  }
}
