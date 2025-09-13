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
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 * @example
 *   ASB_LimitClause limit = new ASB().recordLimit(10);
 */
public with sharing class ASB_LimitClause implements ASB_Clause {
  @TestVisible
  private static final String BIND_NAME = 'RECORD_LIMIT';

  private String bindPrefix = '';
  private Map<String, Object> binds = new Map<String, Object>();

  private final Integer limitx;

  /**
   * @apexdoc
   * @description Creates new limit instance.
   * @param limitx value to set limit to.
   * @example
   *   new ASB().recordLimit(10);
   */
  public ASB_LimitClause(Integer limitx) {
    if (limitx <= 0) {
      throw new IllegalArgumentException('LIMIT must be positive');
    }
    this.limitx = limitx;
  }

  /**
   * @apexdoc
   * @description Returns complete clause string
   * @param ctx The bind context for query string generation.
   * @return   String
   * @example
   *   String soql = new ASB().recordLimit(10).clauseString(new ASB_BindContext());
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'LIMIT ' + ctx.bind(this, this.limitx, BIND_NAME);
  }

  public class IllegalArgumentException extends Exception {
  }
}
