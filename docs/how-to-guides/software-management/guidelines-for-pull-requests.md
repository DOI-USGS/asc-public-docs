# Guidelines for Pull Requests

This page provides guidelines for creating a successful pull request.  These guidelines are intended to promote a style of pull request that benefits both the creator of the pull request and the reviewer.

## Before Writing Code

- Pull from upstream/main to ensure that your code is up to date
- Ensure that your pull request is directly related to an issue in the repository.  If a related issue does not exist, then [create one](./guidelines-for-reporting-issues.md)
- Gauge the complexity of the issue before beginning work.  While there is no "magic number" with respect to the number of lines a PR should contain, if it requires more than 250 changed lines of code, then it may be necessary to decompose the issue into a series of smaller issues.


## While Addressing the Issue

- Ensure that your commit messages are meaningful
    - Instead of "Fixed bug" or "Addressed PR Feedback," the message should contain information that describes the change.
- Follow the established coding style if one exists for the repository
- Ensure that your changes are accompanied by an entry in the changelog
- Write tests to cover any functionality that is added or changed


## When Creating the Pull Request

After writing code or making relevant changes, create a pull request on the appropriate repository.

- Completely fill out the pull request template
- Reference the issue with a "fixes," "closes," "resolves," etc. keyword, e.g. "Fixes #489"
- Create comments to clarify any code changes or design decisions that may not be clear to the reviewer

## Quick PR Guidelines

Use the following checklist to ensure that your PR follows best practices that will allow for a quick and easy review

- [ ] The PR is responsible for a single change that is summarized in the changelog.
- [ ] The PR should not change more than 250 lines of code.  While this is not always possible, minimizing the size of the PR will ensure that a timely review can take place.
- [ ] The PR must be tested locally before being marked ready for review