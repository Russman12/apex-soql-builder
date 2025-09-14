---
title: ASB_OrderByClause
---

# ASB_OrderByClause Class

Encompasses functionality relating to a SOQL ORDER BY clause.

**Group** Clause

## Example
```apex
  ASB_OrderByClause orderBy = new ASB().orderByField(Account.Name).descending();
```

**Implements**

[ASB_Clause](ASB_Clause)

## Constructors
### `ASB_OrderByClause(sObjFields)`

#### Signature
```apex
public ASB_OrderByClause(Schema.SObjectField sObjFields)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjFields | Schema.SObjectField |  |

## Methods
### `ascending()`

Set order direction to Ascending.

#### Signature
```apex
public ASB_OrderByClause ascending()
```

#### Return Type
**[ASB_OrderByClause](ASB_OrderByClause)**

ASB_OrderByClause for chaining.

#### Example
```apex
  new ASB().orderByField(Account.Name).ascending();
```

---

### `clauseString(ctx)`

Returns complete ORDER BY clause string.

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

The ORDER BY clause as a String.

#### Example
```apex
  String soql = new ASB().orderByField(Account.Name).clauseString(new ASB_BindContext());
```

---

### `descending()`

Set order direction to descending.

#### Signature
```apex
public ASB_OrderByClause descending()
```

#### Return Type
**[ASB_OrderByClause](ASB_OrderByClause)**

ASB_OrderByClause for chaining.

#### Example
```apex
  new ASB().orderByField(Account.Name).descending();
```

---

### `nullsFirst()`

Orders by nulls first.

#### Signature
```apex
public ASB_OrderByClause nullsFirst()
```

#### Return Type
**[ASB_OrderByClause](ASB_OrderByClause)**

ASB_OrderByClause for chaining.

#### Example
```apex
  new ASB().orderByField(Account.Name).nullsFirst();
```

---

### `nullsLast()`

Orders by nulls last.

#### Signature
```apex
public ASB_OrderByClause nullsLast()
```

#### Return Type
**[ASB_OrderByClause](ASB_OrderByClause)**

ASB_OrderByClause for chaining.

#### Example
```apex
  new ASB().orderByField(Account.Name).nullsLast();
```