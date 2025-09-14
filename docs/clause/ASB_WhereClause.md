---
title: ASB_WhereClause
---

# ASB_WhereClause Class

Encompasses functionality relating to building a WHERE clause for SOQL queries.

**Group** Clause

## Example
```apex
  ASB_WhereClause where = new ASB().filter().field(Account.Name).eq('Acme');
  String soql = where.clauseString(new ASB_BindContext());
```

**Implements**

[ASB_Clause](ASB_Clause), 
Expression

## Constructors
### `ASB_WhereClause(expression)`

Constructs a new ASB_WhereClause with the given expression.

#### Signature
```apex
public ASB_WhereClause(Expression expression)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| expression | Expression | The expression to use for the WHERE clause. |

#### Example
```apex
  ASB_WhereClause where = new ASB_WhereClause(new ASB_WhereClause.FieldComparison(new List<Schema.SObjectField>{ Account.Name }).eq('Acme'));
```

## Methods
### `clauseString(ctx)`

Returns the WHERE clause as a query string.

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

String The WHERE clause as a string.

#### Example
```apex
  String soql = new ASB().filter().field(Account.Name).eq('Acme').clauseString(new ASB_BindContext());
```

---

### `queryString(ctx)`

Returns the query string for the expression (without WHERE keyword).

#### Signature
```apex
public String queryString(ASB_BindContext ctx)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| ctx | ASB_BindContext | The bind context for query string generation. |

#### Return Type
**String**

String The expression as a string.

#### Example
```apex
  String expr = new ASB().filter().field(Account.Name).eq('Acme').queryString(new ASB_BindContext());
```

## Classes
### AndLogicalGroup Class

#### Constructors
##### `AndLogicalGroup(expressions)`

###### Signature
```apex
public AndLogicalGroup(List<Expression> expressions)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| expressions | List&lt;Expression&gt; |  |

### Builder Class

Builder for constructing WHERE clause expressions.

#### Example
```apex
  ASB_WhereClause.Builder builder = new ASB().filter();
  ASB_WhereClause where = builder.field(Account.Name).eq('Acme');
```

#### Methods
##### `field(field)`

Adds a field to the WHERE clause.

###### Signature
```apex
public FieldComparison field(Schema.SObjectField field)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| field | Schema.SObjectField | The field to compare. |

###### Return Type
**FieldComparison**

FieldComparison for chaining.

###### Example
```apex
  new ASB().filter().field(Account.Name);
```

---

##### `field(relationshipField, parentField)`

Adds a parent field to the WHERE clause using two fields.

###### Signature
```apex
public FieldComparison field(Schema.SObjectField relationshipField, Schema.SObjectField parentField)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| relationshipField | Schema.SObjectField | The relationship field. |
| parentField | Schema.SObjectField | The parent field. |

###### Return Type
**FieldComparison**

FieldComparison for chaining.

###### Example
```apex
  new ASB().filter().field(Account.OwnerId, User.Name);
```

---

##### `field(fieldPath)`

Adds a field path to the WHERE clause.

###### Signature
```apex
public FieldComparison field(Schema.SObjectField fieldPath)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldPath | Schema.SObjectField | The field path as a list. |

###### Return Type
**FieldComparison**

FieldComparison for chaining.

###### Example
```apex
  new ASB().filter().field(new List<Schema.SObjectField>{ Account.OwnerId, User.Name });
```

---

##### `andGroup(exp1, exp2)`

Creates an AND group of WHERE clauses.

###### Signature
```apex
public ASB_WhereClause andGroup(ASB_WhereClause exp1, ASB_WhereClause exp2)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| exp1 | [ASB_WhereClause](ASB_WhereClause) | First expression. |
| exp2 | [ASB_WhereClause](ASB_WhereClause) | Second expression. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().andGroup(where1, where2);
```

---

##### `andGroup(exp1, exp2, exp3)`

Creates an AND group of three WHERE clauses.

###### Signature
```apex
public ASB_WhereClause andGroup(ASB_WhereClause exp1, ASB_WhereClause exp2, ASB_WhereClause exp3)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| exp1 | [ASB_WhereClause](ASB_WhereClause) | First expression. |
| exp2 | [ASB_WhereClause](ASB_WhereClause) | Second expression. |
| exp3 | [ASB_WhereClause](ASB_WhereClause) | Third expression. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().andGroup(where1, where2, where3);
```

---

##### `andGroup(expressions)`

