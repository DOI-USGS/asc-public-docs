# Contributing Guide

The goal of this document is to create a contribution process that:

* Encourages new contributions.
* Encourages contributors to remain involved.
* Avoids unnecessary processes and bureaucracy whenever possible.
* Creates a transparent decision making process which makes it clear how
contributors can be involved in decision making.


## Vocabulary

* A **Contributor** is any individual creating or commenting on an issue or pull request.
* A **Committer** is a subset of contributors who have been given write access to the repository.


# Logging Issues

Log an issue for any question or problem you might have. When in doubt, log an issue,
any additional policies about what to include will be provided in the responses. The only
exception is security disclosures which should be sent privately.

Committers may direct you to another repository, ask for additional clarifications, and
add appropriate metadata before the issue is addressed.


## Reporting bugs

Before submitting a bug report, please follow the checklist to help us address the bug efficiently:

- Make sure you are using the latest version.
- Check other open or closed issues within the project repository to see if other users have experienced the same bug. 
- Regarding the bug:

    - Detail the steps in reproducing the bug.
    - Attach your input and output, if feasible.
    - Attach the stack trace.
    - Make note of your OS, Platform and Version.
    - Make note of your environment configs (compiler, package manager, conda env dependencies)
    - Verify that the bug is reproducible.

## Requesting Documentation

When requesting new documentation, the author of the issue should specify both the topic and category of the desired documentation.  The documentation category must be "Getting Started," "How-To," "Concept," or "Manual," and the specific requirements for posting the issue will be determined by the documentation category.  Each of the documentation categories has an associated issue template that will guide the requester through the following category-specific requirements:
    - Getting Started: a lesson or list of lessons to be learned (e.g. how does map projection with CSM work in ISIS) and an associated task by which those lessons will be conveyed (e.g. create a map-projected image using CSM).
    - How-To: a definition of the basic problem that needs to be solved (e.g. how to append to the CSM search directories)
    - Concept: a pending title and the scope of the proposed documentation
    - Manual: a description of the software, its relationship to the Astrogeology Science Center, and who will maintain the software manual as the library matures.  Additionally, the requester should describe how the software is currently maintained as well as providing information related to the location to which updates are regularly pushed.  Finally, the requester should include a link to existing documentation for the library.

# Contributions

Any change to resources in this repository must be through pull requests. This applies to all changes
to documentation, code, binary files, etc.

:exclamation: No pull request can be merged without being reviewed.

You may request a specific contributor who is most versed in the issue at hand to review your pull request. Once all the feedback is addressed, any automated tests pass, and the pull request is approved, then the PR may be merged in. 

In the case of an objection being raised in a pull request by another committer, all involved
committers should seek to arrive at a consensus by way of addressing concerns being expressed
by discussion, compromise on the proposed change, or withdrawal of the proposed change.

## First-time contributor

When making a contribution for the first time, please add your name to the `.zenodo.json` file. We strongly recommend adding your affiliation and ORCiD to the `zenodo.json` file. These additions only have to happen once.

## Category-Specific Documentation Guidelines

When addressing a request for documentation, the committer should post an initial draft pull request and solicit discussion with contributors. The specific category of documentation requested in the issue determines the structue of the draft pull request in accordance with the following guidelines:

- Getting Started: The draft pull request should include a list of steps to be completed.  This may take the form of a header-only markdown file, jupyter notebook, or content-appropriate file type.
- How-To: Because how-to guides are often short, and their structure is largely content-specific, the structure of the draft pull request is largely at the discretion of the committer.  While there are limited guidelines as to what the draft should contain, the committer should make a best-effort to publish an outline of the proposed documentation.
- Concept: The draft pull request should follow the same guidelines as a "getting started" page with the added stipulation that the author should include citations for any fact-based claims.
- Manual: Since software manuals are presented as links to external documentation, there is no need for a draft pull request.
