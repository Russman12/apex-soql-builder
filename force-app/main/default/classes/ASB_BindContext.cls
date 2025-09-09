public with sharing class ASB_BindContext {
  private Map<Object, String> placeholderCache = new Map<Object, String>();
  private Map<String, Object> bindings = new Map<String, Object>();

  public String bind(Object source, Object value, String prefix) {
    if (!placeholderCache.containsKey(source)) {
      String baseName = (prefix == null ? 'param' : prefix);
      String key = key(baseName);
      placeholderCache.put(source, key);
      bindings.put(key, value);
    }
    return ':' + placeholderCache.get(source);
  }

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
