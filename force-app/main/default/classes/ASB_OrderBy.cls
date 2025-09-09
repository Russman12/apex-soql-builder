/**
 * Encompasses functionality relating to a SOQL ORDER BY clause.
 * @author Russell Laboe
 */
public with sharing class ASB_OrderBy implements ASB_Clause {
  private final Schema.SObjectField[] fields;
  private String direction;
  private String nullPlacement;

  public ASB_OrderBy(Schema.SObjectField[] sObjFields) {
    this.fields = sObjFields;
  }

  /**
   * Set order direction to descending.
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy descending() {
    this.direction = 'DESC';
    return this;
  }

  /**
   * Set order direction to Ascending.
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy ascending() {
    this.direction = 'ASC';
    return this;
  }

  /**
   * Orders by nulls first.
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy nullsFirst() {
    this.nullPlacement = 'FIRST';
    return this;
  }

  /**
   * Orders by nulls last.
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy nullsLast() {
    this.nullPlacement = 'LAST';
    return this;
  }

  /**
   * Returns complete clause string
   * @return   `String`
   */
  public String clauseString(ASB_BindContext ctx) {
    String[] elements = new List<String>{ String.join(this.fieldStrings(), ', ') };
    if (this.direction != null) {
      elements.add(this.direction);
    }
    if (this.nullPlacement != null) {
      elements.add('NULLS ' + this.nullPlacement);
    }
    return 'ORDER BY ' + String.join(elements, ' ');
  }

  private String[] fieldStrings() {
    String[] fieldStrings = new List<String>{};
    for (Schema.SObjectField field : this.fields) {
      fieldStrings.add(field.getDescribe().getName());
    }

    return fieldStrings;
  }
}
