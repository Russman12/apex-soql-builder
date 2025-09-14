---
title: ASB_SelectClause
---

# ASB_SelectClause Class

Represents a SELECT clause builder for SOQL queries. Implements ASB_Selectable.

**Group** Clause

**See** [ASB_Selectable](ASB_Selectable)

**See** [ASB_SubSelectClause](ASB_SubSelectClause)

## Example
```apex
  ASB_SelectClause selectClause = new ASB().selection()
    .field(Account.Name)
    .parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
  String soql = selectClause.clauseString(new ASB_BindContext());
```

**Implements**

[ASB_Selectable](ASB_Selectable)

## Constructors
### `ASB_SelectClause(sObjType)`

Constructs a new ASB_SelectClause for the given SObject type.

#### Signature
```apex
public ASB_SelectClause(Schema.SObjectType sObjType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjType | Schema.SObjectType | The SObject type for the SELECT clause. |

#### Example
```apex
  ASB_SelectClause selectClause = new ASB().selection();
```

## Methods
### `clauseString(ctx)`

Returns the SELECT clause as a query string.

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

The SELECT clause as a String.

#### Example
```apex
  String soql = new ASB().selection().field(Account.Name).clauseString(new ASB_BindContext());
```

---

### `field(field)`

Adds a field to the SELECT clause.

#### Signature
```apex
public ASB_SelectClause field(Schema.SObjectField field)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| field | Schema.SObjectField | Field to add to select clause. |

#### Return Type
**[ASB_SelectClause](ASB_SelectClause)**

ASB_SelectClause for chaining.

#### Example
```apex
  new ASB().selection().field(Account.Name);
```

---

### `mergeInto(selectClause)`

Merges the elements of this select clause into another ASB_SelectClause instance.

#### Signature
```apex
public void mergeInto(ASB_SelectClause selectClause)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| selectClause | [ASB_SelectClause](ASB_SelectClause) | The target select clause to merge into. |

#### Return Type
**void**

#### Example
```apex
  new ASB().selection().mergeInto(otherSelectClause);
```

---

### `parent(fieldPath)`

Adds a parent record field to the SELECT clause.

#### Signature
```apex
public ASB_SelectClause parent(List<Schema.SObjectField> fieldPath)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldPath | List&lt;Schema.SObjectField&gt; | Path to parent field as a list of SObjectFields. |

#### Return Type
**[ASB_SelectClause](ASB_SelectClause)**

ASB_SelectClause for chaining.

#### Example
```apex
  new ASB().selection().parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
```

---

### `parent(fieldPath1, fieldPath2)`

Adds a parent record field to the SELECT clause using two SObjectFields.

#### Signature
```apex
public ASB_SelectClause parent(Schema.SObjectField fieldPath1, Schema.SObjectField fieldPath2)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldPath1 | Schema.SObjectField | First field in the path. |
| fieldPath2 | Schema.SObjectField | Second field in the path. |

#### Return Type
**[ASB_SelectClause](ASB_SelectClause)**

ASB_SelectClause for chaining.

#### Example
```apex
  new ASB().selection().parent(Opportunity.Account, Account.Name);
```

---

### `parent(fieldPath1, fieldPath2, fieldPath3)`

Adds a parent record field to the SELECT clause using three SObjectFields.

#### Signature
```apex
public ASB_SelectClause parent(Schema.SObjectField fieldPath1, Schema.SObjectField fieldPath2, Schema.SObjectField fieldPath3)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldPath1 | Schema.SObjectField | First field in the path. |
| fieldPath2 | Schema.SObjectField | Second field in the path. |
| fieldPath3 | Schema.SObjectField | Third field in the path. |

#### Return Type
**[ASB_SelectClause](ASB_SelectClause)**

ASB_SelectClause for chaining.

#### Example
```apex
  new ASB().selection().parent(Opportunity.Account, Account.Parent, Account.Name);
```

---

### `subquery(subquery)`

Adds a subquery to the SELECT clause.

#### Signature
```apex
public ASB_SelectClause subquery(ASB_SubQueryBuilder subquery)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| subquery | [ASB_SubQueryBuilder](..\miscellaneous\ASB_SubQueryBuilder) | The subquery builder to add. |

#### Return Type
**[ASB_SelectClause](ASB_SelectClause)**

ASB_SelectClause for chaining.

#### Example
```apex
  new ASB().selection().subquery(subQueryBuilder);
```