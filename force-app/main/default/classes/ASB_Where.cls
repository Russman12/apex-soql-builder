/**
 * SOQL WHERE clause.
 * @description This class encompasses functionality relating to building a WHERE clause. It ca
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Where {
  public static final ComparisonOperator CO_EQUALS = ComparisonOperator.EQUALS;
  public static final ComparisonOperator CO_NOT_EQUALS = ComparisonOperator.NOT_EQUALS;
  public static final ComparisonOperator CO_LIKEX = ComparisonOperator.LIKEX;

  private static ASB_Where instance;

  public static ASB_Where instance() {
    if (instance == null) {
      instance = new ASB_Where();
    }
    return instance;
  }

  public Expression expression(SObjectField field, ComparisonOperator operator, Object value) {
    return new ConditionExpression(field, operator, makeValue(value));
  }

  private class Clause implements ASB_SOQLClause {
    protected final ConditionExpression expression;

    /**
     * Constructs new instance with SObjectField,
     * @param field     `SObjectField`
     * @param operator  `ComparisonOperator`
     * @param value     `String`
     */
    private Clause(ConditionExpression expression) {
      this.expression = expression;
    }

    /**
     * Returns WHERE clause as SOQL String. Removes top level parentheses if necessary.
     * @return `String`
     */
    public String toClauseString() {
      return 'WHERE ' + this.expression.toSOQLString().removeStart('(').removeEnd(')');
    }
  }

  /**
   * Defines the structure of ConditionExpression component of WHERE clause.
   */
  public interface Expression {
    /**
     * Join an expression with `AND` `LogicalOperator`. If an expression is provided, it will be joined as a group.
     */
    Expression andx(Expression expression);
    Expression andx(SObjectField field, ComparisonOperator operator, String value);

    /**
     * Join expression with `OR` `LogicalOperator`. If an expression is provided, it will be joined as a group.
     */
    Expression orx(Expression expression);
    Expression orx(SObjectField field, ComparisonOperator operator, String value);

    /**
     * Group current expression (ie, wraps in `()`)
     */
    Expression group();

    /**
     * Returns expression as complete WHERE clause
     */
    ASB_SOQLClause toClause();
  }

  private interface ExpressionComposite {
    String toSOQLString();
  }

  private class ConditionExpression implements Expression, ExpressionComposite {
    private final List<ExpressionComposite> expressions;
    private final List<LogicalOperator> joiners;

    private ConditionExpression(ConditionExpression exp) {
      this.expressions = exp.expressions.clone();
      this.joiners = exp.joiners.clone();
    }

    private ConditionExpression(List<ExpressionComposite> expressions, List<LogicalOperator> joiners) {
      this.expressions = expressions;
      this.joiners = joiners;
    }

    private ConditionExpression(SObjectField field, ComparisonOperator operator, Value value) {
      this.expressions = new List<ExpressionComposite>{ new FieldExpression(field, operator, value) };
      this.joiners = new List<LogicalOperator>();
    }

    public Expression group() {
      ConditionExpression condExp = new ConditionExpression(
        new List<ExpressionComposite>{ this },
        new List<LogicalOperator>()
      );
      return condExp;
    }

    public Expression andx(Expression expression) {
      return this.add((ConditionExpression) expression, LogicalOperator.ANDX);
    }
    public Expression andx(SObjectField field, ComparisonOperator operator, String value) {
      return this.add(field, operator, makeValue(value), LogicalOperator.ANDX);
    }

    public Expression orx(Expression expression) {
      return this.add((ConditionExpression) expression, LogicalOperator.ORX);
    }
    public Expression orx(SObjectField field, ComparisonOperator operator, String value) {
      return this.add(field, operator, makeValue(value), LogicalOperator.ORX);
    }

    private ConditionExpression add(ConditionExpression expression, LogicalOperator logicalOperator) {
      ConditionExpression newExp = this.duplicate();
      newExp.expressions.add(expression);
      newExp.joiners.add(logicalOperator);
      return newExp;
    }

    public Expression add(
      SObjectField field,
      ComparisonOperator operator,
      Value value,
      LogicalOperator logicalOperator
    ) {
      return this.add(new ConditionExpression(field, operator, value), logicalOperator);
    }

    private ConditionExpression duplicate() {
      return new ConditionExpression(this);
    }

    /**
     * Returns ASB_SOQL content as SOQL String. This does not include the clause statement and wraps in parentheses only if necessary.
     * @return `String`
     */
    public virtual String toSOQLString() {
      String s = '';

      for (Integer i = 0; i < this.expressions.size(); i++) {
        ExpressionComposite currentExpression = this.expressions[i];

        s += currentExpression.toSOQLString();
        if (i < this.joiners.size()) {
          s += ' ' + logicalOpVal(this.joiners[i]) + ' ';
        }
      }
      if (this.expressions.size() > 1) {
        s = '(' + s + ')';
      }

      return s;
    }

    public ASB_SOQLClause toClause() {
      return new clause(this);
    }
  }

  /**
   * Represents a Field Expression portion of a WHERE clause.
   */
  private class FieldExpression implements ExpressionComposite {
    private final String fieldName;
    private final ComparisonOperator comparisonOperator;
    private final Value value;

    /**
     * Private constructor should only be called from within the parent class
     */
    private FieldExpression(SObjectField field, ComparisonOperator operator, Value value) {
      this.fieldName = field.getDescribe().getName();
      this.comparisonOperator = operator;
      this.value = value;
    }

    /**
     * Returns FeildExpression as a SOQL String
     * @return `String`
     */
    public String toSOQLString() {
      return this.fieldName + ' ' + comparisonOpVal(this.comparisonOperator) + ' ' + this.value.toSOQLString();
    }
  }

  private static Value makeValue(Object o) {
    if (o instanceof String) {
      return new StringValue((String) o);
    }
    if (o instanceof Integer || o instanceof Double || o instanceof Decimal) {
      return new NumberValue(o);
    }

    return null;
  }

  /**
   * Use the Strategy pattern to transform a `Value` to a valid SOQL string
   */
  private interface Value {
    String toSOQLString();
  }

  private class StringValue implements Value {
    private final String value;

    /**
     * Constructs new StringValue instance with given string
     */
    private StringValue(String value) {
      this.value = value;
    }

    /**
     * Returns SOQL String form of instance to be used in Value component of Field Expression.
     * @return `String`
     */
    public String toSOQLString() {
      String s = this.value;
      if (!s.startsWith(':')) {
        s = '\'' + this.value + '\'';
      }
      return s;
    }
  }

  private class NumberValue implements Value {
    private final Object value;

    /**
     * Constructs new NumberValue instance with given Integer
     */
    private NumberValue(Object value) {
      this.value = value;
    }

    /**
     * Returns SOQL String form of instance to be used in Value component of Field Expression.
     * @return `String`
     */
    public String toSOQLString() {
      return this.value.toString();
    }
  }

  /**
   * WHERE clause Comparison Operators. These are the operators used to compare a feild with a value.
   */
  public enum ComparisonOperator {
    EQUALS,
    NOT_EQUALS,
    LIKEX
  }

  /**
   * Returns SOQL String form of given ComparisonOperator
   * @return `String`
   */
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

  private enum LogicalOperator {
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
