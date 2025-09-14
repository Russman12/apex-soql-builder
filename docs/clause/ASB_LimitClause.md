---
title: ASB_LimitClause
---

# ASB_LimitClause Class

This class encompasses functionality relating to building a LIMIT clause.

**Group** Clause

## Example
```apex
  ASB_LimitClause limit = new ASB().recordLimit(10);
```

**Implements**

[ASB_Clause](ASB_Clause)

## Constructors
### `ASB_LimitClause(limitx)`

Creates new limit instance.

#### Signature
```apex
public ASB_LimitClause(Integer limitx)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| limitx | Integer | value to set limit to. |

#### Example
```apex
  new ASB().recordLimit(10);
```

## Methods
### `clauseString(ctx)`

Returns complete clause string

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

String

#### Example
```apex
  String soql = new ASB().recordLimit(10).clauseString(new ASB_BindContext());
```

## Classes
### IllegalArgumentException Class