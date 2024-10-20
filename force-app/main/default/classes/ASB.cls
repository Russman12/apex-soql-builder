public with sharing class ASB {
  private static final System.AccessLevel DEFAULT_ACCESS_LEVEL = System.AccessLevel.SYSTEM_MODE;

  public static ASB fromx(Schema.SObjectType sObjType) {
    return new ASB(sObjType);
  }

  public static ASB fromx(Schema.sObjectField field) {
    return new ASB(field);
  }

  @TestVisible
  private final ASB_Select asbSelect;
  @TestVisible
  private final ASB_From asbFrom;
  @TestVisible
  private ASB_Where asbWhere;
  @TestVisible
  private ASB_Order asbOrder;
  @TestVisible
  private ASB_Limit asbLimit;

  private ASB(Schema.SObjectType sObjType) {
    this.asbFrom = new ASB_From(sObjType);
    this.asbSelect = new ASB_Select();
  }

  private ASB(Schema.sObjectField field) {
    this.asbFrom = new ASB_From(field);
    this.asbSelect = new ASB_Select();
  }

  public ASB selectx(Schema.sObjectField field) {
    this.asbSelect.add(field);
    return this;
  }
  public ASB selectx(ASB subQuery) {
    this.asbSelect.add(subQuery);
    return this;
  }
  public ASB selectParent(Schema.SObjectField relationshipField, Schema.SObjectField parentField) {
    return this.selectParent(new List<Schema.SObjectField>{ relationshipField, parentField });
  }
  public ASB selectParent(
    Schema.SObjectField relationshipField,
    Schema.SObjectField relationshipField2,
    Schema.SObjectField parentField
  ) {
    return this.selectParent(new List<Schema.SObjectField>{ relationshipField, relationshipField2, parentField });
  }
  public ASB selectParent(
    Schema.SObjectField relationshipField,
    Schema.SObjectField relationshipField2,
    Schema.SObjectField relationshipField3,
    Schema.SObjectField parentField
  ) {
    return this.selectParent(
      new List<Schema.SObjectField>{ relationshipField, relationshipField2, relationshipField3, parentField }
    );
  }
  public ASB selectParent(List<Schema.SObjectField> relationshipPath) {
    this.asbSelect.addParent(relationshipPath);
    return this;
  }
  public ASB wherex(ASB_Where asbWhere) {
    this.asbWhere = asbWhere;
    return this;
  }
  public ASB orderBy(ASB_Order asbOrder) {
    this.asbOrder = asbOrder;
    return this;
  }
  public ASB limitx(Integer limitx) {
    this.asbLimit = new ASB_Limit(limitx);
    return this;
  }
  public List<SObject> query() {
    return null;
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
