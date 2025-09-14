---
title: ASB_FromClause
---

# ASB_FromClause Interface

Interface for FROM clauses in SOQL queries. Extends ASB_Clause.

**Group** Clause

**See** [ASB_FromRelationshipClause](ASB_FromRelationshipClause)

**See** [ASB_FromSObjectClause](ASB_FromSObjectClause)

## Example
```apex
  ASB asb = new ASB();
  ASB_FromClause from = asb.make(Account.SObjectType);
```

**Extends**
[ASB_Clause](ASB_Clause)

## Methods
### `clauseString(ctx)`

*Inherited*

Returns a complete clause as a string.

#### Signature
```apex
public String clauseString(ASB_BindContext ctx)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| ctx | ASB_BindContext | The bind context for query string generation. |

#### Return Type
**String**

String The clause as a string.

#### Example
```apex
  String clause = new ASB().selection().clauseString(new ASB_BindContext());
```

---

### `getIdField()`

Returns the Id field for the SObject in the FROM clause.

#### Signature
```apex
public Schema.SObjectField getIdField()
```

#### Return Type
**Schema.SObjectField**

Schema.SObjectField The Id field.

#### Example
```apex
  Schema.SObjectField idField = new ASB().make(Account.SObjectType).queryEngine.getASBFrom().getIdField();
```