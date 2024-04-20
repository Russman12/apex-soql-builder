/**
 * SOQL SELECT clause.
 * @description This class encompasses functionality relating to a SOQL SELECT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Select implements ASB_SOQL.Clause {
  @testVisible
  private final Set<Element> elements;

  /**
   * constructs new instance of ASB_Select
   */
  public ASB_Select(Set<Element> selectElements) {
    this.elements = selectElements;
  }

  /**
   * adds SelectElement to clause
   */
  public void add(Element selectElement) {
    this.elements.add(selectElement);
  }

  /**
   * Returns complete clause string
   * @resturn `String`
   */
  public String toClauseString() {
    String s = '';
    for (Element element : this.elements) {
      s += element.toSOQLString() + ', ';
    }
    return 'SELECT ' + s.removeEnd(', ');
  }

  /**
   * represents a SObject Field SelectElement.
   */
  public class Field implements Element {
    private final SObjectField field;

    /**
     * constructs new Field instance
     */
    public Field(SObjectField sObjField) {
      this.field = sObjField;
    }

    /**
     * Returns Field as a SOQL string
     */
    public String toSOQLString() {
      return this.field.getDescribe().getName();
    }
  }

  /**
   * Represents an object that can be added as a select clause element.
   */
  public interface Element {
    String toSOQLString();
  }
}
