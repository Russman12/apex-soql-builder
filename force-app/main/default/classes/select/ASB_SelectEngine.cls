public with sharing class ASB_SelectEngine {
  private final List<Element> elements = new List<Element>();
  private final Schema.SObjectType rootSObjType;

  public ASB_SelectEngine(Schema.SObjectType rootSObjType) {
    this.rootSObjType = rootSObjType;
  }

  /**
   * Adds field to `ASB_Selectable` instance.
   * @param field Field to add to select clause.
   * @return  `ASB_Selectable`
   */
  public void addField(Schema.SObjectField field) {
    (new FieldElement(new List<Schema.SObjectField>{ field })).mergeInto(this.elements);
  }

  /**
   * Adds a parent record field to `ASB_Selectable` instance.
   * @param fieldPath Path to parent field.
   * @return  `ASB_Selectable`
   */
  public void addParent(List<Schema.SObjectField> fieldPath) {
    (new FieldElement(fieldPath)).mergeInto(elements);
  }

  /**
   * Adds suquery to `ASB_SelectClause` instance. throws exeption if a different subquery for the same child object is added.
   * @param subQuery Subquery to add to the select clause.
   * @return  `ASB_SelectClause`
   */
  public void mergeSubQuery(ASB_SubQueryBuilder subQuery) {
    (new SubqueryElement(subQuery)).mergeInto(this.elements);
  }

  public void mergeInto(ASB_SelectEngine targetEngine) {
    for (Element e : this.elements) {
      e.mergeInto(targetEngine.elements);
    }
  }

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

  public interface Element {
    String queryString(ASB_BindContext ctx);
    void mergeInto(List<Element> target);
  }

  private class FieldElement implements Element {
    private final List<Schema.SObjectField> relationshipPath;
    private String cachedQueryString;

    private FieldElement(Schema.SObjectField[] relationshipPath) {
      this.relationshipPath = relationshipPath;
    }

    /**
     * Returns instance as a query string component.
     * @return  `String`
     */
    public String queryString(ASB_BindContext ctx) {
      if (cachedQueryString == null) {
        String[] fieldStrs = new List<String>{};
        for (Integer i = 0; i < this.relationshipPath.size() - 1; i++) {
          fieldStrs.add(this.relationshipPath[i].getDescribe().getRelationshipName());
        }
        fieldStrs.add(this.relationshipPath[this.relationshipPath.size() - 1].getDescribe().getName());
        cachedQueryString = String.join(fieldStrs, '.');
      }

      return cachedQueryString;
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
    public final ASB_SubQueryBuilder subQuery;

    private SubqueryElement(ASB_SubQueryBuilder subQuery) {
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

    private SubqueryElement findByRelationship(List<Element> target, ASB_FromRelationshipClause relatedBy) {
      for (Element e : target) {
        if (e instanceof SubqueryElement && ((SubqueryElement) e).subQuery.relatedBy() == relatedBy) {
          return (SubqueryElement) e;
        }
      }
      return null;
    }
  }
}
