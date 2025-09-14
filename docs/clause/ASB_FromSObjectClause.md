---
title: ASB_FromSObjectClause
---

# ASB_FromSObjectClause Class

FROM clause for a SOQL query based on a root SObject type. Implements ASB_FromClause.

**Group** Clause

**See** [ASB_FromClause](ASB_FromClause)

**See** [ASB_FromSObjectClause](ASB_FromSObjectClause)

## Example
```apex
  ASB_FromSObjectClause fromClause = (ASB_FromSObjectClause)new ASB().make(Account.SObjectType).queryEngine.getASBFrom();
```

**Implements**

[ASB_FromClause](ASB_FromClause)

## Fields
### `sObjType`

`TESTVISIBLE`

#### Signature
```apex
public final sObjType
```

#### Type
Schema.SObjectType

## Constructors
### `ASB_FromSObjectClause(sObjType)`

Creates new instance of ASB_From based on given SObjectType.

#### Signature
```apex
public ASB_FromSObjectClause(Schema.SObjectType sObjType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjType | Schema.SObjectType | Type to make the FROM clause for. |

#### Example
```apex
  ASB_FromSObjectClause fromClause = (ASB_FromSObjectClause)new ASB().make(Account.SObjectType).queryEngine.getASBFrom();
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
  String fromStr = new ASB().make(Account.SObjectType).queryEngine.getASBFrom().clauseString(new ASB_BindContext());
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