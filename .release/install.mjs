/**
 * This script installs a given packge will all dependencies
 */
import childProcess from 'child_process';

//input package version
const pkg = process.argv[2];

//query org for dependencies
const deps = JSON.parse(
  childProcess
    .execSync(
      `sf data query -t -q "SELECT Dependencies FROM SubscriberPackageVersion WHERE Id='${pkg}'" --json`
    )
    .toString()
).result.records[0].Dependencies?.ids;

if (deps !== undefined) {
  //add dep ids to list
  let depIds = [];
  deps.forEach((dep) => {
    depIds.push(dep.subscriberPackageVersionId);
  });

  //ensure only unique values
  depIds = depIds.filter((value, index, array) => {
    return array.indexOf(value) === index;
  });

  //install each dependency individually
  depIds.forEach((id) => {
    return childProcess.execSync(`sf package install --package ${id} -w 30 --publish-wait 10`, {
      stdio: 'inherit'
    });
  });
}

childProcess.execSync(`sf package install --package ${pkg} -w 30 --publish-wait 10`, {
  stdio: 'inherit'
});
