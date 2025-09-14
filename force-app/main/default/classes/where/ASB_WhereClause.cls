/*
Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/**
 * @description Encompasses functionality relating to building a WHERE clause for SOQL queries.
 * @group Clause
 * @example
 * ```
 *   ASB_WhereClause where = new ASB().filter().field(Account.Name).eq('Acme');
 *   String soql = where.clauseString(new ASB_BindContext());
 * ```
 */
public with sharing class ASB_WhereClause implements ASB_Clause, Expression {
  private final Expression expression;

  /**
   * @description Constructs a new ASB_WhereClause with the given expression.
   * @param expression The expression to use for the WHERE clause.
   * @example
   * ```
   *   ASB_WhereClause where = new ASB_WhereClause(new ASB_WhereClause.FieldComparison(new List<Schema.SObjectField>{ Account.Name }).eq('Acme'));
   * ```
   */
  public ASB_WhereClause(Expression expression) {
    this.expression = expression;
  }

  /**
   * @description Returns the WHERE clause as a query string.
   * @param ctx The bind context for query string generation.
   * @return String The WHERE clause as a string.
   * @example
   * ```
   *   String soql = new ASB().filter().field(Account.Name).eq('Acme').clauseString(new ASB_BindContext());
   * ```
   */
  public String clauseString(ASB_BindContext ctx) {
    String queryString = this.expression.queryString(ctx);
    if (this.expression instanceof LogicalGroup) {
      queryString = queryString.removeStart('(').removeEnd(')');
    }
    return 'WHERE ' + queryString;
  }

  /**
   * @description Returns the query string for the expression (without WHERE keyword).
   * @param ctx The bind context for query string generation.
   * @return String The expression as a string.
   * @example
   * ```
   *   String expr = new ASB().filter().field(Account.Name).eq('Acme').queryString(new ASB_BindContext());
   * ```
   */
  public String queryString(ASB_BindContext ctx) {
    return this.expression.queryString(ctx);
  }

  /**
   * @description Builder for constructing WHERE clause expressions.
   * @example
   * ```
   *   ASB_WhereClause.Builder builder = new ASB().filter();
   *   ASB_WhereClause where = builder.field(Account.Name).eq('Acme');
   * ```
   */
  public class Builder {
    /**
     * @description Adds a field to the WHERE clause.
     * @param field The field to compare.
     * @return FieldComparison for chaining.
     * @example
     * ```
     *   new ASB().filter().field(Account.Name);
     * ```
     */
    public FieldComparison field(Schema.SObjectField field) {
      return this.field(new List<Schema.SObjectField>{ field });
    }
    /**
     * @description Adds a parent field to the WHERE clause using two fields.
     * @param relationshipField The relationship field.
     * @param parentField The parent field.
     * @return FieldComparison for chaining.
     * @example
     * ```
     *   new ASB().filter().field(Account.OwnerId, User.Name);
     * ```
     */
    public FieldComparison field(Schema.SObjectField relationshipField, Schema.SObjectField parentField) {
      return this.field(new List<Schema.SObjectField>{ relationshipField, parentField });
    }
    /**
     * @description Adds a field path to the WHERE clause.
     * @param fieldPath The field path as a list.
     * @return FieldComparison for chaining.
     * @example
     * ```
     *   new ASB().filter().field(new List<Schema.SObjectField>{ Account.OwnerId, User.Name });
     * ```
     */
    public FieldComparison field(Schema.SObjectField[] fieldPath) {
      return new FieldComparison(fieldPath);
    }

    /**
     * @description Creates an AND group of WHERE clauses.
     * @param exp1 First expression.
     * @param exp2 Second expression.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().andGroup(where1, where2);
     * ```
     */
    public ASB_WhereClause andGroup(ASB_WhereClause exp1, ASB_WhereClause exp2) {
      return andGroup(new List<ASB_WhereClause>{ exp1, exp2 });
    }
    /**
     * @description Creates an AND group of three WHERE clauses.
     * @param exp1 First expression.
     * @param exp2 Second expression.
     * @param exp3 Third expression.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().andGroup(where1, where2, where3);
     * ```
     */
    public ASB_WhereClause andGroup(ASB_WhereClause exp1, ASB_WhereClause exp2, ASB_WhereClause exp3) {
      return andGroup(new List<ASB_WhereClause>{ exp1, exp2, exp3 });
    }
    /**
     * @description Creates an AND group from a list of WHERE clauses.
     * @param expressions List of expressions.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().andGroup(new List<ASB_WhereClause>{ where1, where2 });
     * ```
     */
    public ASB_WhereClause andGroup(ASB_WhereClause[] expressions) {
      return new ASB_WhereClause(new AndLogicalGroup(expressions));
    }

    /**
     * @description Creates an OR group of WHERE clauses.
     * @param exp1 First expression.
     * @param exp2 Second expression.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().orGroup(where1, where2);
     * ```
     */
    public ASB_WhereClause orGroup(ASB_WhereClause exp1, ASB_WhereClause exp2) {
      return orGroup(new List<ASB_WhereClause>{ exp1, exp2 });
    }
    /**
     * @description Creates an OR group of three WHERE clauses.
     * @param exp1 First expression.
     * @param exp2 Second expression.
     * @param exp3 Third expression.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().orGroup(where1, where2, where3);
     * ```
     */
    public ASB_WhereClause orGroup(ASB_WhereClause exp1, ASB_WhereClause exp2, ASB_WhereClause exp3) {
      return orGroup(new List<ASB_WhereClause>{ exp1, exp2, exp3 });
    }
    /**
     * @description Creates an OR group from a list of WHERE clauses.
     * @param expressions List of expressions.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().orGroup(new List<ASB_WhereClause>{ where1, where2 });
     * ```
     */
    public ASB_WhereClause orGroup(ASB_WhereClause[] expressions) {
      return new ASB_WhereClause(new OrLogicalGroup(expressions));
    }
  }

  public interface Expression {
    /**
     * Returns query string and puts bindings in given bindings map
     */
    String queryString(ASB_BindContext ctx);
  }

  private abstract class LogicalGroup implements Expression {
    private final List<Expression> expressions;
    private final String logicOperator;

    private LogicalGroup(List<Expression> expressions, String logicOperator) {
      this.expressions = new List<Expression>();
      for (Expression ex : expressions) {
        if (ex != null) {
          this.expressions.add(ex);
        }
      }
      this.logicOperator = logicOperator;
    }

    public String queryString(ASB_BindContext ctx) {
      List<String> parts = new List<String>();
      for (Expression exp : this.expressions) {
        parts.add(exp.queryString(ctx));
      }
      return '(' + String.join(parts, ' ' + this.logicOperator + ' ') + ')';
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
   * @description FieldComparison provides methods to build WHERE clause comparisons for a field or field path.
   * @example
   * ```
   *   ASB_WhereClause.FieldComparison cmp = new ASB().filter().field(Account.Name);
   *   ASB_WhereClause where = cmp.eq('Acme');
   * ```
   */
  public class FieldComparison {
    private final List<Schema.SObjectField> fieldPath;

    /**
     * @description Constructs a FieldComparison for the given field path.
     * @param fieldPath The field path as a list.
     * @example
     * ```
     *   new ASB().filter().field(new List<Schema.SObjectField>{ Account.Name });
     * ```
     */
    public FieldComparison(List<Schema.SObjectField> fieldPath) {
      this.fieldPath = fieldPath;
    }

    /**
     * @description Adds an equals comparison to the WHERE clause for a String value.
     * @param str The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.Name).eq('Acme');
     * ```
     */
    public ASB_WhereClause eq(String str) {
      return makeEQ(str);
    }
    /**
     * @description Adds an equals comparison to the WHERE clause for an Integer value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.NumberOfEmployees).eq(10);
     * ```
     */
    public ASB_WhereClause eq(Integer val) {
      return makeEQ(val);
    }
    /**
     * @description Adds an equals comparison to the WHERE clause for a Decimal value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.AnnualRevenue).eq(100000.0);
     * ```
     */
    public ASB_WhereClause eq(Decimal val) {
      return makeEQ(val);
    }
    /**
     * @description Adds an equals comparison to the WHERE clause for a Date value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.CreatedDate).eq(Date.today());
     * ```
     */
    public ASB_WhereClause eq(Date val) {
      return makeEQ(val);
    }
    /**
     * @description Adds an equals comparison to the WHERE clause for a Datetime value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.CreatedDate).eq(Datetime.now());
     * ```
     */
    public ASB_WhereClause eq(Datetime val) {
      return makeEQ(val);
    }
    /**
     * @description Adds an equals comparison to the WHERE clause for a Boolean value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.IsActive__c).eq(true);
     * ```
     */
    public ASB_WhereClause eq(Boolean val) {
      return makeEQ(val);
    }
    /**
     * @description Adds an IS NULL comparison to the WHERE clause.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.Name).isNull();
     * ```
     */
    public ASB_WhereClause isNull() {
      return makeEQ(null);
    }

    private ASB_WhereClause makeEQ(Object val) {
      return makeWhere('=', val);
    }

    /**
     * @description Adds a not equals comparison to the WHERE clause for a String value.
     * @param str The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.Name).ne('Acme');
     * ```
     */
    public ASB_WhereClause ne(String str) {
      return makeNE(str);
    }
    /**
     * @description Adds a not equals comparison to the WHERE clause for an Integer value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.NumberOfEmployees).ne(10);
     * ```
     */
    public ASB_WhereClause ne(Integer val) {
      return makeNE(val);
    }
    /**
     * @description Adds a not equals comparison to the WHERE clause for a Decimal value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.AnnualRevenue).ne(100000.0);
     * ```
     */
    public ASB_WhereClause ne(Decimal val) {
      return makeNE(val);
    }
    /**
     * @description Adds a not equals comparison to the WHERE clause for a Date value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.CreatedDate).ne(Date.today());
     * ```
     */
    public ASB_WhereClause ne(Date val) {
      return makeNE(val);
    }
    /**
     * @description Adds a not equals comparison to the WHERE clause for a Datetime value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.CreatedDate).ne(Datetime.now());
     * ```
     */
    public ASB_WhereClause ne(Datetime val) {
      return makeNE(val);
    }
    /**
     * @description Adds a not equals comparison to the WHERE clause for a Boolean value.
     * @param val The value to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.IsActive__c).ne(false);
     * ```
     */
    public ASB_WhereClause ne(Boolean val) {
      return makeNE(val);
    }
    /**
     * @description Adds an IS NOT NULL comparison to the WHERE clause.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.Name).isNotNull();
     * ```
     */
    public ASB_WhereClause isNotNull() {
      return makeNE(null);
    }

    private ASB_WhereClause makeNE(Object val) {
      return makeWhere('!=', val);
    }

    /**
     * @description Adds a greater than comparison to the WHERE clause.
     * @param val The value to compare (Integer, Decimal, Date, or Datetime).
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.NumberOfEmployees).gt(10);
     * ```
     */
    public ASB_WhereClause gt(Integer val) {
      return makeGT(val);
    }
    public ASB_WhereClause gt(Decimal val) {
      return makeGT(val);
    }
    public ASB_WhereClause gt(Date val) {
      return makeGT(val);
    }
    public ASB_WhereClause gt(Datetime val) {
      return makeGT(val);
    }

    private ASB_WhereClause makeGT(Object val) {
      return makeWhere('>', val);
    }

    /**
     * @description Adds a greater than or equal to comparison to the WHERE clause.
     * @param val The value to compare (Integer, Decimal, Date, or Datetime).
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.NumberOfEmployees).gte(10);
     * ```
     */
    public ASB_WhereClause gte(Integer val) {
      return makeGTE(val);
    }
    public ASB_WhereClause gte(Decimal val) {
      return makeGTE(val);
    }
    public ASB_WhereClause gte(Date val) {
      return makeGTE(val);
    }
    public ASB_WhereClause gte(Datetime val) {
      return makeGTE(val);
    }

    private ASB_WhereClause makeGTE(Object val) {
      return makeWhere('>=', val);
    }

    /**
     * @description Adds a less than comparison to the WHERE clause.
     * @param val The value to compare (Integer, Decimal, Date, or Datetime).
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.NumberOfEmployees).lt(10);
     * ```
     */
    public ASB_WhereClause lt(Integer val) {
      return makeLT(val);
    }
    public ASB_WhereClause lt(Decimal val) {
      return makeLT(val);
    }
    public ASB_WhereClause lt(Date val) {
      return makeLT(val);
    }
    public ASB_WhereClause lt(Datetime val) {
      return makeLT(val);
    }

    private ASB_WhereClause makeLT(Object val) {
      return makeWhere('<', val);
    }

    /**
     * @description Adds a less than or equal to comparison to the WHERE clause.
     * @param val The value to compare (Integer, Decimal, Date, or Datetime).
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.NumberOfEmployees).lte(10);
     * ```
     */
    public ASB_WhereClause lte(Integer val) {
      return makeLTE(val);
    }
    public ASB_WhereClause lte(Decimal val) {
      return makeLTE(val);
    }
    public ASB_WhereClause lte(Date val) {
      return makeLTE(val);
    }
    public ASB_WhereClause lte(Datetime val) {
      return makeLTE(val);
    }

    private ASB_WhereClause makeLTE(Object val) {
      return makeWhere('<=', val);
    }

    /**
     * @description Adds an IN comparison to the WHERE clause.
     * @param vals The list of values to compare.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.Name).isIn(new List<String>{'Acme', 'Beta'});
     * ```
     */
    public ASB_WhereClause isIn(List<Object> vals) {
      return makeWhere('IN', vals);
    }

    /**
     * @description Adds a LIKE comparison to the WHERE clause.
     * @param pattern The pattern to match.
     * @return ASB_WhereClause
     * @example
     * ```
     *   new ASB().filter().field(Account.Name).isLike('A%');
     * ```
     */
    public ASB_WhereClause isLike(String pattern) {
      return makeWhere('LIKE', pattern);
    }

    // --- Helper to construct WHERE ---
    private ASB_WhereClause makeWhere(String op, Object val) {
      return new ASB_WhereClause(new FieldExpression(this.fieldPath, op, val));
    }
  }

  /**
   * Represents a Field Expression portion of a WHERE clause.
   */
  public class FieldExpression implements Expression {
    private final List<SObjectField> fieldPath;
    private final String comparisonOperator;
    private final Object value;

    private String fieldPathString;

    private FieldExpression(List<SObjectField> fieldPath, String comparisonOperator, Object value) {
      this.fieldPath = fieldPath;
      this.comparisonOperator = comparisonOperator;
      this.value = value;
    }

    private String fieldPathString() {
      if (fieldPathString == null) {
        List<String> fieldStrs = new List<String>();
        for (Integer i = 0; i < fieldPath.size() - 1; i++) {
          fieldStrs.add(fieldPath[i].getDescribe().getRelationshipName());
        }
        fieldStrs.add(fieldPath[fieldPath.size() - 1].getDescribe().getName());
        fieldPathString = String.join(fieldStrs, '.');
      }
      return fieldPathString;
    }

    public String queryString(ASB_BindContext ctx) {
      String prefix = fieldPathString().right(40).replaceAll('_', '').replaceAll('\\.', '_').removeStart('_');
      String bindToken = ctx.bind(this, value, prefix);
      return fieldPathString() + ' ' + comparisonOperator + ' ' + bindToken;
    }
  }
}
