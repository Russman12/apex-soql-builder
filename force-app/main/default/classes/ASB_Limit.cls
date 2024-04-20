public with sharing class ASB_Limit implements ASB_SOQL.Clause {
  private final Integer limitx;
  public ASB_Limit(Integer limitx) {
    this.limitx = limitx;
  }

  public String toClauseString() {
    return 'LIMIT ' + this.limitx;
  }
}
