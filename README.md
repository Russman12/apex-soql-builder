# Apex-SOQL-Builder

A simpler way to dynamically generate SOQL in apex.

![ASB Brand Image](/docs/public/brand-s.png)

- [Apex-SOQL-Builder](#apex-soql-builder)
  - [Usage](#usage)
  - [example usage](#example-usage)
    - [Select](#select)
    - [Filters](#filters)
    - [Order By](#order-by)
    - [Limit](#limit)

## Usage

Visit the [documentation](https://russman12.github.io/apex-soql-builder/) page to see how to use this package.

## example usage

ASB is the primary entrypoint for this functionality. It's a factory used to create the Builder as well as most other supporting classes. While you can construct classes manually, it's recommended to instead contruct via the factory as the syntax is much easier and your code will be more testable.

If you need to debug the query, replace the `query()` method call with `soqlString()`. This returns the string literal for the query to execute. While helpful for troubleshooting, avoid using it in production code.

```java
ASB asb = new ASB();

String queryStr = asb.make(Account.getSObjectType())
  .selection(asb.selection().field(Account.Id).field(Account.Name).field(Account.NumberOfEmployees))
  .filter(asb.whereField(Account.NumberOfEmployees).equals().literal('10'))
  .soqlString();

System.debug(queryStr);
```

### Select

To construct a SELECT clause, use `asb.selection()`. This method creates a new `ASB_SelectClause` builder instance. From there, you can chain fields together and add them to one or more `ASB_QueryBuilder` instances.

```java
ASB asb = new ASB();

ASB_Select selection = asb.selection().field(Account.Id);

ASB_QueryBuilder builder1 = asb.make(Account.getSObjectType()).selection(selection);
ASB_QueryBuilder builder2 = asb.make(Account.getSObjectType()).selection(selection);
```

A builder can include parent fields, and relationships (subqueries).

```java
ASB asb = new ASB();

ASB_Select selection = asb.selection()
  .parent(Account.CreatedById, User.LastName)
  .subQuery(asb.subQuery().selection(asb.subSelection().field(Contact.AccountId).field(Contact.Name)));

System.debug(selection.clauseString()); //SELECT CreatedBy.LastName, (SELECT Id, Name FROM Contacts)
```

### Filters

To construct a WHERE clause, use `asb.whereField()` and add to the builder instance with `filter()`.

```java
ASB_Where filter = asb.filter().field(Account.NumberOfEmployees).gt(10);

ASB_QueryBuilder soql = asb.make(Account.getSObjectType()).filter(filter);
```

ASB_Where uses a composite pattern to allow for complex WHERE clauses. This example filters Accounts that have a phone number or address and have less than 30 employees.

```java
ASB asb = new ASB();

ASB_Where hasBillingAddress = asb.whereField(Account.BillingAddress).ne('null');
ASB_Where hasShippingAddress = asb.whereField(Account.ShippingAddress).ne('null');
ASB_Where hasPhone = asb.whereField(Account.Phone).ne('null');
ASB_Where moreThan30Employees = asb.whereField(Account.NumberOfEmployees).lt('30');

ASB_Where isReachable = asb.filter().andGroup(new List<ASB_Where>{ hasBillingAddress, hasShippingAddress, hasPhone });
ASB_Where callableContacts = asb.filter().andGroup(isReachable, moreThan30Employees);

System.debug(callableContacts.clauseString()); //WHERE (BillingAddress != null OR ShippingAddress != null OR Phone != null) AND NumberOfEmployees > 30
```

### Order By

The query builder can also have the ORDER BY clause added.

```java
ASB asb = new ASB();

ASB_QueryBuilder builder = asb.make(Account.getSObjectType())
  .orderBy(asb.orderByField(Account.NumberOfEmployees).ascending().nullsFirst());

System.debug(builder.soqlString());
```

### Limit

The query builder can have the LIMIT clause added as well.

```java
ASB asb = new ASB();

ASB_QueryBuilder builder = asb.make(Account.getSObjectType()).recordLimit(10);

System.debug(builder.soqlString());
```
