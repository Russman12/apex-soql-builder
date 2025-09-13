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
 * @class ASB_SubQueryBuilder
 * @description Encompasses functionality relating to a SOQL subquery.
 * @author Russell Laboe
 * @example
 *   ASB_SubQueryBuilder subQuery = new ASB().subQuery(Contact.AccountId)
 *     .selection(new ASB().subSelection().field(Contact.Email))
 *     .filter(asb.filter())
 *     .orderBy(asb.orderByField(Contact.LastName))
 *     .recordLimit(10);
 */
public with sharing class ASB_SubQueryBuilder {
  private final Schema.sObjectField relationshipField;
  private final ASB_QueryEngine queryEngine;
  private final ASB_SubSelectClause subSelectClause;

  public ASB_SubQueryBuilder(ASB_FromRelationshipClause fromRelationship, ASB_SubSelectClause subSelectClause) {
    this.queryEngine = new ASB_QueryEngine(fromRelationship, subSelectClause);
    this.subSelectClause = subSelectClause;
  }

  /**
   * @apexdoc
   * @description Adds the given subselect clause to the subquery.
   * @param subSelectClause The subselect clause to merge.
   * @return ASB_SubQueryBuilder for chaining.
   * @example
   *   new ASB().subQuery(Contact.AccountId).selection(new ASB().subSelection().field(Contact.Email));
   */
  public ASB_SubQueryBuilder selection(ASB_SubSelectClause subSelectClause) {
    subSelectClause.mergeInto(this.subSelectClause);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds a filter (WHERE clause) to the subquery.
   * @param asbWhere The where clause to add.
   * @return ASB_SubQueryBuilder for chaining.
   * @example
   *   new ASB().subQuery(Contact.AccountId).filter(asb.filter());
   */
  public ASB_SubQueryBuilder filter(ASB_WhereClause asbWhere) {
    queryEngine.setWhere(asbWhere);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds an ORDER BY clause to the subquery.
   * @param orderBy The order by clause to add.
   * @return ASB_SubQueryBuilder for chaining.
   * @example
   *   new ASB().subQuery(Contact.AccountId).orderBy(asb.orderByField(Contact.LastName));
   */
  public ASB_SubQueryBuilder orderBy(ASB_OrderByClause orderBy) {
    queryEngine.setOrderBy(orderBy);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds a LIMIT clause to the subquery.
   * @param recordLimit The record limit to set.
   * @return ASB_SubQueryBuilder for chaining.
   * @example
   *   new ASB().subQuery(Contact.AccountId).recordLimit(10);
   */
  public ASB_SubQueryBuilder recordLimit(Integer recordLimit) {
    queryEngine.setLimit(recordLimit);
    return this;
  }

  /**
   * @apexdoc
   * @description Returns the relationship clause this subquery is related by.
   * @return ASB_FromRelationshipClause
   * @example
   *   ASB_FromRelationshipClause rel = new ASB().subQuery(Contact.AccountId).relatedBy();
   */
  public ASB_FromRelationshipClause relatedBy() {
    return (ASB_FromRelationshipClause) queryEngine.getASBFrom();
  }

  /**
   * @apexdoc
   * @description Merges this subquery into another subquery. Throws InvalidCombineException if not compatible.
   * @param subQuery The subquery to merge into.
   * @return ASB_SubQueryBuilder
   * @exception InvalidCombineException thrown if any element of the query cannot be combined
   * @example
   *   subQuery1.mergeInto(subQuery2);
   */
  public ASB_SubQueryBuilder mergeInto(ASB_SubQueryBuilder subQuery) {
    if (!queryEngine.getASBFrom().equals(subQuery.queryEngine.getASBFrom())) {
      throw new InvalidCombineException('unable to combine subQueries from different relationships');
    }
    if (queryEngine.getASBLimit() != null || subQuery.queryEngine.getASBLimit() != null) {
      throw new InvalidCombineException('unable to combine subQueries with record limits');
    }
    if (queryEngine.getASBOrderBy() != null || subQuery.queryEngine.getASBOrderBy() != null) {
      throw new InvalidCombineException('unable to combine subQueries with specific ordering');
    }
    if (queryEngine.getASBWhere() != null || subQuery.queryEngine.getASBWhere() != null) {
      throw new InvalidCombineException('unable to combine subQueries with filters');
    }
    ((ASB_SubSelectClause) queryEngine.getASBSelect())
      .mergeInto((ASB_SubSelectClause) subQuery.queryEngine.getASBSelect());

    return subQuery;
  }

  /**
   * @apexdoc
   * @description Returns the SOQL string for this subquery.
   * @param ctx The bind context for query string generation.
   * @return The subquery as a String.
   * @example
   *   String soql = new ASB().subQuery(Contact.AccountId).queryDetail(new ASB_BindContext());
   */
  public String queryDetail(ASB_BindContext ctx) {
    return queryEngine.queryDetail(ctx);
  }

  @TestVisible
  private class InvalidCombineException extends Exception {
  }
}
