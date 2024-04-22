/**
 * A clause element used in a SOQL string.
 */
public interface ASB_SOQLClause {
  /**
   * Returns a complete clause as a string
   * @return  `String`
   */
  String toClauseString();
}
