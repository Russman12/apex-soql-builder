/**
 * SOQL WHERE clause.
 * @description This class encompasses functionality relating to building a WHERE clause. It ca
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Where implements ConditionExpression, ASB_SOQL.Clause {
  protected final List<ConditionExpression> expressions;
  protected final List<LogicalOperator> joiners;

  /**
   * Private constructor to create duplicate instance.
   */
  private ASB_Where(ASB_Where asbWhere) {
    this.expressions = asbWhere.expressions;
    this.joiners = asbWhere.joiners;
  }

  /**
   * Constructs new instance with SObjectField,
   * @param field     `SObjectField`
   * @param operator  `ComparisonOperator`
   * @param value     `String`
   */
  public ASB_Where(SObjectField field, ComparisonOperator operator, String value) {
    Value val = new StringValue(value);
    this.expressions = new List<ConditionExpression>{ new FieldExpression(field, operator, val) };
    this.joiners = new List<LogicalOperator>();
  }

  /**
   * Constructs new instance with SObjectField,
   * @param field     `SObjectField`
   * @param operator  `ComparisonOperator`
   * @param value     `Integer`
   */
  public ASB_Where(SObjectField field, ComparisonOperator operator, Integer value) {
    this(field, operator, new NumberValue(value));
  }

  /**
   * Private constructor used to construct a new instance with a Value
   * @param field     `SObjectField`
   * @param operator  `ComparisonOperator`
   * @param value     `Value`
   */
  private ASB_Where(SObjectField field, ComparisonOperator operator, Value value) {
    this(new FieldExpression(field, operator, value));
  }

  /**
   * Private constructor used to construct a new instance with FieldExpression
   * @param expression  `FieldExpression`
   */
  private ASB_Where(FieldExpression expression) {
    this.expressions = new List<ConditionExpression>{ expression };
    this.joiners = new List<LogicalOperator>();
  }

  /**
   * Appends a ConditionExpression to ASB_Where element joined with `AND` Logic Operator
   * @param expression `ConditionExpression` expression to append.
   */
  public ASB_Where andx(ConditionExpression expression) {
    this.add(expression, LogicalOperator.ANDX);
    return new ASB_Where(this);
  }

  /**
   * Appends a ConditionExpression to ASB_Where element joined with `OR` Logic Operator
   * @param expression `ConditionExpression` expression to append.
   */
  public ASB_Where orx(ConditionExpression expression) {
    this.add(expression, LogicalOperator.ORX);
    return new ASB_Where(this);
  }

  /**
   * Appends a ConditionExpression to ASB_Where element joined with given Logic Operator. For internal use only. Use `orx(expression)` or `andx(expression)` instead
   * @param expression `ConditionExpression` expression to append.
   * @param logicalOperator `LogicalOperator` expression to append.
   */
  private void add(ConditionExpression expression, LogicalOperator logicalOperator) {
    this.expressions.add(expression);
    this.joiners.add(logicalOperator);
  }

  /**
   * Returns ASB_SOQL content as SOQL String. This does not include the clause statement and wraps in parentheses only if necessary.
   * @return `String`
   */
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

  /**
   * Returns WHERE clause as SOQL String. Removes top level parentheses if necessary.
   * @return `String`
   */
  public String toClauseString() {
    return 'WHERE ' + this.toSOQLString().removeStart('(').removeEnd(')');
  }

  /**
   * Represents a Field Expression portion of a WHERE clause.
   */
  private class FieldExpression implements ConditionExpression {
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
      return this.fieldName +
        ' ' +
        comparisonOpVal(this.comparisonOperator) +
        ' ' +
        this.value.toSOQLString();
    }
  }

  /**
   * Defines structure of the Value component of a Field Expression
   */
  private interface Value {
    String toSOQLString();
  }

  /**
   * Represents a String type Field Expression value.
   */
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

  /**
   * Represents a numeric type Field Expression value.
   */
  private class NumberValue implements Value {
    private final Object value;

    /**
     * Constructs new NumberValue instance with given Integer
     */
    private NumberValue(Integer value) {
      this.value = value;
    }

    /**
     * Constructs new NumberValue instance with given Decimal
     */
    private NumberValue(Decimal value) {
      this.value = value;
    }

    /**
     * Constructs new NumberValue instance with given Double
     */
    private NumberValue(Double value) {
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
   * Composite interface that defines the structure of ConditionExpression component of WHERE clause.
   */
  private interface ConditionExpression {
    String toSOQLString();
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

  /**
   * WHERE clause Logical Operators. These are the Field Expression "joiners".
   */
  public enum LogicalOperator {
    ANDX,
    ORX
  }

  /**
   * Returns SOQL String form of given LogicalOperator
   * @return `String`
   */
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
