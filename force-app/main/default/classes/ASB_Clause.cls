/**
 * Interface that ensures that a class can be used in a SOQL query.
 * @author Russell Laboe
 */
public interface ASB_Clause {
  /**
   * Returns a complete clause as a string
   * @return  `String`
   */
  ASB_ClauseDetail clauseDetail();
}
