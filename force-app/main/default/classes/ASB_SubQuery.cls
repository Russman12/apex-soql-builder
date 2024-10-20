public with sharing class ASB_SubQuery extends ASB_Query {
  public static ASB_SubQuery relatedBy(Schema.sObjectField relationshipField) {
    return new ASB_SubQuery(relationshipField);
  }
  private ASB_SubQuery(Schema.sObjectField field) {
    super(new ASB_From(field));
  }

  public ASB_SubQuery selectField(Schema.SObjectField field) {
    return (ASB_SubQuery) superSelect(asbSelect.field(field));
  }
  // public ASB selectFields(Schema.SObjectField[] fields) {
  //   return (ASB) superSelect(asbSelect.);
  // }
  public ASB_SubQuery selectParentField(Schema.SObjectField[] fieldPath) {
    return (ASB_SubQuery) superSelect(asbSelect.parent(fieldPath));
  }
  public ASB_SubQuery selectParentField(Schema.SObjectField relationshipField, Schema.SObjectField field) {
    return (ASB_SubQuery) superSelect(asbSelect.parent(relationshipField, field));
  }
  public ASB_SubQuery selectSubQuery(ASB_SubQuery subQuery) {
    return (ASB_SubQuery) superSelect(asbSelect.subQuery(subQuery));
  }
  public ASB_SubQuery wherex(ASB_Where asbWhere) {
    return (ASB_SubQuery) superWhere(asbWhere);
  }
  public ASB_SubQuery orderBy(ASB_OrderBy asbOrder) {
    return (ASB_SubQuery) superOrderBy(asbOrder);
  }
  public ASB_SubQuery limitx(Integer limitx) {
    return (ASB_SubQuery) superLimit(limitx);
  }

  public String soqlString() {
    ASB_Clause[] clauses = new List<ASB_Clause>{ this.asbSelect, this.asbFrom, this.asbWhere };

    ASB_Clause[] setClauses = new List<ASB_Clause>{};
    for (ASB_Clause clause : clauses) {
      if (clause != null) {
        setClauses.add(clause);
      }
    }

    String[] strs = new List<String>{};
    for (ASB_Clause clause : setClauses) {
      strs.add(clause.clauseString());
    }
    return String.join(strs, ' ');
  }
}
