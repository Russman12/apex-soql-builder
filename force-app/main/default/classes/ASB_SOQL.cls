public with sharing class ASB_SOQL {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.USER_MODE;
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
    private final AccessLevel accessLevel;

    private SOQL(
      ASB_Select selectx,
      ASB_From fromx,
      ASB_Where wherex,
      ASB_Limit limitx,
      AccessLevel accessLevel
    ) {
      this.clauses = new List<Clause>{ selectx, fromx, wherex, limitx };
      this.accessLevel = accessLevel;
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

    public List<SObject> query() {
      return Database.query(this.queryString(), this.accessLevel);
    }

    public List<SObject> query(Map<String, Object> bindMap) {
      return Database.queryWithBinds(this.queryString(), bindMap, this.accessLevel);
    }

    public SObject querySingle() {
      return Database.query(this.queryString(), this.accessLevel);
    }

    public SObject querySingle(Map<String, Object> bindMap) {
      return Database.queryWithBinds(this.queryString(), bindMap, this.accessLevel);
    }
  }

  public class Builder {
    private final ASB_Select selectElements;
    private final ASB_From fromSObjectType;
    private ASB_Where whereClause;
    private ASB_Limit limitx;
    private AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

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

    public Builder accessLevel(AccessLevel accessLevel) {
      this.accessLevel = accessLevel;
      return this;
    }

    public ASB_SOQL.SOQL build() {
      return new ASB_SOQL.SOQL(
        this.selectElements,
        this.fromSObjectType,
        this.whereClause,
        this.limitx,
        this.accessLevel
      );
    }
  }

  public interface Clause {
    String toClauseString();
  }
}
