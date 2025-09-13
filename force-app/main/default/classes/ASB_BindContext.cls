/**
 * @class ASB_BindContext
 * @description Context for managing bind variables in SOQL queries built with Apex SOQL Builder.
 * @example
 *   ASB_BindContext ctx = new ASB_BindContext();
 *   String bindVar = ctx.bind(this, 123, 'myParam');
 *   Map<String, Object> binds = ctx.getBinds();
 */
public with sharing class ASB_BindContext {
  private Map<Object, String> placeholderCache = new Map<Object, String>();
  private Map<String, Object> bindings = new Map<String, Object>();

  /**
   * @apexdoc
   * @description Binds a value to a parameter name for use in a SOQL query.
   * @param source The source object for the bind.
   * @param value The value to bind.
   * @param prefix The prefix for the bind variable name.
   * @return The bind variable as a String (e.g., ':myParam1').
   * @example
   *   String bindVar = new ASB_BindContext().bind(this, 123, 'myParam');
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
   * @apexdoc
   * @description Returns a map of all bind variable names to their values.
   * @return Map<String, Object> of bind variables.
   * @example
   *   Map<String, Object> binds = new ASB_BindContext().getBinds();
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
