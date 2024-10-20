public with sharing class ASB extends ASB_Query {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  public static ASB make(Schema.SObjectType sObjType) {
    return new ASB(sObjType);
  }

  public System.AccessLevel accessLevel = DEFAULT_ACCESS_LEVEL;

  private ASB(Schema.SObjectType sObjType) {
    super(new ASB_From(sObjType));
  }

  public ASB selectField(Schema.SObjectField field) {
    return (ASB) superSelect(asbSelect.field(field));
  }
  // public ASB selectFields(Schema.SObjectField[] fields) {
  //   return (ASB) superSelect(asbSelect.);
  // }

  public ASB selectParentField(Schema.SObjectField[] fieldPath) {
    return (ASB) superSelect(asbSelect.parent(fieldPath));
  }
  public ASB selectParentField(Schema.SObjectField relationshipField, Schema.SObjectField field) {
    return (ASB) superSelect(asbSelect.parent(relationshipField, field));
  }
  public ASB selectParentField(
    Schema.SObjectField relationshipField1,
    Schema.SObjectField relationshipField2,
    Schema.SObjectField field
  ) {
    return (ASB) superSelect(asbSelect.parent(relationshipField1, relationshipField2, field));
  }
  public ASB selectSubQuery(ASB_SubQuery subQuery) {
    return (ASB) superSelect(asbSelect.subQuery(subQuery));
  }
  public ASB wherex(ASB_Where asbWhere) {
    return (ASB) superWhere(asbWhere);
  }
  public ASB orderBy(ASB_OrderBy asbOrder) {
    return (ASB) superOrderBy(asbOrder);
  }
  public ASB limitx(Integer limitx) {
    return (ASB) superLimit(limitx);
  }
  public List<SObject> query() {
    return Database.query(this.soqlString(), this.accessLevel);
  }
  public List<SObject> query(Map<String, Object> binds) {
    return Database.queryWithBinds(this.soqlString(), binds, this.accessLevel);
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
