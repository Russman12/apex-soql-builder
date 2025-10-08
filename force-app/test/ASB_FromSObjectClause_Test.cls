/*
Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/**
 * @description Unit tests for ASB_FromSObjectClause.
 */
@IsTest
private class ASB_FromSObjectClause_Test {
  /**
   * Ensures clauseString returns expected string.
   */
  @IsTest
  static void constructorAndClauseString() {
    Schema.SObjectType sObjType = Account.SObjectType;

    Test.startTest();
    ASB_FromSObjectClause instance = new ASB_FromSObjectClause(sObjType);
    Test.stopTest();

    System.Assert.areEqual(
      'FROM Account',
      instance.clauseString(new ASB_BindContext()),
      'Clause string should return FROM with SObject name'
    );
    System.Assert.areEqual(Account.Id, instance.getIdField(), 'getIdField should return the Id field for the SObject');
  }

  /**
   * Ensures equality and hashCode methods function as expected.
   */
  @IsTest
  static void equalityAndHashCode() {
    ASB_FromSObjectClause one = new ASB_FromSObjectClause(Account.getSObjectType());
    ASB_FromSObjectClause two = new ASB_FromSObjectClause(Account.getSObjectType());
    ASB_FromSObjectClause three = new ASB_FromSObjectClause(Contact.getSObjectType());

    System.Assert.areEqual(one, two, 'Two instances for Account should be equal');
    System.Assert.areNotEqual(one, three, 'Account and Contact instances should not be equal');
    System.Assert.areEqual(one.hashCode(), two.hashCode(), 'Equal objects must have equal hashCodes');
  }
}
