/**
 * Encompasses functionality relating to building a WHERE clause.
 * @author Russell Laboe
 */
public class ASB_Where implements ASB_Clause, Expression {
  private final Expression expression;

  public ASB_Where(Expression expression) {
    this.expression = expression;
  }

  public String clauseString() {
    String queryString = this.expression.queryString();
    if (this.expression instanceof LogicalGroup) {
      queryString = queryString.removeStart('(').removeEnd(')');
    }
    return 'WHERE ' + queryString;
  }

  public String queryString() {
    return this.expression.queryString();
  }

  public interface Expression {
    String queryString();
  }

  private abstract class LogicalGroup implements Expression {
    private final List<Expression> expressions;
    private final String logicOperator;

    private LogicalGroup(List<Expression> expressions, String logicOperator) {
      Expression[] exps = new List<Expression>();
      for (Expression ex : expressions) {
        if (ex != null) {
          exps.add(ex);
        }
      }

      this.expressions = exps;
      this.logicOperator = logicOperator;
    }

    public String queryString() {
      return '(' + String.join(expStrings(), ' ' + this.logicOperator + ' ') + ')';
    }

    private List<String> expStrings() {
      String[] expStrs = new List<String>{};
      for (Expression exp : this.expressions) {
        expStrs.add(exp.queryString());
      }
      return expStrs;
    }
  }

  public class OrLogicalGroup extends LogicalGroup {
    public OrLogicalGroup(List<Expression> expressions) {
      super(expressions, 'OR');
    }
  }
  public class AndLogicalGroup extends LogicalGroup {
    public AndLogicalGroup(List<Expression> expressions) {
      super(expressions, 'AND');
    }
  }

  /**
   * Represents a Field Expression portion of a WHERE clause.
   */
  private class FieldExpression implements Expression {
    private final List<SObjectField> fieldPath;
    private final String comparisonOperator;
    private final String value;

    /**
     * Private constructor should only be called from within the parent class
     */
    private FieldExpression(List<SObjectField> fieldPath, String comparisonOperator, String value) {
      this.fieldPath = fieldPath;
      this.comparisonOperator = comparisonOperator;
      this.value = value;
    }

    private List<String> fieldPathStrings() {
      String[] fieldStrs = new List<String>{};
      for (Integer i = 0; i < this.fieldPath.size() - 1; i++) {
        fieldStrs.add(this.fieldPath[i].getDescribe().getRelationshipName());
      }
      fieldStrs.add(this.fieldPath[this.fieldPath.size() - 1].getDescribe().getName());
      return fieldStrs;
    }

    /**
     * Returns FeildExpression as a SOQL String
     * @return `String`
     */
    public String queryString() {
      return String.join(this.fieldPathStrings(), '.') + ' ' + this.comparisonOperator + ' ' + this.value;
    }
  }

  public class ComparisonOperator {
    private final Schema.SObjectField[] fieldPath;

    public ComparisonOperator(Schema.SObjectField[] fieldPath) {
      this.fieldPath = fieldPath;
    }

    public Value equals() {
      return new Value(fieldPath, '=');
    }
    public Value notEquals() {
      return new Value(fieldPath, '!=');
    }
    public Value isIn() {
      return new Value(fieldPath, 'IN');
    }
    public Value greaterThan() {
      return new Value(fieldPath, '>');
    }
    public Value lessThan() {
      return new Value(fieldPath, '<');
    }
    public Value isLike() {
      return new Value(fieldPath, 'LIKE');
    }
  }

  public class Value {
    private final Schema.SObjectField[] fieldPath;
    private final String operator;

    private Value(Schema.SObjectField[] fieldPath, String operator) {
      this.fieldPath = fieldPath;
      this.operator = operator;
    }

    public ASB_Where string(String str) {
      return new ASB_Where(new FieldExpression(this.fieldPath, this.operator, '\'' + str + '\''));
    }
    public ASB_Where bind(String paramName) {
      return new ASB_Where(new FieldExpression(this.fieldPath, this.operator, ':' + paramName));
    }
    public ASB_Where literal(String anyVal) {
      return new ASB_Where(new FieldExpression(this.fieldPath, this.operator, anyVal));
    }
  }
}
