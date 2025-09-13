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
 * Encompasses functionality relating to a SOQL ORDER BY clause.
 * @author Russell Laboe
 * @example
 *   ASB_OrderByClause orderBy = new ASB().orderByField(Account.Name).descending();
 */
public with sharing class ASB_OrderByClause implements ASB_Clause {
  private final Schema.SObjectField[] fields;
  private String direction;
  private String nullPlacement;

  public ASB_OrderByClause(Schema.SObjectField[] sObjFields) {
    this.fields = sObjFields;
  }

  /**
   * @apexdoc
   * @description Set order direction to descending.
   * @return ASB_OrderByClause for chaining.
   * @example
   *   new ASB().orderByField(Account.Name).descending();
   */
  public ASB_OrderByClause descending() {
    this.direction = 'DESC';
    return this;
  }

  /**
   * @apexdoc
   * @description Set order direction to Ascending.
   * @return ASB_OrderByClause for chaining.
   * @example
   *   new ASB().orderByField(Account.Name).ascending();
   */
  public ASB_OrderByClause ascending() {
    this.direction = 'ASC';
    return this;
  }

  /**
   * @apexdoc
   * @description Orders by nulls first.
   * @return ASB_OrderByClause for chaining.
   * @example
   *   new ASB().orderByField(Account.Name).nullsFirst();
   */
  public ASB_OrderByClause nullsFirst() {
    this.nullPlacement = 'FIRST';
    return this;
  }

  /**
   * @apexdoc
   * @description Orders by nulls last.
   * @return ASB_OrderByClause for chaining.
   * @example
   *   new ASB().orderByField(Account.Name).nullsLast();
   */
  public ASB_OrderByClause nullsLast() {
    this.nullPlacement = 'LAST';
    return this;
  }

  /**
   * @apexdoc
   * @description Returns complete ORDER BY clause string.
   * @param ctx The bind context for query string generation.
   * @return The ORDER BY clause as a String.
   * @example
   *   String soql = new ASB().orderByField(Account.Name).clauseString(new ASB_BindContext());
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