Creates an AND group from a list of WHERE clauses.

###### Signature
```apex
public ASB_WhereClause andGroup(ASB_WhereClause expressions)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| expressions | [ASB_WhereClause](ASB_WhereClause) | List of expressions. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().andGroup(new List<ASB_WhereClause>{ where1, where2 });
```

---

##### `orGroup(exp1, exp2)`

Creates an OR group of WHERE clauses.

###### Signature
```apex
public ASB_WhereClause orGroup(ASB_WhereClause exp1, ASB_WhereClause exp2)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| exp1 | [ASB_WhereClause](ASB_WhereClause) | First expression. |
| exp2 | [ASB_WhereClause](ASB_WhereClause) | Second expression. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().orGroup(where1, where2);
```

---

##### `orGroup(exp1, exp2, exp3)`

Creates an OR group of three WHERE clauses.

###### Signature
```apex
public ASB_WhereClause orGroup(ASB_WhereClause exp1, ASB_WhereClause exp2, ASB_WhereClause exp3)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| exp1 | [ASB_WhereClause](ASB_WhereClause) | First expression. |
| exp2 | [ASB_WhereClause](ASB_WhereClause) | Second expression. |
| exp3 | [ASB_WhereClause](ASB_WhereClause) | Third expression. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().orGroup(where1, where2, where3);
```

---

##### `orGroup(expressions)`

Creates an OR group from a list of WHERE clauses.

###### Signature
```apex
public ASB_WhereClause orGroup(ASB_WhereClause expressions)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| expressions | [ASB_WhereClause](ASB_WhereClause) | List of expressions. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().orGroup(new List<ASB_WhereClause>{ where1, where2 });
```

### FieldComparison Class

FieldComparison provides methods to build WHERE clause comparisons for a field or field path.

#### Example
```apex
  ASB_WhereClause.FieldComparison cmp = new ASB().filter().field(Account.Name);
  ASB_WhereClause where = cmp.eq('Acme');
```

#### Constructors
##### `FieldComparison(fieldPath)`

Constructs a FieldComparison for the given field path.

###### Signature
```apex
public FieldComparison(List<Schema.SObjectField> fieldPath)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldPath | List&lt;Schema.SObjectField&gt; | The field path as a list. |

###### Example
```apex
  new ASB().filter().field(new List<Schema.SObjectField>{ Account.Name });
```

#### Methods
##### `eq(str)`

Adds an equals comparison to the WHERE clause for a String value.

###### Signature
```apex
public ASB_WhereClause eq(String str)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| str | String | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.Name).eq('Acme');
```

---

##### `eq(val)`

Adds an equals comparison to the WHERE clause for an Integer value.

###### Signature
```apex
public ASB_WhereClause eq(Integer val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Integer | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.NumberOfEmployees).eq(10);
```

---

##### `eq(val)`

Adds an equals comparison to the WHERE clause for a Decimal value.

###### Signature
```apex
public ASB_WhereClause eq(Decimal val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Decimal | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.AnnualRevenue).eq(100000.0);
```

---

##### `eq(val)`

Adds an equals comparison to the WHERE clause for a Date value.

###### Signature
```apex
public ASB_WhereClause eq(Date val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Date | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.CreatedDate).eq(Date.today());
```

---

##### `eq(val)`

Adds an equals comparison to the WHERE clause for a Datetime value.

###### Signature
```apex
public ASB_WhereClause eq(Datetime val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Datetime | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.CreatedDate).eq(Datetime.now());
```

---

##### `eq(val)`

Adds an equals comparison to the WHERE clause for a Boolean value.

###### Signature
```apex
public ASB_WhereClause eq(Boolean val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Boolean | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.IsActive__c).eq(true);
```

---

##### `isNull()`

Adds an IS NULL comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause isNull()
```

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.Name).isNull();
```

---

##### `ne(str)`

Adds a not equals comparison to the WHERE clause for a String value.

###### Signature
```apex
public ASB_WhereClause ne(String str)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| str | String | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.Name).ne('Acme');
```

---

##### `ne(val)`

Adds a not equals comparison to the WHERE clause for an Integer value.

###### Signature
```apex
public ASB_WhereClause ne(Integer val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Integer | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.NumberOfEmployees).ne(10);
```

---

##### `ne(val)`

Adds a not equals comparison to the WHERE clause for a Decimal value.

###### Signature
```apex
public ASB_WhereClause ne(Decimal val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Decimal | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.AnnualRevenue).ne(100000.0);
```

---

##### `ne(val)`

Adds a not equals comparison to the WHERE clause for a Date value.

###### Signature
```apex
public ASB_WhereClause ne(Date val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Date | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.CreatedDate).ne(Date.today());
```

---

##### `ne(val)`

Adds a not equals comparison to the WHERE clause for a Datetime value.

###### Signature
```apex
public ASB_WhereClause ne(Datetime val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Datetime | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.CreatedDate).ne(Datetime.now());
```

---

##### `ne(val)`

Adds a not equals comparison to the WHERE clause for a Boolean value.

###### Signature
```apex
public ASB_WhereClause ne(Boolean val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Boolean | The value to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.IsActive__c).ne(false);
```

---

##### `isNotNull()`

Adds an IS NOT NULL comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause isNotNull()
```

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.Name).isNotNull();
```

---

##### `gt(val)`

Adds a greater than comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause gt(Integer val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Integer | The value to compare (Integer, Decimal, Date, or Datetime). |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.NumberOfEmployees).gt(10);
```

