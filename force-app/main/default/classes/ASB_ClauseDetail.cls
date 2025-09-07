public with sharing class ASB_ClauseDetail {
  private String clauseString;
  private Map<String, Object> bindings;

  public ASB_ClauseDetail(String clauseString) {
    this.clauseString = clauseString;
    this.bindings = new Map<String, Object>();
  }

  public ASB_ClauseDetail(String clauseString, Map<String, Object> bindings) {
    this.clauseString = clauseString;
    this.bindings = bindings;
  }

  public String getClauseString() {
    return this.clauseString;
  }
  public Map<String, Object> getBindings() {
    return this.bindings;
  }
}
