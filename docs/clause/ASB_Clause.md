---
title: ASB_Clause
---

# ASB_Clause Interface

Interface that ensures that a class can be used in a SOQL query.

**Group** Clause

## Methods
### `clauseString(ctx)`

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