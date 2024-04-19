public class ASB_SelectElements implements ASB_SOQLClause {
  private Set<ASB_SelectElement> elements;

  public ASB_SelectElements() {
    this.elements = new Set<ASB_SelectElement>();
  }

  public void add(ASB_SelectElement selectElement) {
    this.elements.add(selectElement);
  }

  public String toClauseString() {
    String s = '';
    for (ASB_SelectElement element : this.elements) {
      s += element.toClauseString() + ',';
    }
    return s.removeEnd(',');
  }
}
