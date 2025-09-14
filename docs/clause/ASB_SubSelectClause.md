---
title: ASB_SubSelectClause
---

# ASB_SubSelectClause Class

Represents a subquery SELECT clause builder for SOQL queries. Implements ASB_Selectable.

**Group** Clause

**See** [ASB_Selectable](ASB_Selectable)

**See** [ASB_SubSelectClause](ASB_SubSelectClause)

## Example
```apex
  ASB_SubSelectClause subSelect = new ASB().subSelection()
    .field(Contact.Email)
    .parent(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name });
  String soql = subSelect.clauseString(new ASB_BindContext());
```

**Implements**

[ASB_Selectable](ASB_Selectable)

## Constructors
### `ASB_SubSelectClause(sObjType)`

Constructs a new ASB_SubSelectClause for the given SObject type.

#### Signature
```apex
public ASB_SubSelectClause(SObjectType sObjType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjType | SObjectType | The SObject type for the subquery SELECT clause. |

#### Example
```apex
  ASB_SubSelectClause subSelect = new ASB().subSelection();
```

## Methods
### `clauseString(ctx)`

Returns the subquery SELECT clause as a query string.

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

The subquery SELECT clause as a String.

#### Example
```apex
  String soql = new ASB().subSelection().field(Contact.Email).clauseString(new ASB_BindContext());
```

---

### `field(field)`

Adds a field to the subquery SELECT clause.

#### Signature
```apex
public ASB_SubSelectClause field(Schema.SObjectField field)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| field | Schema.SObjectField | Field to add to select clause. |

#### Return Type
**[ASB_SubSelectClause](ASB_SubSelectClause)**

ASB_SubSelectClause for chaining.

#### Example
```apex
  new ASB().subSelection().field(Contact.Email);
```

---

### `mergeInto(subSelectClause)`

Merges the elements of this subquery select clause into another ASB_SubSelectClause instance.

#### Signature
```apex
public void mergeInto(ASB_SubSelectClause subSelectClause)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| subSelectClause | [ASB_SubSelectClause](ASB_SubSelectClause) | The target subquery select clause to merge into. |

#### Return Type
**void**

#### Example
```apex
  new ASB().subSelection().mergeInto(otherSubSelectClause);
```

---

### `parent(fieldPath)`

Adds a parent record field to the subquery SELECT clause.

#### Signature
```apex
public ASB_SubSelectClause parent(List<Schema.SObjectField> fieldPath)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldPath | List&lt;Schema.SObjectField&gt; | Path to parent field as a list of SObjectFields. |

#### Return Type
**[ASB_SubSelectClause](ASB_SubSelectClause)**

ASB_SubSelectClause for chaining.

#### Example
```apex
  new ASB().subSelection().parent(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name });
```

---

### `parent(relField1, relField2)`

Adds a parent record field to the subquery SELECT clause using two SObjectFields.

#### Signature
```apex
public ASB_SubSelectClause parent(Schema.SObjectField relField1, Schema.SObjectField relField2)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| relField1 | Schema.SObjectField | First field in the path. |
| relField2 | Schema.SObjectField | Second field in the path. |

#### Return Type
**[ASB_SubSelectClause](ASB_SubSelectClause)**

ASB_SubSelectClause for chaining.

#### Example
```apex
  new ASB().subSelection().parent(Contact.AccountId, Account.Name);
```