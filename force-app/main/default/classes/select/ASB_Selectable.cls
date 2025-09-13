public interface ASB_Selectable extends ASB_Clause {
  ASB_Selectable field(Schema.SObjectField field);
  ASB_Selectable parent(List<Schema.SObjectField> relationshipPath);
}
