/**
 * @interface ASB_Clause
 * @description Interface that ensures that a class can be used in a SOQL query.
 * @author Russell Laboe
 * @example
 *   // Any class implementing ASB_Clause can be used in a SOQL builder context
 */
public interface ASB_Clause {
  /**
   * @apexdoc
   * @description Returns a complete clause as a string.
   * @param ctx The bind context for query string generation.
   * @return String The clause as a string.
   * @example
   *   String clause = new ASB().selection().clauseString(new ASB_BindContext());
   */
  String clauseString(ASB_BindContext ctx);
}
