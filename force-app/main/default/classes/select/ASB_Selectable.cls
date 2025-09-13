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
 * @interface ASB_Selectable
 * @description Interface for classes that support adding fields and parent fields to a SELECT clause.
 * @example
 *   ASB_Selectable selectable = new ASB().selection();
 *   selectable.field(Account.Name);
 *   selectable.parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
 */
public interface ASB_Selectable extends ASB_Clause {
  /**
   * @apexdoc
   * @description Adds a field to the SELECT clause.
   * @param field Field to add to select clause.
   * @return ASB_Selectable for chaining.
   * @example
   *   new ASB().selection().field(Account.Name);
   */
  ASB_Selectable field(Schema.SObjectField field);
  /**
   * @apexdoc
   * @description Adds a parent record field to the SELECT clause.
   * @param relationshipPath Path to parent field as a list of SObjectFields.
   * @return ASB_Selectable for chaining.
   * @example
   *   new ASB().selection().parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
   */
  ASB_Selectable parent(List<Schema.SObjectField> relationshipPath);
}
