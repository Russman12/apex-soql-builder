public with sharing class ASB_WhereFieldExpression extends ASB_WhereConditionExpression {
  private final ASB_WhereFieldName fieldName;
  private final ASB_WhereComparisonOperator comparisonOperator;
  private final Object value;

  private static final Map<ASB_WhereComparisonOperator, String> OPERATOR_STRINGS = new Map<ASB_WhereComparisonOperator, String>{
    ASB_WhereComparisonOperator.EQUALS => '=',
    ASB_WhereComparisonOperator.NOT_EQUALS => '!='
  };

  public ASB_WhereFieldExpression(
    ASB_WhereFieldName fieldName,
    ASB_WhereComparisonOperator comparisonOperator,
    Object value
  ) {
    this.fieldName = fieldName;
    this.comparisonOperator = comparisonOperator;
    this.value = value;
  }

  public override String toClauseString() {
    return this.fieldName.toClauseString() +
      OPERATOR_STRINGS.get(this.comparisonOperator) +
      this.value.toString();
  }
}
