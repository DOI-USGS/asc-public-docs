# Contributing to ISIS - Overview

## Build ISIS
Begin by referring to our [Developing ISIS3 with CMake](./developing-isis3-with-cmake.md) page for instructions on setting up a local clone of ISIS and configuring an Anaconda environment for building. Once you've followed the steps outlined there, you'll have a local build of ISIS ready for development.

## Pick an Issue
Navigate to the [issues page](https://github.com/DOI-USGS/ISIS3/issues) on GitHub, where you'll find a variety of bugs and feature requests. To identify suitable tasks for beginners, filter the issues using the "good first issue" label. You can access these labeled issues directly [here](https://github.com/DOI-USGS/ISIS3/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22). Once you've chosen an issue, click on its title to view details, and assign yourself to it by selecting "assign yourself" under the "Assignees" section on the right side of the issue description.

## Document Your Changes
Once you have completed the ticket, ensure to update the project documentation accordingly. This includes adding an entry to the CHANGELOG.md file. If your contribution introduces new classes, adhere to our [formatting documentation page](./class-requirements-for-using-doxygen-tags.md) for consistent documentation formatting.

## Test Your Changes
Before finalizing your work, thoroughly test the code. Address any failing tests resulting from your modifications or add new tests to cover your changes. Refer to our [running tests page](./developing-isis3-with-cmake.md#running-tests) for instructions on running associated tests. Additionally, learn how to write tests using Gtest and Ctest from our [writing test page](./writing-isis-tests-with-ctest-and-gtest.md).

## Create a Pull Request
To submit your changes, commit them to your local branch using the command:
`git commit -m “<message>”` where <message> is your commit message. Then, push up your changes to your fork 
`git push origin <branch_name>` where `<branch_name>` is the name of your local branch you made your changes on. Finally, head over to your fork, click on the “Branch” dropdown, select the branch `<branch_name>` from the dropdown, and click “New Pull Request”. Give your PR a descriptive but brief title and fill out the description skeleton. After submitting your PR, wait for someone to review it, and make any necessary changes.
