---
title: ASB_SubQueryBuilder
---

# ASB_SubQueryBuilder Class

Encompasses functionality relating to a SOQL subquery.

**See** ASB_QueryEngine

**See** [ASB_QueryBuilder](ASB_QueryBuilder)

## Example
```apex
  ASB_SubQueryBuilder subQuery = new ASB().subQuery(Contact.AccountId)
    .selection(new ASB().subSelection().field(Contact.Email))
    .filter(asb.filter())
    .orderBy(asb.orderByField(Contact.LastName))
    .recordLimit(10);
```

## Constructors
### `ASB_SubQueryBuilder(fromRelationship, subSelectClause)`

#### Signature
```apex
public ASB_SubQueryBuilder(ASB_FromRelationshipClause fromRelationship, ASB_SubSelectClause subSelectClause)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| fromRelationship | [ASB_FromRelationshipClause](..\clause\ASB_FromRelationshipClause) |  |
| subSelectClause | [ASB_SubSelectClause](..\clause\ASB_SubSelectClause) |  |

## Methods
### `filter(asbWhere)`

Adds a filter (WHERE clause) to the subquery.

#### Signature
```apex
public ASB_SubQueryBuilder filter(ASB_WhereClause asbWhere)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| asbWhere | [ASB_WhereClause](..\clause\ASB_WhereClause) | The where clause to add. |

#### Return Type
**[ASB_SubQueryBuilder](ASB_SubQueryBuilder)**

ASB_SubQueryBuilder for chaining.

#### Example
```apex
  new ASB().subQuery(Contact.AccountId).filter(asb.filter());
```

---

### `mergeInto(subQuery)`

Merges this subquery into another subquery. Throws InvalidCombineException if not compatible.

#### Signature
```apex
public ASB_SubQueryBuilder mergeInto(ASB_SubQueryBuilder subQuery)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| subQuery | [ASB_SubQueryBuilder](ASB_SubQueryBuilder) | The subquery to merge into. |

#### Return Type
**[ASB_SubQueryBuilder](ASB_SubQueryBuilder)**

ASB_SubQueryBuilder

#### Throws
InvalidCombineException: thrown if any element of the query cannot be combined

#### Example
```apex
  subQuery1.mergeInto(subQuery2);
```

---

### `orderBy(orderBy)`

Adds an ORDER BY clause to the subquery.

#### Signature
```apex
public ASB_SubQueryBuilder orderBy(ASB_OrderByClause orderBy)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| orderBy | [ASB_OrderByClause](..\clause\ASB_OrderByClause) | The order by clause to add. |

#### Return Type
**[ASB_SubQueryBuilder](ASB_SubQueryBuilder)**

ASB_SubQueryBuilder for chaining.

#### Example
```apex
  new ASB().subQuery(Contact.AccountId).orderBy(asb.orderByField(Contact.LastName));
```

---

### `queryDetail(ctx)`

Returns the SOQL string for this subquery.

#### Signature
```apex
public String queryDetail(ASB_BindContext ctx)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| ctx | ASB_BindContext | The bind context for query string generation. |

#### Return Type
**String**

The subquery as a String.

#### Example
```apex
  String soql = new ASB().subQuery(Contact.AccountId).queryDetail(new ASB_BindContext());
```

---

### `recordLimit(recordLimit)`

Adds a LIMIT clause to the subquery.

#### Signature
```apex
public ASB_SubQueryBuilder recordLimit(Integer recordLimit)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordLimit | Integer | The record limit to set. |

#### Return Type
**[ASB_SubQueryBuilder](ASB_SubQueryBuilder)**

ASB_SubQueryBuilder for chaining.

#### Example
```apex
  new ASB().subQuery(Contact.AccountId).recordLimit(10);
```

---

### `relatedBy()`

Returns the relationship clause this subquery is related by.

#### Signature
```apex
public ASB_FromRelationshipClause relatedBy()
```

#### Return Type
**[ASB_FromRelationshipClause](..\clause\ASB_FromRelationshipClause)**

ASB_FromRelationshipClause

#### Example
```apex
  ASB_FromRelationshipClause rel = new ASB().subQuery(Contact.AccountId).relatedBy();
```

---

### `selection(subSelectClause)`

Adds the given subselect clause to the subquery.

#### Signature
```apex
public ASB_SubQueryBuilder selection(ASB_SubSelectClause subSelectClause)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| subSelectClause | [ASB_SubSelectClause](..\clause\ASB_SubSelectClause) | The subselect clause to merge. |

#### Return Type
**[ASB_SubQueryBuilder](ASB_SubQueryBuilder)**

ASB_SubQueryBuilder for chaining.

#### Example
```apex
  new ASB().subQuery(Contact.AccountId).selection(new ASB().subSelection().field(Contact.Email));
```