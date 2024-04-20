public with sharing class ASB_Select implements ASB_SOQL.Clause {
  private final Set<SelectElement> elements;

  public ASB_Select(Set<SelectElement> selectElements) {
    this.elements = selectElements;
  }

  public void add(SelectElement selectElement) {
    this.elements.add(selectElement);
  }

  public String toClauseString() {
    String s = '';
    for (SelectElement element : this.elements) {
      s += element.toSOQLString() + ', ';
    }
    return 'SELECT ' + s.removeEnd(', ');
  }

  public class Field implements SelectElement {
    private final SObjectField field;

    public Field(SObjectField sObjField) {
      this.field = sObjField;
    }

    public String toSOQLString() {
      return this.field.getDescribe().getName();
    }
  }

  public interface SelectElement {
    String toSOQLString();
  }
}
