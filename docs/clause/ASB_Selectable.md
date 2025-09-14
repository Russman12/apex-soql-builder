---
title: ASB_Selectable
---

# ASB_Selectable Interface

Interface for classes that support adding fields and parent fields to a SELECT clause.

**Group** Clause

**See** [ASB_SelectClause](ASB_SelectClause)

**See** [ASB_SubSelectClause](ASB_SubSelectClause)

## Example
```apex
  ASB_Selectable selectable = new ASB().selection();
  selectable.field(Account.Name);
  selectable.parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
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

### `field(field)`

Adds a field to the SELECT clause.

#### Signature
```apex
public ASB_Selectable field(Schema.SObjectField field)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| field | Schema.SObjectField | Field to add to select clause. |

#### Return Type
**[ASB_Selectable](ASB_Selectable)**

ASB_Selectable for chaining.

#### Example
```apex
  new ASB().selection().field(Account.Name);
```

---

### `parent(relationshipPath)`

Adds a parent record field to the SELECT clause.

#### Signature
```apex
public ASB_Selectable parent(List<Schema.SObjectField> relationshipPath)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| relationshipPath | List&lt;Schema.SObjectField&gt; | Path to parent field as a list of SObjectFields. |

#### Return Type
**[ASB_Selectable](ASB_Selectable)**

ASB_Selectable for chaining.

#### Example
```apex
  new ASB().selection().parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
```