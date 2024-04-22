/**
 * SOQL SELECT clause.
 * @description This class encompasses functionality relating to a SOQL SELECT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Select {
  private static ASB_Select instance;

  public static ASB_Select instance() {
    if (instance == null) {
      instance = new ASB_Select();
    }
    return instance;
  }

  public Elements make(SObjectType sObjType) {
    return new SelectElements(new Set<Selectable>{ new Field(sObjType.getDescribe().Fields.getMap().get('Id')) });
  }

  public interface Elements {
    Elements add(SObjectField sObjField);
    Elements add(SObjectField relationshipField, SObjectField sObjField);
    Elements combine(Elements selects);
    ASB_SOQLClause toClause();
  }

  private interface Selectable {
    String toSOQLString();
  }

  private class Clause implements ASB_SOQLClause {
    private final SelectElements selectElements;

    private Clause(SelectElements selectElements) {
      this.selectElements = selectElements;
    }

    public String toClauseString() {
      return 'SELECT ' + this.selectElements.toSOQLString();
    }
  }

  private class SelectElements implements Elements {
    private final Set<Selectable> elements;

    private SelectElements(SelectElements selectElements) {
      this.elements = selectElements.elements.clone();
    }

    private SelectElements(Set<Selectable> elements) {
      this.elements = elements;
    }

    public SelectElements add(SObjectField sObjField) {
      SelectElements dup = this.duplicate();
      dup.elements.add(new Field(sObjField));
      return dup;
    }

    public SelectElements add(SObjectField relationshipField, SObjectField sObjField) {
      SelectElements dup = this.duplicate();
      dup.elements.add(new RelatedField(relationshipField, sObjField));
      return dup;
    }

    public SelectElements combine(Elements selects) {
      SelectElements dup = this.duplicate();
      dup.elements.addAll(((SelectElements) selects).elements);
      return dup;
    }

    private SelectElements duplicate() {
      return new SelectElements(this);
    }

    public Clause toClause() {
      return new Clause(this);
    }

    public String toSOQLString() {
      String s = '';
      for (Selectable element : this.elements) {
        s += element.toSOQLString() + ', ';
      }
      return s.removeEnd(', ');
    }
  }

  private class Field implements Selectable {
    private final SObjectField field;

    private Field(SObjectField sObjField) {
      this.field = sObjField;
    }

    public String toSOQLString() {
      return this.field.getDescribe().getName();
    }

    public Integer hashCode() {
      return this.toSOQLString().hashCode();
    }

    public Boolean equals(Object obj) {
      return this.toSOQLString().equals(((Selectable) obj).toSOQLString());
    }
  }

  private class RelatedField implements Selectable {
    private final SObjectField relationshipField;
    private final SObjectField field;

    private RelatedField(SObjectField relationshipField, SObjectField sObjField) {
      this.relationshipField = relationshipField;
      this.field = sObjField;
    }

    public String toSOQLString() {
      return this.relationshipField.getDescribe().getRelationshipName() + '.' + this.field.getDescribe().getName();
    }

    public Integer hashCode() {
      return this.toSOQLString().hashCode();
    }

    public Boolean equals(Object obj) {
      return this.toSOQLString().equals(((Selectable) obj).toSOQLString());
    }
  }
}
