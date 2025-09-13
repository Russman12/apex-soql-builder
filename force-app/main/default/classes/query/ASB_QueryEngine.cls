/**
 * Encompasses concerns relating to any type of query.
 * @author Russell Laboe
 */
public with sharing class ASB_QueryEngine {
  private final ASB_Selectable asbSelect;
  private final ASB_FromClause asbFrom;
  private ASB_WhereClause asbWhere;
  private ASB_OrderByClause asbOrderBy;
  private ASB_LimitClause asbLimit;

  public ASB_QueryEngine(ASB_FromClause asbFrom, ASB_Selectable asbSelect) {
    this.asbFrom = asbFrom;
    this.asbSelect = asbSelect.field(asbFrom.getIdField());
  }

  public virtual ASB_Clause[] getClauses() {
    List<ASB_Clause> assignedClauses = new List<ASB_Clause>();
    for (
      ASB_Clause clause : new List<ASB_Clause>{
        this.asbSelect,
        this.asbFrom,
        this.asbWhere,
        this.asbOrderBy,
        this.asbLimit
      }
    ) {
      if (clause != null) {
        assignedClauses.add(clause);
      }
    }
    return assignedClauses;
  }

  public ASB_Selectable getASBSelect() {
    return asbSelect;
  }
  public ASB_FromClause getASBFrom() {
    return asbFrom;
  }
  public ASB_WhereClause getASBWhere() {
    return asbWhere;
  }
  public ASB_OrderByClause getASBOrderBy() {
    return asbOrderBy;
  }
  public ASB_LimitClause getASBLimit() {
    return asbLimit;
  }

  public void mergeSelect(ASB_Selectable asbSelect) {
    this.mergeSelect(asbSelect);
  }

  public ASB_QueryEngine setWhere(ASB_WhereClause asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }

  public ASB_QueryEngine setOrderBy(ASB_OrderByClause asbOrderBy) {
    this.asbOrderBy = asbOrderBy;
    return this;
  }

  public ASB_QueryEngine setLimit(Integer limitx) {
    this.asbLimit = new ASB_LimitClause(limitx);
    return this;
  }

  /**
   * Converts SubQuery to SOQL string.
   * @return  `String`
   */
  public String queryDetail(ASB_BindContext ctx) {
    String[] strs = new List<String>{};
    for (ASB_Clause clause : this.getClauses()) {
      if (clause != null) {
        strs.add(clause.clauseString(ctx));
      }
    }
    return String.join(strs, ' ');
  }
}
