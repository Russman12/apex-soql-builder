/**
 * Encompasses functionality relating to building a WHERE clause.
 * @author Russell Laboe
 */
public with sharing class ASB_Where implements ASB_Clause, Expression {
  private static final String BIND_PREFIX = 'WHERE_';
  private final Expression expression;

  public ASB_Where(Expression expression) {
    this.expression = expression;
  }

  public ASB_ClauseDetail clauseDetail() {
    Map<String, Object> bindings = new Map<String, Object>();
    String queryString = this.expression.queryString(bindings);
    if (this.expression instanceof LogicalGroup) {
      queryString = queryString.removeStart('(').removeEnd(')');
    }

    return new ASB_ClauseDetail('WHERE ' + queryString, bindings);
  }

  public String queryString(Map<String, Object> bindings) {
    return this.expression.queryString(bindings);
  }

  public class Builder {
    public FieldComparison field(Schema.SObjectField field) {
      return this.field(new List<Schema.SObjectField>{ field });
    }
    public FieldComparison field(Schema.SObjectField relationshipField, Schema.SObjectField parentField) {
      return this.field(new List<Schema.SObjectField>{ relationshipField, parentField });
    }
    public FieldComparison field(Schema.SObjectField[] fieldPath) {
      return new FieldComparison(fieldPath);
    }

    public ASB_Where andGroup(ASB_Where exp1, ASB_Where exp2) {
      return andGroup(new List<ASB_Where>{ exp1, exp2 });
    }
    public ASB_Where andGroup(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3) {
      return andGroup(new List<ASB_Where>{ exp1, exp2, exp3 });
    }
    public ASB_Where andGroup(ASB_Where[] expressions) {
      return new ASB_Where(new ASB_Where.AndLogicalGroup(expressions));
    }

    public ASB_Where orGroup(ASB_Where exp1, ASB_Where exp2) {
      return orGroup(new List<ASB_Where>{ exp1, exp2 });
    }
    public ASB_Where orGroup(ASB_Where exp1, ASB_Where exp2, ASB_Where exp3) {
      return orGroup(new List<ASB_Where>{ exp1, exp2, exp3 });
    }
    public ASB_Where orGroup(ASB_Where[] expressions) {
      return new ASB_Where(new ASB_Where.OrLogicalGroup(expressions));
    }
  }

  public interface Expression {
    /**
     * Returns query string and puts bindings in given bindings map
     */
    String queryString(Map<String, Object> bindings);
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

    public String queryString(Map<String, Object> bindings) {
      return '(' + String.join(expStrings(bindings), ' ' + this.logicOperator + ' ') + ')';
    }

    private List<String> expStrings(Map<String, Object> bindings) {
      String[] expStrs = new List<String>{};
      for (Expression exp : this.expressions) {
        expStrs.add(exp.queryString(bindings));
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

  public class FieldComparison {
    private final List<Schema.SObjectField> fieldPath;

    public FieldComparison(List<Schema.SObjectField> fieldPath) {
      this.fieldPath = fieldPath;
    }

    // --- equals ---
    public ASB_Where eq(String str) {
      return makeEQ(str);
    }
    public ASB_Where eq(Integer val) {
      return makeEQ(val);
    }
    public ASB_Where eq(Decimal val) {
      return makeEQ(val);
    }
    public ASB_Where eq(Date val) {
      return makeEQ(val);
    }
    public ASB_Where eq(Datetime val) {
      return makeEQ(val);
    }
    public ASB_Where eq(Boolean val) {
      return makeEQ(val);
    }
    public ASB_Where isNull() {
      return makeEQ(null);
    }

    private ASB_Where makeEQ(Object val) {
      return makeWhere('=', val);
    }

    // --- not equals ---
    public ASB_Where ne(String str) {
      return makeNE(str);
    }
    public ASB_Where ne(Integer val) {
      return makeNE(val);
    }
    public ASB_Where ne(Decimal val) {
      return makeNE(val);
    }
    public ASB_Where ne(Date val) {
      return makeNE(val);
    }
    public ASB_Where ne(Datetime val) {
      return makeNE(val);
    }
    public ASB_Where ne(Boolean val) {
      return makeNE(val);
    }
    public ASB_Where isNotNull() {
      return makeNE(null);
    }

    private ASB_Where makeNE(Object val) {
      return makeWhere('!=', val);
    }

    // --- greater than ---
    public ASB_Where gt(Integer val) {
      return makeGT(val);
    }
    public ASB_Where gt(Decimal val) {
      return makeGT(val);
    }
    public ASB_Where gt(Date val) {
      return makeGT(val);
    }
    public ASB_Where gt(Datetime val) {
      return makeGT(val);
    }

    private ASB_Where makeGT(Object val) {
      return makeWhere('>', val);
    }

    // --- greater than or equal to ---
    public ASB_Where gte(Integer val) {
      return makeGTE(val);
    }
    public ASB_Where gte(Decimal val) {
      return makeGTE(val);
    }
    public ASB_Where gte(Date val) {
      return makeGTE(val);
    }
    public ASB_Where gte(Datetime val) {
      return makeGTE(val);
    }

    private ASB_Where makeGTE(Object val) {
      return makeWhere('>=', val);
    }

    // --- less than ---
    public ASB_Where lt(Integer val) {
      return makeLT(val);
    }
    public ASB_Where lt(Decimal val) {
      return makeLT(val);
    }
    public ASB_Where lt(Date val) {
      return makeLT(val);
    }
    public ASB_Where lt(Datetime val) {
      return makeLT(val);
    }

    private ASB_Where makeLT(Object val) {
      return makeWhere('<', val);
    }

    // --- less than or equal to ---
    public ASB_Where lte(Integer val) {
      return makeLTE(val);
    }
    public ASB_Where lte(Decimal val) {
      return makeLTE(val);
    }
    public ASB_Where lte(Date val) {
      return makeLTE(val);
    }
    public ASB_Where lte(Datetime val) {
      return makeLTE(val);
    }

    private ASB_Where makeLTE(Object val) {
      return makeWhere('<=', val);
    }

    // --- IN ---
    public ASB_Where isIn(List<Object> vals) {
      return makeWhere('IN', vals);
    }

    // --- LIKE ---
    public ASB_Where isLike(String pattern) {
      return makeWhere('LIKE', pattern);
    }

    // --- Helper to construct WHERE ---
    private ASB_Where makeWhere(String op, Object val) {
      return new ASB_Where(new FieldExpression(this.fieldPath, op, val));
    }
  }

  /**
   * Represents a Field Expression portion of a WHERE clause.
   */
  public class FieldExpression implements ASB_Where.Expression {
    private final List<SObjectField> fieldPath;
    private final String comparisonOperator;
    private final Object value;
    private String bindPrefix;

    private String fieldPathString;
    private String bindName;

    /**
     * Private constructor should only be called from within the parent class
     */
    private FieldExpression(List<SObjectField> fieldPath, String comparisonOperator, Object value) {
      this.fieldPath = fieldPath;
      this.comparisonOperator = comparisonOperator;
      this.value = value;
    }

    public void putBindings(Map<String, Object> bindings) {
      Integer counter = 0;
      String bindName;
      do {
        counter++;
        bindName = bindPrefix() + counter;
      } while (bindings.containsKey(bindName));

      this.bindName = bindName;
      bindings.put(bindName, this.value);
    }

    private String bindPrefix() {
      if (bindPrefix == null) {
        // bind prefix must be less than 255 chars, cannot have '.' chars, and cannot start with '_'
        this.bindPrefix =
          ASB_Where.BIND_PREFIX +
          fieldPathString().right(40).replaceAll('_', '').replaceAll('\\.', '_').removeStart('_');
      }
      return this.bindPrefix;
    }

    private String fieldPathString() {
      if (fieldPathString == null) {
        String[] fieldStrs = new List<String>{};
        for (Integer i = 0; i < this.fieldPath.size() - 1; i++) {
          fieldStrs.add(this.fieldPath[i].getDescribe().getRelationshipName());
        }
        fieldStrs.add(this.fieldPath[this.fieldPath.size() - 1].getDescribe().getName());
        this.fieldPathString = String.join(fieldStrs, '.');
      }
      return this.fieldPathString;
    }

    /**
     * Returns FeildExpression as a SOQL String
     * @return `String`
     */
    public String queryString(Map<String, Object> bindings) {
      this.putBindings(bindings);
      String str = this.fieldPathString() + ' ' + this.comparisonOperator + ' :' + this.bindName;
      return str;
    }
  }
}
