/**
 * Encompasses functionality relating to building a WHERE clause.
 * @author Russell Laboe
 */
public class ASB_Where implements ASB_Clause, Expression {
  public static ComparisonOperator field(Schema.SObjectField field) {
    return field(new List<Schema.SObjectField>{ field });
  }
  public static ComparisonOperator field(Schema.SObjectField relationshipField, Schema.SObjectField parentField) {
    return field(new List<Schema.SObjectField>{ relationshipField, parentField });
  }
  public static ComparisonOperator field(Schema.SObjectField[] fieldPath) {
    return new ComparisonOperator(fieldPath);
  }

  public static ASB_Where groupAnd(ASB_Where exp1, ASB_Where exp2) {
    return groupAnd(new List<ASB_Where>{ exp1, exp2 });
  }
  public static ASB_Where groupAnd(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3) {
    return groupAnd(new List<ASB_Where>{ exp1, exp2, exp3 });
  }
  public static ASB_Where groupAnd(ASB_Where[] expressions) {
    return new ASB_Where(new LogicalGroup(expressions, 'AND'));
  }

  public static ASB_Where groupOr(ASB_Where exp1, ASB_Where exp2) {
    return groupOr(new List<ASB_Where>{ exp1, exp2 });
  }
  public static ASB_Where groupOr(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3) {
    return groupOr(new List<ASB_Where>{ exp1, exp2, exp3 });
  }
  public static ASB_Where groupOr(ASB_Where[] expressions) {
    return new ASB_Where(new LogicalGroup(expressions, 'OR'));
  }

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

  private interface Expression {
    String queryString();
  }

  private class LogicalGroup implements Expression {
    private final List<Expression> expressions;
    private final String logicOperator;

    private LogicalGroup(List<Expression> expressions, String logicOperator) {
      this.expressions = expressions;
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

    private ComparisonOperator(Schema.SObjectField[] fieldPath) {
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
