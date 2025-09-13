/**
 * @interface ASB_Selectable
 * @description Interface for classes that support adding fields and parent fields to a SELECT clause.
 * @example
 *   ASB_Selectable selectable = new ASB().selection();
 *   selectable.field(Account.Name);
 *   selectable.parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
 */
public interface ASB_Selectable extends ASB_Clause {
  /**
   * @apexdoc
   * @description Adds a field to the SELECT clause.
   * @param field Field to add to select clause.
   * @return ASB_Selectable for chaining.
   * @example
   *   new ASB().selection().field(Account.Name);
   */
  ASB_Selectable field(Schema.SObjectField field);
  /**
   * @apexdoc
   * @description Adds a parent record field to the SELECT clause.
   * @param relationshipPath Path to parent field as a list of SObjectFields.
   * @return ASB_Selectable for chaining.
   * @example
   *   new ASB().selection().parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
   */
  ASB_Selectable parent(List<Schema.SObjectField> relationshipPath);
}
