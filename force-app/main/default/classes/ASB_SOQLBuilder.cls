public with sharing class ASB_SOQLBuilder {
  private final SObjectType fromSObjectType;
  private final ASB_SelectElements selectElements;
  private ASB_WhereClause whereClause;
  private Integer limitx;

  public ASB_SOQLBuilder(SObjectType fromSObjType) {
    this.fromSObjectType = fromSObjType;
    this.selectElements = new ASB_SelectElements();
  }

  public ASB_SOQLBuilder selectx(ASB_SelectElement element) {
    this.selectElements.add(element);
    return this;
  }

  public ASB_SOQLBuilder wherex(ASB_WhereClause whereClause) {
    this.whereClause = whereClause;
    return this;
  }

  public ASB_SOQLBuilder limitx(Integer limitx) {
    this.limitx = limitx;
    return this;
  }

  public ASB_SOQL build() {
    return new ASB_SOQL();
  }
}
