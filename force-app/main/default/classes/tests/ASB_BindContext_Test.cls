/**
 * Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * @description Unit tests for ASB_BindContext.
 * Ensures correct behavior for bind context and parameter binding logic.
 */
@isTest
public with sharing class ASB_BindContext_Test {
  /**
   * Ensures bind() and getBinds() work as expected.
   */
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
