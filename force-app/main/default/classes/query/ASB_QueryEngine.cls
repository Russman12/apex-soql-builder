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
 * @ignore
 * @description Encompasses concerns relating to any type of query.
 * @see ASB_QueryEngine
 * @see ASB_QueryBuilder
 */
public with sharing class ASB_QueryEngine {
  private final ASB_Selectable asbSelect;
  private final ASB_FromClause asbFrom;
  private ASB_WhereClause asbWhere;
  private ASB_OrderByClause asbOrderBy;
  private ASB_LimitClause asbLimit;

  /**
   * @description Constructs a new ASB_QueryEngine with the given FROM and SELECT clauses.
   * @param asbFrom The FROM clause.
   * @param asbSelect The SELECT clause.
   */
  public ASB_QueryEngine(ASB_FromClause asbFrom, ASB_Selectable asbSelect) {
    this.asbFrom = asbFrom;
    this.asbSelect = asbSelect.field(asbFrom.getIdField());
  }

  /**
   * @description Returns the list of assigned query clauses.
   * @return List of ASB_Clause.
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
   * @description Returns the SELECT clause.
   * @return ASB_Selectable
   */
  public ASB_Selectable getASBSelect() {
    return asbSelect;
  }
  /**
   * @description Returns the FROM clause.
   * @return ASB_FromClause
   */
  public ASB_FromClause getASBFrom() {
    return asbFrom;
  }
  /**
   * @description Returns the WHERE clause.
   * @return ASB_WhereClause
   */
  public ASB_WhereClause getASBWhere() {
    return asbWhere;
  }
  /**
   * @description Returns the ORDER BY clause.
   * @return ASB_OrderByClause
   */
  public ASB_OrderByClause getASBOrderBy() {
    return asbOrderBy;
  }
  /**
   * @description Returns the LIMIT clause.
   * @return ASB_LimitClause
   */
  public ASB_LimitClause getASBLimit() {
    return asbLimit;
  }

  /**
   * @description Sets the WHERE clause for the query.
   * @param asbWhere The WHERE clause to set.
   * @return ASB_QueryEngine for chaining.
   */
  public ASB_QueryEngine setWhere(ASB_WhereClause asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }

  /**
   * @description Sets the ORDER BY clause for the query.
   * @param asbOrderBy The ORDER BY clause to set.
   * @return ASB_QueryEngine for chaining.
   */
  public ASB_QueryEngine setOrderBy(ASB_OrderByClause asbOrderBy) {
    this.asbOrderBy = asbOrderBy;
    return this;
  }

  /**
   * @description Sets the LIMIT clause for the query.
   * @param limitx The record limit to set.
   * @return ASB_QueryEngine for chaining.
   */
  public ASB_QueryEngine setLimit(Integer limitx) {
    this.asbLimit = new ASB_LimitClause(limitx);
    return this;
  }

  /**
   * @description Converts the query to a SOQL string.
   * @param ctx The bind context for query string generation.
   * @return The SOQL string.
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
