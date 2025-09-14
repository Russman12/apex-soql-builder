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
 * @ignore
 * @description Context for managing bind variables in SOQL queries built with Apex SOQL Builder.
 * @example
 * ```
 *   ASB_BindContext ctx = new ASB_BindContext();
 *   String bindVar = ctx.bind(this, 123, 'myParam');
 *   Map<String, Object> binds = ctx.getBinds();
 * ```
 */
public with sharing class ASB_BindContext {
  private Map<Object, String> placeholderCache = new Map<Object, String>();
  private Map<String, Object> bindings = new Map<String, Object>();

  /**
   * @description Binds a value to a parameter name for use in a SOQL query.
   * @param source The source object for the bind.
   * @param value The value to bind.
   * @param prefix The prefix for the bind variable name.
   * @return The bind variable as a String (e.g., ':myParam1').
   * @example
   * ```
   *   String bindVar = new ASB_BindContext().bind(this, 123, 'myParam');
   * ```
   */
  public String bind(Object source, Object value, String prefix) {
    if (!placeholderCache.containsKey(source)) {
      String baseName = (prefix == null ? 'param' : prefix);
      String key = key(baseName);
      placeholderCache.put(source, key);
      bindings.put(key, value);
    }
    return ':' + placeholderCache.get(source);
  }

  /**
   * @description Returns a map of all bind variable names to their values.
   * @return Map<String, Object> of bind variables.
   * @example
   * ```
   *   Map<String, Object> binds = new ASB_BindContext().getBinds();
   * ```
   */
  public Map<String, Object> getBinds() {
    return new Map<String, Object>(bindings);
  }

  private String key(String baseName) {
    Integer counter = 0;
    String key;
    do {
      counter++;
      key = baseName + counter;
    } while (bindings.containsKey(key));

    return key;
  }
}
