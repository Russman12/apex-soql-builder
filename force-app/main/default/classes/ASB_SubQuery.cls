/**
 * Encompasses functionality relating to a SOQL subquery.
 * @author Russell Laboe
 */
public with sharing class ASB_SubQuery extends ASB_Query {
  private final Schema.sObjectField relationshipField;

  public ASB_SubQuery(Schema.sObjectField field) {
    super(new ASB_From(field));
    this.relationshipField = field;
  }

  /**
   * Adds given field to select clause.
   * @param field Field to add to Select Clause.
   * @return  `ASB`
   */
  public ASB_SubQuery selectField(Schema.SObjectField field) {
    return (ASB_SubQuery) setSelect(asbSelect.field(field));
  }

  /**
   * Adds given parent fieldPath to select clause.
   * @param fieldPath field path to add to clause.
   * @return  `ASB`
   *
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectParentField(new List<SObjectField>{Account.OwnerId, User.Name})
   * ```
   */
  public ASB_SubQuery selectParentField(Schema.SObjectField[] fieldPath) {
    return (ASB_SubQuery) setSelect(asbSelect.parent(fieldPath));
  }
  /**
   * Adds given parent fieldPath to select clause.
   * @param relationshipField relationship field to parent.
   * @param field parent field.
   * @return  `ASB`
   *
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectParentField(Account.OwnerId, User.Name)
   * ```
   */
  public ASB_SubQuery selectParentField(Schema.SObjectField relationshipField, Schema.SObjectField field) {
    return (ASB_SubQuery) selectParentField(new List<Schema.SObjectField>{ relationshipField, field });
  }
  /**
   * Adds given `ASB_SubQuery` to select clause.
   * @param subQuery subquery to add to select clause.
   * @return  `ASB`
   * @example
   * ```apex
   * ASB.make(Account.getSObjectType())
   *  .selectSubQuery(asb.subQuery(Contact.AccountId).field(Contact.Name))
   * ```
   */
  public ASB_SubQuery selectSubQuery(ASB_SubQuery subQuery) {
    return (ASB_SubQuery) setSelect(asbSelect.subQuery(subQuery));
  }
  /**
   * Adds given `ASB_Where` clause filter to query.
   * @param asbWhere where clasue to add to query.
   * @return  `ASB`
   */
  public ASB_SubQuery filter(ASB_Where asbWhere) {
    return (ASB_SubQuery) setWhere(asbWhere);
  }
  /**
   * Sets given `ASB_OrderBy` clause to query.
   * @param asbOrder order by clause to add to query.
   * @return  `ASB`
   */
  public ASB_SubQuery orderBy(ASB_OrderBy asbOrder) {
    return (ASB_SubQuery) setOrderBy(asbOrder);
  }
  /**
   * Sets the given `ASB_Limit` to query.
   * @param limitx limit to add to query.
   * @return  `ASB`
   */
  public ASB_SubQuery recordLimit(Integer limitx) {
    return (ASB_SubQuery) setLimit(limitx);
  }

  public Schema.sObjectField relatedBy() {
    return this.relationshipField;
  }

  /**
   *
   * @param subQuery subquery to
   * @return  `ASB_SubQuery`
   * @exception `InvalidCombineException` thrown if any element of the query cannot be combined
   */
  public ASB_SubQuery combine(ASB_SubQuery subQuery) {
    if (!this.asbFrom.equals(subQuery.asbFrom)) {
      throw new InvalidCombineException('unable to combine subQueries from different relationships');
    }
    if (this.asbLimit != null || subQuery.asbLimit != null) {
      throw new InvalidCombineException('unable to combine subQueries with record limits');
    }
    if (this.asbOrderBy != null || subQuery.asbOrderBy != null) {
      throw new InvalidCombineException('unable to combine subQueries with specific ordering');
    }
    if (this.asbWhere != null || subQuery.asbWhere != null) {
      throw new InvalidCombineException('unable to combine subQueries with filters');
    }

    this.asbSelect.combine(subQuery.asbSelect);

    return this;
  }

  public Integer hashCode() {
    return this.queryDetail().hashCode();
  }

  public Boolean equals(Object obj) {
    return this.hashCode().equals(obj.hashCode());
  }

  /**
   * Converts SubQuery to SOQL string.
   * @return  `String`
   */
  public ASB_Query.Detail queryDetail() {
    ASB_Clause[] clauses = new List<ASB_Clause>{
      this.asbSelect,
      this.asbFrom,
      this.asbWhere,
      this.asbOrderBy,
      this.asbLimit
    };

    ASB_ClauseDetail[] clauseDetails = new List<ASB_ClauseDetail>{};
    for (ASB_Clause clause : clauses) {
      if (clause != null) {
        clauseDetails.add(clause.clauseDetail());
      }
    }

    String[] strs = new List<String>{};
    Map<String, Object> bindings = new Map<String, Object>();
    for (ASB_ClauseDetail clauseDetail : clauseDetails) {
      strs.add(clauseDetail.getClauseString());
      bindings.putAll(clauseDetail.getBindings());
    }
    return new ASB_Query.Detail(String.join(strs, ' '), bindings);
  }

  @TestVisible
  private class InvalidCombineException extends Exception {
  }
}
