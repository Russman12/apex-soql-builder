@isTest
public with sharing class ASB_BindContext_Test {
  @isTest
  static void bind() {
    // Arrange
    ASB_BindContext context = new ASB_BindContext();
    Object source1 = new MockType();
    Object value1 = 'Value1';
    String prefix1 = 'testParam';

    Object source2 = new MockType();
    Object value2 = 'Value2';
    String prefix2 = null;

    // Act
    Test.startTest();
    String bind1 = context.bind(source1, value1, prefix1);
    String bind2 = context.bind(source2, value2, prefix2);
    Test.stopTest();

    // Assert
    System.assertEquals(':testParam1', bind1);
    System.assertEquals(':param1', bind2);

    Map<String, Object> binds = context.getBinds();
    System.assertEquals(2, binds.size());
    System.assertEquals(value1, binds.get('testParam1'));
    System.assertEquals(value2, binds.get('param1'));
  }

  private class MockType {
  }
}
