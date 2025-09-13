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
 * Provides unit test coverage for ASB_Limit class
 * @author Russell Laboe
 */

/**
 * @description Unit tests for ASB_LimitClause.
 * Ensures correct behavior for SOQL LIMIT clause logic.
 * @author Russell Laboe
 */
@isTest
private class ASB_LimitClause_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  /**
   * Ensures clauseString() returns expected clause String.
   */
  @IsTest
  static void clauseString() {
    Integer expectedLimit = 10;
    ASB_LimitClause asbLimit = new ASB_LimitClause(expectedLimit);
    System.Assert.areEqual(
      'LIMIT :RECORD_LIMIT1',
      asbLimit.clauseString(ctx),
      'unexpected LIMIT clause string returned'
    );
    System.Assert.areEqual(
      expectedLimit,
      ctx.getBinds().get('RECORD_LIMIT1'),
      'unexpected LIMIT clause string returned'
    );
  }

  /**
   * Ensures expected exception is thrown when invalid argument is given.
   */
  @IsTest
  static void illegalArgument() {
    Test.startTest();
    try {
      new ASB_LimitClause(-10);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_LimitClause.IllegalArgumentException.class, 'Unexpected exception thrown');
    }
    Test.stopTest();
  }
}
