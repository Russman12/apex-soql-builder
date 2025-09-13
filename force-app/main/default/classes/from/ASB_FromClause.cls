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
 * @interface ASB_FromClause
 * @description Interface for FROM clauses in SOQL queries. Extends ASB_Clause.
 * @example
 *   ASB_FromClause from = new ASB().make(Account.SObjectType);
 */
public interface ASB_FromClause extends ASB_Clause {
  /**
   * @apexdoc
   * @description Returns the Id field for the SObject in the FROM clause.
   * @return Schema.SObjectField The Id field.
   * @example
   *   Schema.SObjectField idField = new ASB().make(Account.SObjectType).queryEngine.getASBFrom().getIdField();
   */
  Schema.SObjectField getIdField();
}
