public class ASB_Where implements ConditionExpression, ASB_SOQL.Clause {
  protected final List<ConditionExpression> expressions;
  protected final List<LogicalOperator> joiners;

  private ASB_Where(ASB_Where asbWhere) {
    this.expressions = asbWhere.expressions;
    this.joiners = asbWhere.joiners;
  }

  public ASB_Where(SObjectField field, ComparisonOperator operator, String value) {
    Value val = new StringValue(value);
    this.expressions = new List<ConditionExpression>{ new FieldExpression(field, operator, val) };
    this.joiners = new List<LogicalOperator>();
  }

  public ASB_Where(SObjectField field, ComparisonOperator operator, Integer value) {
    Value val = new NumberValue(value);
    this.expressions = new List<ConditionExpression>{ new FieldExpression(field, operator, val) };
    this.joiners = new List<LogicalOperator>();
  }

  public ASB_Where andx(ConditionExpression expression) {
    this.add(expression, LogicalOperator.ANDX);
    return new ASB_Where(this);
  }

  public ASB_Where orx(ConditionExpression expression) {
    this.add(expression, LogicalOperator.ORX);
    return new ASB_Where(this);
  }

  private void add(ConditionExpression expression, LogicalOperator logicalOperator) {
    this.expressions.add(expression);
    this.joiners.add(logicalOperator);
  }

  public virtual String toSOQLString() {
    String s = '';

    for (Integer i = 0; i < this.expressions.size(); i++) {
      ConditionExpression currentExpression = this.expressions[i];

      s += currentExpression.toSOQLString();
      if (i < this.joiners.size()) {
        s += ' ' + logicalOpVal(this.joiners[i]) + ' ';
      }
    }

    if (this.joiners.size() > 0) {
      s = '(' + s + ')';
    }
    return s;
  }

  public String toClauseString() {
    return 'WHERE ' + this.toSOQLString().removeStart('(').removeEnd(')');
  }

  private class FieldExpression implements ConditionExpression {
    private final String fieldName;
    private final ComparisonOperator comparisonOperator;
    private final Value value;

    private FieldExpression(SObjectField field, ComparisonOperator operator, Value value) {
      this.fieldName = field.getDescribe().getName();
      this.comparisonOperator = operator;
      this.value = value;
    }

    public String toSOQLString() {
      return this.fieldName +
        ' ' +
        comparisonOpVal(this.comparisonOperator) +
        ' ' +
        this.value.toSOQLString();
    }
  }

  public interface Value {
    String toSOQLString();
  }

  public class StringValue implements Value {
    private final String value;

    public StringValue(String value) {
      this.value = value;
    }

    public String toSOQLString() {
      String s = this.value;
      if (!s.startsWith(':')) {
        s = '\'' + this.value + '\'';
      }
      return s;
    }
  }

  public class NumberValue implements Value {
    private final Object value;

    public NumberValue(Integer value) {
      this.value = value;
    }

    public NumberValue(Decimal value) {
      this.value = value;
    }

    public NumberValue(Double value) {
      this.value = value;
    }

    public String toSOQLString() {
      return this.value.toString();
    }
  }

  public interface ConditionExpression {
    String toSOQLString();
  }

  public enum ComparisonOperator {
    EQUALS,
    NOT_EQUALS,
    LIKEX
  }

  private static String comparisonOpVal(ComparisonOperator co) {
    switch on co {
      when EQUALS {
        return '=';
      }
      when NOT_EQUALS {
        return '!=';
      }
      when LIKEX {
        return 'LIKE';
      }
    }
    return '';
  }

  public enum LogicalOperator {
    ANDX,
    ORX
  }

  private static String logicalOpVal(LogicalOperator lo) {
    switch on lo {
      when ANDX {
        return 'AND';
      }
      when ORX {
        return 'OR';
      }
    }
    return '';
  }
}
