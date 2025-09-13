/**
 * Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * @class ASB_QueryBuilder
 * @description Entry point of Apex SOQL Builder. This class encompasses functionality relating to building a SOQL query.
 * @author Russell Laboe
 * @example
 *   List<Account> accs = (List<Account>)new ASB().make(Account.SObjectType)
 *     .selection(new ASB().selection().field(Account.Name))
 *     .filter(asb.filter())
 *     .orderBy(asb.orderByField(Account.Name))
 *     .recordLimit(10)
 *     .query();
 */
public with sharing class ASB_QueryBuilder {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  public System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;
  @testVisible
  private final ASB_QueryEngine queryEngine;
  private final ASB_SelectClause selectClause;

  /**
   * @apexdoc
   * @description Constructs a new ASB_QueryBuilder with the given FROM and SELECT clauses.
   * @param fromSObj The FROM clause for the query.
   * @param selectClause The SELECT clause for the query.
   * @example
   *   ASB_QueryBuilder builder = new ASB().make(Account.SObjectType);
   */
  public ASB_QueryBuilder(ASB_FromSObjectClause fromSObj, ASB_SelectClause selectClause) {
    this.queryEngine = new ASB_QueryEngine(fromSObj, selectClause);
    this.selectClause = selectClause;
  }

  /**
   * @apexdoc
   * @description Sets the select portion of the query.
   * @param selectClause The select clause to merge.
   * @return ASB_QueryBuilder for chaining.
   * @example
   *   new ASB().make(Account.SObjectType).selection(new ASB().selection().field(Account.Name));
   */
  public ASB_QueryBuilder selection(ASB_SelectClause selectClause) {
    selectClause.mergeInto(this.selectClause);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds a filter (WHERE clause) to the query.
   * @param asbWhere The where clause to add.
   * @return ASB_QueryBuilder for chaining.
   * @example
   *   new ASB().make(Account.SObjectType).filter(asb.filter());
   */
  public ASB_QueryBuilder filter(ASB_WhereClause asbWhere) {
    queryEngine.setWhere(asbWhere);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds an ORDER BY clause to the query.
   * @param orderBy The order by clause to add.
   * @return ASB_QueryBuilder for chaining.
   * @example
   *   new ASB().make(Account.SObjectType).orderBy(asb.orderByField(Account.Name));
   */
  public ASB_QueryBuilder orderBy(ASB_OrderByClause orderBy) {
    queryEngine.setOrderBy(orderBy);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds a LIMIT clause to the query.
   * @param recordLimit The record limit to set.
   * @return ASB_QueryBuilder for chaining.
   * @example
   *   new ASB().make(Account.SObjectType).recordLimit(10);
   */
  public ASB_QueryBuilder recordLimit(Integer recordLimit) {
    queryEngine.setLimit(recordLimit);
    return this;
  }

  /**
   * @apexdoc
   * @description Executes the SOQL query.
   * @return List<SObject> The query results.
   * @example
   *   List<Account> accs = (List<Account>)new ASB().make(Account.SObjectType).query();
   */
  public List<SObject> query() {
    if (Limits.getQueries() == Limits.getLimitQueries()) {
      throw new LimitException(
        'Executing this 1 query result in exceeding the query limit for this context. Currently ' +
          Limits.getQueries() +
          '/' +
          Limits.getLimitQueries()
      );
    }

    ASB_BindContext bindCtx = new ASB_BindContext();
    String queryString = queryEngine.queryDetail(bindCtx);
    System.debug(System.LoggingLevel.INFO, 'query: ' + queryString);
    System.debug(System.LoggingLevel.INFO, 'binds: ' + bindCtx.getBinds());

    List<SObject> queryResults = Database.queryWithBinds(queryString, bindCtx.getBinds(), this.accessLevel);

    return queryResults;
  }

  public class LimitException extends Exception {
  }
}
