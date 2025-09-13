/**
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
