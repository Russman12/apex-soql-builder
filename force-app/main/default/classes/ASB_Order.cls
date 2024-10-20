public with sharing class ASB_Order implements ASB_Clause {
  public static ASB_Order byx(Schema.SObjectField[] fields) {
    return new ASB_Order(fields);
  }
  public static ASB_Order byx(Schema.SObjectField field) {
    return byx(new List<Schema.SObjectField>{ field });
  }
  public static ASB_Order byx(Schema.SObjectField field1, Schema.SObjectField field2) {
    return byx(new List<Schema.SObjectField>{ field1, field2 });
  }

  private final Schema.SObjectField[] fields;
  private String direction;
  private String nullsx;

  private ASB_Order(Schema.SObjectField[] sObjFields) {
    this.fields = sObjFields;
  }

  public ASB_Order descx() {
    this.direction = 'DESC';
    return this;
  }
  public ASB_Order ascx() {
    this.direction = 'ASC';
    return this;
  }

  public ASB_Order nullsFirst() {
    this.nullsx = 'FIRST';
    return this;
  }
  public ASB_Order nullsLast() {
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
