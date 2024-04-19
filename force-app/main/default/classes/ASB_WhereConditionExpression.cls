public abstract class ASB_WhereConditionExpression implements ASB_SOQLClause {
  protected List<ASB_WhereConditionExpression> fieldExpressions;

  public abstract String toClauseString();

  public class ORComposite extends ASB_WhereConditionExpression {
    public ORComposite(List<ASB_WhereConditionExpression> fieldExpressions) {
      this.fieldExpressions = fieldExpressions;
    }

    public override String toClauseString() {
      String s = '';
      for (ASB_WhereConditionExpression fieldExp : this.fieldExpressions) {
        s += fieldExp.toClauseString() + ' OR ';
      }
      return s.remove(' OR ');
    }
  }

  public class ANDComposite extends ASB_WhereConditionExpression {
    public ANDComposite(List<ASB_WhereConditionExpression> fieldExpressions) {
      this.fieldExpressions = fieldExpressions;
    }

    public override String toClauseString() {
      String s = '';
      for (ASB_WhereConditionExpression fieldExp : this.fieldExpressions) {
        s += fieldExp.toClauseString() + ' AND ';
      }
      return s.remove(' AND ');
    }
  }
}
