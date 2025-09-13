/**
 * Encompasses functionality relating to a SOQL subquery.
 * @author Russell Laboe
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
   * Adds given field to select clause.
   * @param field Field to add to Select Clause.
   * @return  `ASB`
   */
  public ASB_SubQueryBuilder selection(ASB_SubSelectClause subSelectClause) {
    subSelectClause.mergeInto(this.subSelectClause);
    return this;
  }

  public ASB_SubQueryBuilder filter(ASB_WhereClause asbWhere) {
    queryEngine.setWhere(asbWhere);
    return this;
  }

  public ASB_SubQueryBuilder orderBy(ASB_OrderByClause orderBy) {
    queryEngine.setOrderBy(orderBy);
    return this;
  }

  public ASB_SubQueryBuilder recordLimit(Integer recordLimit) {
    queryEngine.setLimit(recordLimit);
    return this;
  }

  public ASB_FromRelationshipClause relatedBy() {
    return (ASB_FromRelationshipClause) queryEngine.getASBFrom();
  }

  /**
   *
   * @param subQuery subquery to
   * @return  `ASB_SubQuery`
   * @exception `InvalidCombineException` thrown if any element of the query cannot be combined
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

  public String queryDetail(ASB_BindContext ctx) {
    return queryEngine.queryDetail(ctx);
  }

  @TestVisible
  private class InvalidCombineException extends Exception {
  }
}
