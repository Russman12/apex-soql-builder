# Installation

To install this unlocked package with dependencies, download the `Install script` asset then run this command from your project:

```shell
node install "${PACKAGE_ID}"
```

To install this unlocked package without dependencies, run this command:

```shell
sf package install --package "${PACKAGE_ID}" --wait 10
```

Or, go to the package web install link:

- [Production](https://test.salesforce.com/packaging/installPackage.apexp?p0=${PACKAGE_ID})
- [Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=${PACKAGE_ID})
