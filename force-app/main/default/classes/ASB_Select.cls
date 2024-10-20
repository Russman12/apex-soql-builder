/**
 * Encompasses functionality relating to a SOQL SELECT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Select implements ASB_Clause {
  private final List<Element> elements;

  public ASB_Select() {
    this.elements = new List<Element>{};
  }

  public ASB_Select field(Schema.SObjectField field) {
    this.elements.add(new FieldElement(field));
    return this;
  }

  public ASB_Select subQuery(ASB_SubQuery subQuery) {
    this.elements.add(new SubqueryElement(subQuery));
    return this;
  }

  public ASB_Select parent(List<Schema.SObjectField> fieldPath) {
    this.elements.add(new FieldElement(fieldPath));
    return this;
  }
  public ASB_Select parent(Schema.SObjectField parentField, Schema.SObjectField field) {
    this.elements.add(new FieldElement(new List<Schema.SObjectField>{ parentField, field }));
    return this;
  }

  public ASB_Select parent(
    Schema.SObjectField parent1Field,
    Schema.SObjectField parent2Field,
    Schema.SObjectField field
  ) {
    this.elements.add(new FieldElement(new List<Schema.SObjectField>{ parent1Field, parent2Field, field }));
    return this;
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

    private FieldElement(Schema.SObjectField field) {
      this(new List<Schema.SObjectField>{ field });
    }

    private FieldElement(Schema.SObjectField[] relationshipPath) {
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
    private final ASB_SubQuery subQuery;

    private SubqueryElement(ASB_SubQuery subQuery) {
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
