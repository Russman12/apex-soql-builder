/**
 * SOQL WHERE clause.
 * @description This class encompasses functionality relating to building a WHERE clause. It ca
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Where implements ASB_Clause, Expression {
  public static final ComparisonOperator EQUALS = ComparisonOperator.EQUALS;
  public static final ComparisonOperator GREATER_THAN = ComparisonOperator.GREATER_THAN;
  public static final ComparisonOperator LESS_THAN = ComparisonOperator.LESS_THAN;
  public static final ComparisonOperator NOT_EQUALS = ComparisonOperator.NOT_EQUALS;
  public static final ComparisonOperator LIKEX = ComparisonOperator.LIKEX;
  public static final ComparisonOperator INX = ComparisonOperator.INX;

  public static ASB_Where make(Schema.SObjectField field, ComparisonOperator co, String value) {
    return make(new List<Schema.SObjectField>{ field }, co, value);
  }
  public static ASB_Where make(
    Schema.SObjectField relationshipField,
    Schema.SObjectField parentField,
    ComparisonOperator co,
    String value
  ) {
    return make(new List<Schema.SObjectField>{ relationshipField, parentField }, co, value);
  }
  public static ASB_Where make(List<Schema.SObjectField> fieldPath, ComparisonOperator co, String value) {
    return new ASB_Where(new FieldExpression(fieldPath, co, value));
  }

  public static ASB_Where andx(ASB_Where exp1, ASB_Where exp2) {
    return andx(new List<ASB_Where>{ exp1, exp2 });
  }
  public static ASB_Where andx(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3) {
    return andx(new List<ASB_Where>{ exp1, exp2, exp3 });
  }
  public static ASB_Where andx(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3, ASB_Where exp4) {
    return andx(new List<ASB_Where>{ exp1, exp2, exp3, exp4 });
  }
  public static ASB_Where andx(ASB_Where[] expressions) {
    return new ASB_Where(new LogicalGroup(expressions, LogicalOperator.ANDX));
  }

  public static ASB_Where orx(ASB_Where exp1, ASB_Where exp2) {
    return orx(new List<ASB_Where>{ exp1, exp2 });
  }
  public static ASB_Where orx(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3) {
    return orx(new List<ASB_Where>{ exp1, exp2, exp3 });
  }
  public static ASB_Where orx(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3, ASB_Where exp4) {
    return orx(new List<ASB_Where>{ exp1, exp2, exp3, exp4 });
  }
  public static ASB_Where orx(ASB_Where[] expressions) {
    return new ASB_Where(new LogicalGroup(expressions, LogicalOperator.ORX));
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

  public interface Expression {
    String queryString();
  }

  private class LogicalGroup implements Expression {
    private final List<Expression> expressions;
    private final ASB_Where.LogicalOperator logicOperator;

    private LogicalGroup(List<Expression> expressions, LogicalOperator logicOperator) {
      this.expressions = expressions;
      this.logicOperator = logicOperator;
    }

    public String queryString() {
      return '(' + String.join(expStrings(), ' ' + logicalOpVal(this.logicOperator) + ' ') + ')';
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
    private final ComparisonOperator comparisonOperator;
    private final String value;

    /**
     * Private constructor should only be called from within the parent class
     */
    private FieldExpression(List<SObjectField> fieldPath, ComparisonOperator operator, String value) {
      this.fieldPath = fieldPath;
      this.comparisonOperator = operator;
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
      return String.join(this.fieldPathStrings(), '.') +
        ' ' +
        comparisonOpVal(this.comparisonOperator) +
        ' ' +
        this.value;
    }
  }

  /**
   * WHERE clause Comparison Operators. Used to compare a field with a value.
   */
  public enum ComparisonOperator {
    EQUALS,
    GREATER_THAN,
    LESS_THAN,
    NOT_EQUALS,
    LIKEX,
    INX
  }
  private static String comparisonOpVal(ComparisonOperator co) {
    switch on co {
      when NOT_EQUALS {
        return '!=';
      }
      when LIKEX {
        return 'LIKE';
      }
      when GREATER_THAN {
        return '>';
      }
      when LESS_THAN {
        return '<';
      }
      when INX {
        return 'IN';
      }
      when else {
        return '=';
      }
    }
  }

  private enum LogicalOperator {
    ANDX,
    ORX
  }
  private static String logicalOpVal(LogicalOperator lo) {
    switch on lo {
      when ORX {
        return 'OR';
      }
      when else {
        return 'AND';
      }
    }
  }
}
