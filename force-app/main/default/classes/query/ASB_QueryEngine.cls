/**
 * @class ASB_QueryEngine
 * @description Encompasses concerns relating to any type of query.
 * @author Russell Laboe
 * @example
 *   ASB_QueryEngine engine = new ASB_QueryEngine(fromClause, selectClause);
 */
public with sharing class ASB_QueryEngine {
  private final ASB_Selectable asbSelect;
  private final ASB_FromClause asbFrom;
  private ASB_WhereClause asbWhere;
  private ASB_OrderByClause asbOrderBy;
  private ASB_LimitClause asbLimit;

  /**
   * @apexdoc
   * @description Constructs a new ASB_QueryEngine with the given FROM and SELECT clauses.
   * @param asbFrom The FROM clause.
   * @param asbSelect The SELECT clause.
   * @example
   *   ASB_QueryEngine engine = new ASB_QueryEngine(fromClause, selectClause);
   */
  public ASB_QueryEngine(ASB_FromClause asbFrom, ASB_Selectable asbSelect) {
    this.asbFrom = asbFrom;
    this.asbSelect = asbSelect.field(asbFrom.getIdField());
  }

  /**
   * @apexdoc
   * @description Returns the list of assigned query clauses.
   * @return List of ASB_Clause.
   * @example
   *   List<ASB_Clause> clauses = engine.getClauses();
   */
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

  /**
   * @apexdoc
   * @description Returns the SELECT clause.
   * @return ASB_Selectable
   * @example
   *   ASB_Selectable select = engine.getASBSelect();
   */
  public ASB_Selectable getASBSelect() {
    return asbSelect;
  }
  /**
   * @apexdoc
   * @description Returns the FROM clause.
   * @return ASB_FromClause
   * @example
   *   ASB_FromClause from = engine.getASBFrom();
   */
  public ASB_FromClause getASBFrom() {
    return asbFrom;
  }
  /**
   * @apexdoc
   * @description Returns the WHERE clause.
   * @return ASB_WhereClause
   * @example
   *   ASB_WhereClause where = engine.getASBWhere();
   */
  public ASB_WhereClause getASBWhere() {
    return asbWhere;
  }
  /**
   * @apexdoc
   * @description Returns the ORDER BY clause.
   * @return ASB_OrderByClause
   * @example
   *   ASB_OrderByClause orderBy = engine.getASBOrderBy();
   */
  public ASB_OrderByClause getASBOrderBy() {
    return asbOrderBy;
  }
  /**
   * @apexdoc
   * @description Returns the LIMIT clause.
   * @return ASB_LimitClause
   * @example
   *   ASB_LimitClause limit = engine.getASBLimit();
   */
  public ASB_LimitClause getASBLimit() {
    return asbLimit;
  }

  /**
   * @apexdoc
   * @description Sets the WHERE clause for the query.
   * @param asbWhere The WHERE clause to set.
   * @return ASB_QueryEngine for chaining.
   * @example
   *   engine.setWhere(asb.filter());
   */
  public ASB_QueryEngine setWhere(ASB_WhereClause asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }

  /**
   * @apexdoc
   * @description Sets the ORDER BY clause for the query.
   * @param asbOrderBy The ORDER BY clause to set.
   * @return ASB_QueryEngine for chaining.
   * @example
   *   engine.setOrderBy(asb.orderByField(Account.Name));
   */
  public ASB_QueryEngine setOrderBy(ASB_OrderByClause asbOrderBy) {
    this.asbOrderBy = asbOrderBy;
    return this;
  }

  /**
   * @apexdoc
   * @description Sets the LIMIT clause for the query.
   * @param limitx The record limit to set.
   * @return ASB_QueryEngine for chaining.
   * @example
   *   engine.setLimit(10);
   */
  public ASB_QueryEngine setLimit(Integer limitx) {
    this.asbLimit = new ASB_LimitClause(limitx);
    return this;
  }

  /**
   * @apexdoc
   * @description Converts the query to a SOQL string.
   * @param ctx The bind context for query string generation.
   * @return The SOQL string.
   * @example
   *   String soql = engine.queryDetail(new ASB_BindContext());
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
