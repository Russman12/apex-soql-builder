public with sharing class ASB_SOQL {
  private static ASB_SOQL instance;

  public static ASB_SOQL instance() {
    if (instance == null) {
      instance = new ASB_SOQL();
    }
    return instance;
  }

  private ASB_SOQL() {
  }

  public Builder builder(SObjectType fromSObjType) {
    return new Builder(fromSObjType);
  }

  public class SOQL {
    private final List<Clause> clauses;

    private SOQL(ASB_Select selectx, ASB_From fromx, ASB_Where wherex, ASB_Limit limitx) {
      this.clauses = new List<Clause>{ selectx, fromx, wherex, limitx };
    }

    public String queryString() {
      String queryStr = '';
      for (Clause clause : this.clauses) {
        if (clause != null) {
          queryStr += clause.toClauseString() + ' ';
        }
      }

      return queryStr.trim();
    }
  }

  public class Builder {
    private final ASB_Select selectElements;
    private final ASB_From fromSObjectType;
    private ASB_Where whereClause;
    private ASB_Limit limitx;

    private Builder(SObjectType fromSObjType) {
      this.fromSObjectType = new ASB_From(fromSObjType);
      this.selectElements = new ASB_Select(
        new Set<ASB_Select.SelectElement>{
          new ASB_Select.Field(fromSObjType.getDescribe().Fields.getMap().get('Id'))
        }
      );
    }

    public Builder selectx(SObjectField field) {
      this.selectElements.add(new ASB_Select.Field(field));
      return this;
    }

    public Builder wherex(ASB_Where whereClause) {
      this.whereClause = whereClause;
      return this;
    }

    public Builder limitx(Integer limitx) {
      this.limitx = new ASB_Limit(limitx);
      return this;
    }

    public ASB_SOQL.SOQL build() {
      return new ASB_SOQL.SOQL(
        this.selectElements,
        this.fromSObjectType,
        this.whereClause,
        this.limitx
      );
    }
  }

  public interface Clause {
    String toClauseString();
  }
}
