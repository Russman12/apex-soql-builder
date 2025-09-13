public with sharing class ASB_SubSelectClause implements ASB_Selectable {
  private final ASB_SelectEngine selectEngine;

  public ASB_SubSelectClause(SObjectType sObjType) {
    this.selectEngine = new ASB_SelectEngine(sObjType);
  }

  /**
   * Adds field to `ASB_Selectable` instance.
   * @param field Field to add to select clause.
   * @return  `ASB_Selectable`
   */
  public ASB_SubSelectClause field(Schema.SObjectField field) {
    selectEngine.addField(field);
    return this;
  }

  /**
   * Adds a parent record field to `ASB_Selectable` instance.
   * @param fieldPath Path to parent field.
   * @return  `ASB_Selectable`
   */
  public ASB_SubSelectClause parent(List<Schema.SObjectField> fieldPath) {
    selectEngine.addParent(fieldPath);
    return this;
  }
  public ASB_SubSelectClause parent(Schema.SObjectField relField1, Schema.SObjectField relField2) {
    return parent(new List<Schema.SObjectField>{ relField1, relField2 });
  }

  public String clauseString(ASB_BindContext ctx) {
    return selectEngine.clauseString(ctx);
  }

  public void mergeInto(ASB_SubSelectClause subSelectClause) {
    selectEngine.mergeInto(subSelectClause.selectEngine);
  }
}
