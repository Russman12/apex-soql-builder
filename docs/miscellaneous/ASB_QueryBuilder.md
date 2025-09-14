---
title: ASB_QueryBuilder
---

# ASB_QueryBuilder Class

Entry point of Apex SOQL Builder. This class encompasses functionality relating to building a SOQL query.

**See** ASB_QueryEngine

**See** [ASB_SubQueryBuilder](ASB_SubQueryBuilder)

## Example
```apex
  List<Account> accs = (List<Account>)new ASB().make(Account.SObjectType)
    .selection(new ASB().selection().field(Account.Name))
    .filter(asb.filter())
    .orderBy(asb.orderByField(Account.Name))
    .recordLimit(10)
    .query();
```

## Fields
### `accessLevel`

#### Signature
```apex
public accessLevel
```

#### Type
System.AccessLevel

## Constructors
### `ASB_QueryBuilder(fromSObj, selectClause)`

Constructs a new ASB_QueryBuilder with the given FROM and SELECT clauses.

#### Signature
```apex
public ASB_QueryBuilder(ASB_FromSObjectClause fromSObj, ASB_SelectClause selectClause)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fromSObj | [ASB_FromSObjectClause](..\clause\ASB_FromSObjectClause) | The FROM clause for the query. |
| selectClause | [ASB_SelectClause](..\clause\ASB_SelectClause) | The SELECT clause for the query. |

#### Example
```apex
  ASB_QueryBuilder builder = new ASB().make(Account.SObjectType);
```

## Methods
### `filter(asbWhere)`

Adds a filter (WHERE clause) to the query.

#### Signature
```apex
public ASB_QueryBuilder filter(ASB_WhereClause asbWhere)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| asbWhere | [ASB_WhereClause](..\clause\ASB_WhereClause) | The where clause to add. |

#### Return Type
**[ASB_QueryBuilder](ASB_QueryBuilder)**

ASB_QueryBuilder for chaining.

#### Example
```apex
  new ASB().make(Account.SObjectType).filter(asb.filter());
```

---

### `orderBy(orderBy)`

Adds an ORDER BY clause to the query.

#### Signature
```apex
public ASB_QueryBuilder orderBy(ASB_OrderByClause orderBy)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| orderBy | [ASB_OrderByClause](..\clause\ASB_OrderByClause) | The order by clause to add. |

#### Return Type
**[ASB_QueryBuilder](ASB_QueryBuilder)**

ASB_QueryBuilder for chaining.

#### Example
```apex
  new ASB().make(Account.SObjectType).orderBy(asb.orderByField(Account.Name));
```

---

### `query()`

Executes the SOQL query.

#### Signature
```apex
public List<SObject> query()
```

#### Return Type
**List&lt;SObject&gt;**

List&lt;SObject&gt; The query results.

#### Example
```apex
  List<Account> accs = (List<Account>)new ASB().make(Account.SObjectType).query();
```

---

### `recordLimit(recordLimit)`

Adds a LIMIT clause to the query.

#### Signature
```apex
public ASB_QueryBuilder recordLimit(Integer recordLimit)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordLimit | Integer | The record limit to set. |

#### Return Type
**[ASB_QueryBuilder](ASB_QueryBuilder)**

ASB_QueryBuilder for chaining.

#### Example
```apex
  new ASB().make(Account.SObjectType).recordLimit(10);
```

---

### `selection(selectClause)`

Sets the select portion of the query.

#### Signature
```apex
public ASB_QueryBuilder selection(ASB_SelectClause selectClause)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| selectClause | [ASB_SelectClause](..\clause\ASB_SelectClause) | The select clause to merge. |

#### Return Type
**[ASB_QueryBuilder](ASB_QueryBuilder)**

ASB_QueryBuilder for chaining.

#### Example
```apex
  new ASB().make(Account.SObjectType).selection(new ASB().selection().field(Account.Name));
```

## Classes
### LimitException Class