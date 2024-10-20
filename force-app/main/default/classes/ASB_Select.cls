/**
 * SOQL SELECT clause.
 * @description This class encompasses functionality relating to a SOQL SELECT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Select implements ASB_Clause {
  private final List<Element> elements;

  public ASB_Select() {
    this.elements = new List<Element>();
  }

  public void add(Schema.SObjectField field) {
    this.elements.add(new FieldElement(new List<Schema.SObjectField>{ field }));
  }

  public void add(ASB subQuery) {
    this.elements.add(new SubqueryElement(subQuery));
  }

  public void addParent(List<Schema.SObjectField> relationshipPath) {
    this.elements.add(new FieldElement(relationshipPath));
  }

  public String clauseString() {
    return 'SELECT ' + String.join(elementsToStrings(), ', ');
  }

  private String[] elementsToStrings() {
    Set<String> strs = new Set<String>();
    for (Element element : this.elements) {
      strs.add(element.queryString());
    }
    return new List<String>(strs);
  }

  private class FieldElement implements Element {
    private final List<Schema.SObjectField> relationshipPath;

    private FieldElement(List<Schema.SObjectField> relationshipPath) {
      this.relationshipPath = relationshipPath;
    }

    public String queryString() {
      String[] fieldStrs = new List<String>{};
      for (Integer i = 0; i < this.relationshipPath.size() - 1; i++) {
        fieldStrs.add(this.relationshipPath[i].getDescribe().getRelationshipName());
      }
      fieldStrs.add(this.relationshipPath[this.relationshipPath.size() - 1].getDescribe().getName());

      return String.join(fieldStrs, '.');
    }
  }

  private class SubqueryElement implements Element {
    private final ASB subQuery;

    private SubqueryElement(ASB subQuery) {
      this.subQuery = subQuery;
    }

    public String queryString() {
      return '(' + this.subQuery.soqlString() + ')';
    }
  }

  private interface Element {
    String queryString();
  }
}
