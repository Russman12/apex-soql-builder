/**
 * Encompasses functionality relating to a SOQL SELECT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_Select implements ASB_Clause {
  private final List<Element> elements;

  /**
   * Creates new instance of `ASB_Select`
   */
  public ASB_Select() {
    this.elements = new List<Element>();
  }

  /**
   * Adds field to `ASB_Select` instance.
   * @param field Field to add to select clause.
   * @return  `ASB_Select`
   */
  public ASB_Select field(Schema.SObjectField field) {
    (new FieldElement(field)).mergeInto(this.elements);
    return this;
  }

  /**
   * Adds suquery to `ASB_Select` instance. throws exeption if a different subquery for the same child object is added.
   * @param subQuery Subquery to add to the select clause.
   * @return  `ASB_Select`
   */
  public ASB_Select subQuery(ASB_SubQuery subQuery) {
    (new SubqueryElement(subQuery)).mergeInto(this.elements);

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
    (new FieldElement(fieldPath)).mergeInto(elements);
    return this;
  }

  public void mergeInto(ASB_Select asbSelect) {
    for (Element e : this.elements) {
      e.mergeInto(asbSelect.elements);
    }
  }

  /* --- ASB_Clause Interface --- */

  /**
   * Returns instance as a SELECT clause query string.
   * @return  `String`
   */
  public String clauseString(ASB_BindContext ctx) {
    List<String> elementStrs = new List<String>();
    for (Element element : this.elements) {
      elementStrs.add(element.queryString(ctx));
    }

    return 'SELECT ' + String.join(elementStrs, ', ');
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
    public String queryString(ASB_BindContext ctx) {
      String[] fieldStrs = new List<String>{};
      for (Integer i = 0; i < this.relationshipPath.size() - 1; i++) {
        fieldStrs.add(this.relationshipPath[i].getDescribe().getRelationshipName());
      }
      fieldStrs.add(this.relationshipPath[this.relationshipPath.size() - 1].getDescribe().getName());

      return String.join(fieldStrs, '.');
    }

    public void mergeInto(List<Element> target) {
      if (!target.contains(this)) {
        target.add(this);
      }
    }

    public Integer hashCode() {
      return this.relationshipPath.hashCode();
    }

    public Boolean equals(Object obj) {
      return obj instanceof FieldElement && this.relationshipPath.equals(((FieldElement) obj).relationshipPath);
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
    public String queryString(ASB_BindContext ctx) {
      return '(' + this.subQuery.queryDetail(ctx) + ')';
    }

    public void mergeInto(List<Element> target) {
      SubqueryElement targetElement = findByRelationship(target, this.subQuery.relatedBy());

      if (targetElement == null) {
        target.add(this);
      } else {
        this.subQuery.mergeInto(targetElement.subQuery);
      }
    }

    private SubqueryElement findByRelationship(List<Element> target, Schema.SObjectField relatedBy) {
      for (Element e : target) {
        if (e instanceof SubqueryElement && ((SubqueryElement) e).subQuery.relatedBy() == relatedBy) {
          return (SubqueryElement) e;
        }
      }
      return null;
    }
  }

  private interface Element {
    /**
     * Returns instance as a query string component.
     * @return  `String`
     */
    String queryString(ASB_BindContext ctx);

    void mergeInto(List<Element> target);
  }
}
