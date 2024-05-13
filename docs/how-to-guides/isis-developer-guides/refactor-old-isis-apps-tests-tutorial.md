# Tutorial to Refactor Old ISIS Apps and Tests

## 1. Set Up Your Local ISIS Environment

Follow these tutorials to set up your local ISIS environment before you get started:

1. [Getting Started With GitHub](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/developing-isis3-with-cmake/#getting-started-with-github)
2. [Anaconda and ISIS3 Dependencies](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/developing-isis3-with-cmake/#anaconda-and-isis3-dependencies)
3. [Building ISIS3](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/developing-isis3-with-cmake/#building-isis3)

## 2. Converting Apps and Tests

Once you have ISIS built, check out the apps in `ISIS3/isis/src/base/apps`. Apps that need to be refactored only have *app-name.xml* and *main.cpp*, other than the *Makefile* and other possible folders (like `assets` and `tsts`). Take a look at the [bandtrim](https://github.com/DOI-USGS/ISIS3/tree/dev/isis/src/base/apps/bandtrim) app for example. In comparison, apps that have been updated to fit the gtest suite will have *app-name.xml*, *app-name.cpp*, *app-name.h*, and *main.cpp*, like the [campt](https://github.com/DOI-USGS/ISIS3/tree/dev/isis/src/base/apps/campt) app.

After finding a suitable app to refactor, follow the steps in [Refactoring ISIS3 Applications](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/writing-isis-tests-with-ctest-and-gtest/#refactoring-isis3-applications) in your selected app.

To write a new test suite with gtest, follow the steps in [Creating a new test suite](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/writing-isis-tests-with-ctest-and-gtest/#creating-a-new-test-suite). 

A great way to get a grasp on the converting process is by looking at previous examples so here are some PRs:

- [`gaussstretch` PR #5259](https://github.com/DOI-USGS/ISIS3/pull/5259)
- [`skypt` PR #5444](https://github.com/DOI-USGS/ISIS3/pull/5444)
  
## 3. Run Tests

Check out [Running Tests](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/developing-isis3-with-cmake/#running-tests) to get an idea on how to run your tests.

As an example, let's look at the [`skypt` test suite](https://github.com/DOI-USGS/ISIS3/blob/dev/isis/tests/FunctionalTestsSkypt.cpp). You can run the all of `skypt`'s tests with `ctest -R skypt`. Let's say you want to test only the first test case in *FunctionalTestsSkypt.cpp*, run `ctest -R FunctionalTestSkyptDefault`. 

## 4. Update CHANGELOG

Make sure you update the *CHANGELOG.md* located in the root of the `ISIS3` folder by adding an entry under the **Unreleased** heading and **Changed** subheading.

## 5. Create PR

Once your tests are in good shape with passing marks, let's create a Pull Request (PR). Go to your forked ISIS3 repo page and select the **Pull requests** tab towards the top of the page. Then, hit the green **New pull request** button which will take you to a page where you select your base and head repositories to compare before creating the pull request. The base repository is the repo you will be pushing your changes *to*, so it should be set to 
```
base repository: **DOI-USGS/ISIS3**, base: **dev**
```

The head repository is where the changes will be coming *from*, a.k.a. where you have been pushing your local changes to:
```
head repository: **<your-account-name>/ISIS3**, compare: **<branch-name>**
```

Check the changes on the comparison page then hit the green **Create pull request** button. You will have the opportunity to make more changes to your branch after creating the PR so no worries if you are unable to catch something in this stage. 

Now, you should be on a page titled **Open a pull request**, the step to add further details regarding your PR. Under **Add a title**, title your PR as *APP-NAME app and tests refactor* (e.g., *gaussstretch app and tests refactor*).

In the body of the PR, there should already be a PR template ready for you to fill out, you can check out the preview of what the PR would look like when created when you select the **Preview** tab. Here's a general outline in what the PR should look like:

```md
**Description**
Describe what app, tests, and any appropriate files have been affected. 
You can also note any weird quirks or changes to the main code that seemed necessary to give the reviewer more context.

**Related Issue**
Usually, you would add here *Addresses <issue-url>*. 
If there is no existing GitHub issue to link, you can leave this blank.

**How Has This Been Validated?**
Write down related ctest commands so that the reviewer can test the PR.

**Types of changes**
Checkmark the *New feature* item.

**Checklist**
Go through the checklist and mark them as you go.
Some of them may not be necessary in this case so keep that in mind.

**Licensing**
Accept the terms by checking the box once you have read through this portion.
```

Complete the pull request process by clicking the green **Create pull request** button under the body of the PR. This will open a PR that is viewable by everyone.

Finally, ping the standup chat or the dev chat to let people know that your PR is ready for review!
