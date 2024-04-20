/**
 * Provides unit test coverage for ASB_Select class
 * @author Russell Laboe
 */
@isTest
private class ASB_Select_Test {
  /**
   * Ensures toClauseString() returns expected clause String when fields are provided
   */
  @isTest
  static void toClauseStringFields() {
    Set<ASB_Select.Element> selectElements = new Set<ASB_Select.Element>{
      new ASB_Select.Field(Account.Id),
      new ASB_Select.Field(Account.Name)
    };
    System.Assert.areEqual(
      'SELECT Id, Name',
      new ASB_Select(selectElements).toClauseString(),
      'unexpected SELECT clause string returned'
    );
  }

  /**
   * Ensures add() appends element
   */
  @isTest
  static void addAppendsElement() {
    ASB_Select.Element nameFieldElement = new ASB_Select.Field(Account.Name);
    ASB_Select selectx = new ASB_Select(
      new Set<ASB_Select.Element>{ new ASB_Select.Field(Account.Id) }
    );
    selectx.add(nameFieldElement);

    System.Assert.isTrue(
      selectx.elements.contains(nameFieldElement),
      'expected name field element not added'
    );
  }
}
