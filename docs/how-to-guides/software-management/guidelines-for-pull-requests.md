# Guidelines for Pull Requests

*Intended to promote a style of Pull Request that benefits both the creator of the pull request and the reviewer.*

## PR Creators

### Before Writing Code

- Pull from upstream/main to ensure that your code is up to date
- Ensure that your pull request is directly related to an issue in the repository.  If a related issue does not exist, then [create one](./guidelines-for-reporting-issues.md)
- Gauge the complexity of the issue before beginning work.  While there is no "magic number" with respect to the number of lines a PR should contain, if it requires more than 250 changed lines of code, then it may be necessary to decompose the issue into a series of smaller issues.


### While Addressing the Issue

- Ensure that your commit messages are meaningful
    - Instead of "Fixed bug" or "Addressed PR Feedback," the message should contain information that describes the change.
- Follow the established coding style if one exists for the repository
- Ensure that your changes are accompanied by an entry in the changelog
- Write tests to cover any functionality that is added or changed

-----
[:octicons-arrow-right-24: See Also: __Deprecation__](../../how-to-guides/software-management/deprecation.md)

-----


### When Creating the Pull Request

After writing code or making relevant changes, create a pull request on the appropriate repository.

- Completely fill out the pull request template
- Reference the issue with a "fixes," "closes," "resolves," etc. keyword, e.g. "Fixes #489"
- Create comments to clarify any code changes or design decisions that may not be clear to the reviewer

### Quick PR Guidelines

Use the following checklist to ensure that your PR follows best practices that will allow for a quick and easy review

- [ ] The PR is responsible for a single change that is summarized in the changelog.
- [ ] The PR should not change more than 250 lines of code.  While this is not always possible, minimizing the size of the PR will ensure that a timely review can take place.
- [ ] The PR must be tested locally before being marked ready for review

## PR Reviewers

This section describes best practices for the reviewers of incoming PRs.

???+ abstract "Code Review Checklist"

    The purpose of this checklist is to prompt discussion between the reviewer and submitter. Any questions or concerns that come from this checklist should be discussed during the code review.

    - [ ] Does the code work? Does it perform its intended function, the logic is correct etc?
    - [ ] Do the changes make sense (in terms of the big picture/ticket/etc.)?
    - [ ] Did they complete their developer checklist? Double check their checklist?
    - [ ] Does the code include tests?
    - [ ] Does the code meet non-functional requirements (scalability, robustness, extensibility, modularity)?
    - [ ] Does the code introduce new dependencies?  If so, are they necessary?
    - [ ] Is this code in the right place? (are the correct classes/apps handling these things, are they at the right level, does the order make sense)
    - [ ] Is there unnecessary duplication in the code or duplication of any code in the repository?
    - [ ] Does all this code need to exist? (e.g. extraneous mutators etc.)
    - [ ] Are they adding [tech debt](https://www.agileweboperations.com/technical-debt)?
    - [ ] Is the code easily understandable (i.e. [squint test](https://robertheaton.com/2014/06/20/code-review-without-your-eyes/))?
    - [ ] Does the code handle potential exceptions, return values, invalid inputs...?
    - [ ] Is the code needlessly complex?
    - [ ] Is there low-hanging fruit that is easily refactorable?
    - [ ] Do new classes/functions have well-defined, documented responsibilities? Are these responsibilities too broad?
    - [ ] Are the API documentation and comments useful? Are comments explaining why?
    - [ ] Are all style choices and changes appropriate?