---
title: ASB
---

# ASB Class

Entry point for Apex SOQL Builder. Provides methods to construct various ASB query components.

**See** [ASB_Clause](..\clause\ASB_Clause)

**See** [ASB_QueryBuilder](ASB_QueryBuilder)

**See** [ASB_SelectClause](..\clause\ASB_SelectClause)

**See** [ASB_SubQueryBuilder](ASB_SubQueryBuilder)

**See** [ASB_SubSelectClause](..\clause\ASB_SubSelectClause)

**See** [ASB_WhereClause](..\clause\ASB_WhereClause)

**See** [ASB_OrderByClause](..\clause\ASB_OrderByClause)

**See** [ASB_LimitClause](..\clause\ASB_LimitClause)

## Example
```apex
  ASB asb = new ASB();
  ASB_QueryBuilder builder = asb.make(Account.SObjectType)
    .selection(asb.selection().field(Account.Name))
    .filter(asb.filter().field(Account.Name).eq('Google'));
```

## Methods
### `filter()`

Creates a new ASB_WhereClause.Builder instance.

#### Signature
```apex
public ASB_WhereClause.Builder filter()
```

#### Return Type
**ASB_WhereClause.Builder**

ASB_WhereClause.Builder

#### Example
```apex
  ASB asb = new ASB();
  ASB_WhereClause.Builder where = asb.filter();
```

---

### `make(sObjType)`

Creates new ASB_QueryBuilder instance for the given SObject type.

#### Signature
```apex
public ASB_QueryBuilder make(Schema.SObjectType sObjType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjType | Schema.SObjectType | Type to make the FROM clause for. |

#### Return Type
**[ASB_QueryBuilder](ASB_QueryBuilder)**

ASB_QueryBuilder

#### Example
```apex
  ASB asb = new ASB();
  ASB_QueryBuilder builder = asb.make(Account.SObjectType);
```

---

### `orderByField(field)`

Sets a field in the ORDER BY clause.

#### Signature
```apex
public ASB_OrderByClause orderByField(Schema.SObjectField field)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| field | Schema.SObjectField | The field to order by. |

#### Return Type
**[ASB_OrderByClause](..\clause\ASB_OrderByClause)**

ASB_OrderByClause

#### Example
```apex
  ASB asb = new ASB();
  ASB_OrderByClause orderBy = asb.orderByField(Account.Name);
```

---

### `orderByFields(field1, field2)`

Sets two fields in the ORDER BY clause.

#### Signature
```apex
public ASB_OrderByClause orderByFields(Schema.SObjectField field1, Schema.SObjectField field2)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| field1 | Schema.SObjectField | The first field. |
| field2 | Schema.SObjectField | The second field. |

#### Return Type
**[ASB_OrderByClause](..\clause\ASB_OrderByClause)**

ASB_OrderByClause

#### Example
```apex
  ASB asb = new ASB();
  ASB_OrderByClause orderBy = asb.orderByFields(Account.Name, Account.Id);
```

---

### `orderByFields(fields)`

Sets fields in the ORDER BY clause.

#### Signature
```apex
public ASB_OrderByClause orderByFields(Schema.SObjectField fields)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fields | Schema.SObjectField | Array of fields to order by. |

#### Return Type
**[ASB_OrderByClause](..\clause\ASB_OrderByClause)**

ASB_OrderByClause

#### Example
```apex
  ASB asb = new ASB();
  ASB_OrderByClause orderBy = asb.orderByFields(new List<Schema.SObjectField>{ Account.Name, Account.Id });
```

---

### `recordLimit(recordLimit)`

Returns new ASB_LimitClause instance for the query.

#### Signature
```apex
public ASB_LimitClause recordLimit(Integer recordLimit)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordLimit | Integer | The record limit to set. |

#### Return Type
**[ASB_LimitClause](..\clause\ASB_LimitClause)**

ASB_LimitClause

#### Example
```apex
  ASB asb = new ASB();
  ASB_LimitClause limit = asb.recordLimit(10);
```

---

### `selection()`

Creates a new ASB_SelectClause instance.

#### Signature
```apex
public ASB_SelectClause selection()
```

#### Return Type
**[ASB_SelectClause](..\clause\ASB_SelectClause)**

ASB_SelectClause

#### Example
```apex
  ASB asb = new ASB();
  ASB_SelectClause select = asb.selection();
```

---

### `subQuery(relationshipField)`

Creates a new ASB_SubQueryBuilder from the given relationship field.

#### Signature
```apex
public ASB_SubQueryBuilder subQuery(Schema.sObjectField relationshipField)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| relationshipField | Schema.sObjectField | Relationship field from child to parent. |

#### Return Type
**[ASB_SubQueryBuilder](ASB_SubQueryBuilder)**

ASB_SubQueryBuilder

#### Example
```apex
  ASB asb = new ASB();
  ASB_SubQueryBuilder subQuery = asb.subQuery(Contact.AccountId);
```

---

### `subSelection()`

Creates a new ASB_SubSelectClause instance.

#### Signature
```apex
public ASB_SubSelectClause subSelection()
```

#### Return Type
**[ASB_SubSelectClause](..\clause\ASB_SubSelectClause)**

ASB_SubSelectClause

#### Example
```apex
  ASB asb = new ASB();
  ASB_SubSelectClause subSelect = asb.subSelection();
```