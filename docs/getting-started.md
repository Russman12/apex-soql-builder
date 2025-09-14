

# Getting Started

## Installation

Go the the [latest release](/Russman12/apex-soql-builder/releases/latest) and follow the instructions to install the package.

## Basic usage

The following apex demonstrates a simple example of how to use this package:

```apex
ASB asb = new ASB();

List<Account> accs = (List<Account>) asb.make(Account.getSObjectType())
  .selection(asb.selection().field(Account.Id).field(Account.Name).field(Account.NumberOfEmployees))
  .filter(asb.whereField(Account.NumberOfEmployees).equals().literal('10'))
  .query();
```