public with sharing class ASB_WhereSObjectField extends ASB_WhereFieldName {
  private final SObjectField field;

  public ASB_WhereSObjectField(SObjectField field) {
    this.field = field;
  }

  public override String toClauseString() {
    return field.getDescribe().getName();
  }
}