---

##### `gt(val)`

###### Signature
```apex
public ASB_WhereClause gt(Decimal val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Decimal |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `gt(val)`

###### Signature
```apex
public ASB_WhereClause gt(Date val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Date |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `gt(val)`

###### Signature
```apex
public ASB_WhereClause gt(Datetime val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Datetime |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `gte(val)`

Adds a greater than or equal to comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause gte(Integer val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Integer | The value to compare (Integer, Decimal, Date, or Datetime). |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.NumberOfEmployees).gte(10);
```

---

##### `gte(val)`

###### Signature
```apex
public ASB_WhereClause gte(Decimal val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Decimal |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `gte(val)`

###### Signature
```apex
public ASB_WhereClause gte(Date val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Date |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `gte(val)`

###### Signature
```apex
public ASB_WhereClause gte(Datetime val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Datetime |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `lt(val)`

Adds a less than comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause lt(Integer val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Integer | The value to compare (Integer, Decimal, Date, or Datetime). |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.NumberOfEmployees).lt(10);
```

---

##### `lt(val)`

###### Signature
```apex
public ASB_WhereClause lt(Decimal val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Decimal |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `lt(val)`

###### Signature
```apex
public ASB_WhereClause lt(Date val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Date |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `lt(val)`

###### Signature
```apex
public ASB_WhereClause lt(Datetime val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Datetime |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `lte(val)`

Adds a less than or equal to comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause lte(Integer val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Integer | The value to compare (Integer, Decimal, Date, or Datetime). |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.NumberOfEmployees).lte(10);
```

---

##### `lte(val)`

###### Signature
```apex
public ASB_WhereClause lte(Decimal val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Decimal |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `lte(val)`

###### Signature
```apex
public ASB_WhereClause lte(Date val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Date |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `lte(val)`

###### Signature
```apex
public ASB_WhereClause lte(Datetime val)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| val | Datetime |  |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

---

##### `isIn(vals)`

Adds an IN comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause isIn(List<Object> vals)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| vals | List&lt;Object&gt; | The list of values to compare. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.Name).isIn(new List<String>{'Acme', 'Beta'});
```

---

##### `isLike(pattern)`

Adds a LIKE comparison to the WHERE clause.

###### Signature
```apex
public ASB_WhereClause isLike(String pattern)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| pattern | String | The pattern to match. |

###### Return Type
**[ASB_WhereClause](ASB_WhereClause)**

ASB_WhereClause

###### Example
```apex
  new ASB().filter().field(Account.Name).isLike('A%');
```

### FieldExpression Class

Represents a Field Expression portion of a WHERE clause.

**Implements**

Expression

#### Methods
##### `queryString(ctx)`

###### Signature
```apex
public String queryString(ASB_BindContext ctx)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| ctx | ASB_BindContext |  |

###### Return Type
**String**

### OrLogicalGroup Class

#### Constructors
##### `OrLogicalGroup(expressions)`

###### Signature
```apex
public OrLogicalGroup(List<Expression> expressions)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| expressions | List&lt;Expression&gt; |  |

## Interfaces
### Expression Interface

#### Methods
##### `queryString(ctx)`

Returns query string and puts bindings in given bindings map

###### Signature
```apex
public String queryString(ASB_BindContext ctx)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| ctx | ASB_BindContext |  |

###### Return Type
**String**