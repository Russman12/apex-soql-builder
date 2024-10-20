/**
 * Encompasses functionality relating to a SOQL ORDER BY clause.
 * @author Russell Laboe
 */
public with sharing class ASB_OrderBy implements ASB_Clause {
  private final Schema.SObjectField[] fields;
  private String direction;
  private String nullsx;

  /**
   * Sets field in Order By clause.
   * @param field
   * @return  `ASB_OrderBy`
   */
  public static ASB_OrderBy field(Schema.SObjectField field) {
    return fields(new List<Schema.SObjectField>{ field });
  }

  /**
   * Sets fields in Order By clause.
   * @param fields
   * @return  `ASB_OrderBy`
   */
  public static ASB_OrderBy fields(Schema.SObjectField[] fields) {
    return new ASB_OrderBy(fields);
  }

  /**
   * Sets 2 fields in Order By clause.
   * @param field1
   * @param field2
   * @return  `ASB_OrderBy`
   */
  public static ASB_OrderBy fields(Schema.SObjectField field1, Schema.SObjectField field2) {
    return fields(new List<Schema.SObjectField>{ field1, field2 });
  }

  private ASB_OrderBy(Schema.SObjectField[] sObjFields) {
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
    this.nullsx = 'FIRST';
    return this;
  }

  /**
   * Orders bu nulls last.
   * @return  `ASB_OrderBy`
   */
  public ASB_OrderBy nullsLast() {
    this.nullsx = 'LAST';
    return this;
  }

  /**
   * Returns complete clause string
   * @return   `String`
   */
  public String clauseString() {
    String[] elements = new List<String>{ String.join(this.fieldStrings(), ', ') };
    if (this.direction != null) {
      elements.add(this.direction);
    }
    if (this.nullsx != null) {
      elements.add('NULLS ' + this.nullsx);
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
