---
title: ASB_FromRelationshipClause
---

# ASB_FromRelationshipClause Class

FROM clause for a SOQL subquery based on a relationship field. Implements ASB_FromClause.

**Group** Clause

**See** [ASB_FromClause](ASB_FromClause)

**See** [ASB_FromSObjectClause](ASB_FromSObjectClause)

## Example
```apex
  ASB_FromRelationshipClause fromRel = (ASB_FromRelationshipClause)new ASB().subQuery(Contact.AccountId).relatedBy();
```

**Implements**

[ASB_FromClause](ASB_FromClause)

## Constructors
### `ASB_FromRelationshipClause(relationshipField)`

Creates new instance of ASB_From based on given relationship field.

#### Signature
```apex
public ASB_FromRelationshipClause(Schema.SObjectField relationshipField)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| relationshipField | Schema.SObjectField | The relationship to make the FROM clause for. |

#### Example
```apex
  ASB_FromRelationshipClause fromRel = (ASB_FromRelationshipClause)new ASB().subQuery(Contact.AccountId).relatedBy();
```

## Methods
### `clauseString(ctx)`

Converts the FROM clause to a query string.

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

String The FROM clause as a string.

#### Example
```apex
  String fromStr = new ASB().subQuery(Contact.AccountId).relatedBy().clauseString(new ASB_BindContext());
```

---

### `equals(obj)`

#### Signature
```apex
public Boolean equals(Object obj)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| obj | Object |  |

#### Return Type
**Boolean**

---

### `getIdField()`

Returns ID field for the related object.

#### Signature
```apex
public Schema.SObjectField getIdField()
```

#### Return Type
**Schema.SObjectField**

Schema.SObjectField The Id field.

#### Example
```apex
  Schema.SObjectField idField = new ASB().subQuery(Contact.AccountId).relatedBy().getIdField();
```

---

### `hashCode()`

#### Signature
```apex
public Integer hashCode()
```

#### Return Type
**Integer**

## Classes
### InvalidRelationshipException Class