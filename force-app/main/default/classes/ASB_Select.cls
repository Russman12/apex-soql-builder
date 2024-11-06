/**
 * Encompasses functionality relating to a SOQL SELECT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Select implements ASB_Clause {
  private final Map<Element, Element> elements;

  /**
   * Creates new instance of `ASB_Select`
   */
  public ASB_Select() {
    this.elements = new Map<Element, Element>{};
  }

  /**
   * Adds field to `ASB_Select` instance.
   * @param field Field to add to select clause.
   * @return  `ASB_Select`
   */
  public ASB_Select field(Schema.SObjectField field) {
    Element e = new FieldElement(field);
    this.elements.put(e, e);
    return this;
  }

  /**
   * Adds suquery to `ASB_Select` instance. throws exeption if a different subquery for the same child object is added.
   * @param subQuery Subquery to add to the select clause.
   * @return  `ASB_Select`
   */
  public ASB_Select subQuery(ASB_SubQuery subQuery) {
    Element e = new SubqueryElement(subQuery);
    SubqueryElement thisSubQueryElement = ((SubqueryElement) this.elements.get(e));
    if (this.elements.keySet().contains(e) && thisSubQueryElement.subQuery != subQuery) {
      thisSubQueryElement.subQuery.combine(subQuery);
    } else {
      this.elements.put(e, e);
    }
    return this;
  }

  /**
   * Adds a parent record field to `ASB_Select` instance.
   * @param relationshipField Relationship field.
   * @param field Parent field.
   * @return  `ASB_Select`
   */
  public ASB_Select parent(Schema.SObjectField relationshipField, Schema.SObjectField field) {
    this.parent(new List<Schema.SObjectField>{ relationshipField, field });
    return this;
  }

  /**
   * Adds a parent record field to `ASB_Select` instance.
   * @param relationshipField1 First relationship field.
   * @param relationshipField2 Second relationship field.
   * @param field Parent field.
   * @return  `ASB_Select`
   */
  public ASB_Select parent(
    Schema.SObjectField relationshipField1,
    Schema.SObjectField relationshipField2,
    Schema.SObjectField field
  ) {
    this.parent(new List<Schema.SObjectField>{ relationshipField1, relationshipField2, field });
    return this;
  }

  /**
   * Adds a parent record field to `ASB_Select` instance.
   * @param fieldPath Path to parent field.
   * @return  `ASB_Select`
   */
  public ASB_Select parent(List<Schema.SObjectField> fieldPath) {
    Element e = new FieldElement(fieldPath);
    this.elements.put(e, e);
    return this;
  }

  /**
   * Combines given `ASB_Select` instance with this instance.
   * @param asbSelect `ASB_Select` to combine with this instance.
   * @return  `ASB_Select`
   */
  public ASB_Select combine(ASB_Select asbSelect) {
    for (Element e : asbSelect.elements.keySet()) {
      if (!this.elements.containsKey(e)) {
        this.elements.put(e, e);
      }
    }
    return this;
  }

  /**
   * Returns instance as a SELECT clause query string.
   * @return  `String`
   */
  public String clauseString() {
    return 'SELECT ' + String.join(elementsToStrings(), ', ');
  }

  private String[] elementsToStrings() {
    List<String> elementStrs = new List<String>();
    for (Element element : this.elements.keySet()) {
      elementStrs.add(element.queryString());
    }
    return elementStrs;
  }

  private class FieldElement implements Element {
    private final List<Schema.SObjectField> relationshipPath;

    private FieldElement(Schema.SObjectField field) {
      this(new List<Schema.SObjectField>{ field });
    }

    private FieldElement(Schema.SObjectField[] relationshipPath) {
      this.relationshipPath = relationshipPath;
    }

    /**
     * Returns instance as a query string component.
     * @return  `String`
     */
    public String queryString() {
      String[] fieldStrs = new List<String>{};
      for (Integer i = 0; i < this.relationshipPath.size() - 1; i++) {
        fieldStrs.add(this.relationshipPath[i].getDescribe().getRelationshipName());
      }
      fieldStrs.add(this.relationshipPath[this.relationshipPath.size() - 1].getDescribe().getName());

      return String.join(fieldStrs, '.');
    }

    public Integer hashCode() {
      return this.relationshipPath.hashCode();
    }

    public Boolean equals(Object obj) {
      return this.hashCode().equals(obj.hashCode());
    }
  }

  public class SubqueryElement implements Element {
    public final ASB_SubQuery subQuery;

    private SubqueryElement(ASB_SubQuery subQuery) {
      this.subQuery = subQuery;
    }

    /**
     * Returns instance as a query string component.
     * @return  `String`
     */
    public String queryString() {
      return '(' + this.subQuery.soqlString() + ')';
    }

    public Integer hashCode() {
      return this.subQuery.relatedBy().hashCode();
    }

    public Boolean equals(Object obj) {
      return this.hashCode().equals(obj.hashCode());
    }
  }

  private interface Element {
    /**
     * Returns instance as a query string component.
     * @return  `String`
     */
    String queryString();
  }
}
