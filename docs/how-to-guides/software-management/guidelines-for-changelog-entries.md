# Guidelines for Changelog Entries
This document provides guidelines for CHANGELOG.md files and entries.  Changelog files can be found in all ASC software repositories, and they should follow the same style.

## Creating an Initial Changelog File
If the repository in which you are working does not contain a changelog file, then it should be created.  Within the ASC, we have elected to use markdown for our changelog files, so the file should be CHANGELOG.md.

!!! Tip "Markdown Syntax"
    Users unfamiliar with markdown can review the syntax [here](https://www.markdownguide.org/basic-syntax/)

A newly created changelog file will not have any changes logged, but it should still the same structure as other changelog files within the ASC's software ecosystem.  The following boilerplate text can be copied, pasted, and edited to fit the new project.

``` Markdown
# Changelog

All changes that impact users of this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!---
This document is intended for users of the applications and API. Changes to things
like tests should not be noted in this document.

When updating this file for a PR, add an entry for your change under Unreleased
and one of the following headings:
 - Added - for new features.
 - Changed - for changes in existing functionality.
 - Deprecated - for soon-to-be removed features.
 - Removed - for now removed features.
 - Fixed - for any bug fixes.
 - Security - in case of vulnerabilities.

If the heading does not yet exist under Unreleased, then add it as a 3rd heading,
with three #.


When preparing for a public release candidate add a new 2nd heading, with two #, under
Unreleased with the version number and the release date, in year-month-day
format. Then, add a link for the new version at the bottom of this document and
update the Unreleased link so that it compares against the latest release tag.


When preparing for a bug fix release create a new 2nd heading above the Fixed
heading to indicate that only the bug fixes and security fixes are in the bug fix
release.
-->

## [Unreleased]

### Changed

### Added

### Deprecated

### Removed

### Fixed

### Security
```


## Logging Changes
Changes to an existing changelog should occur within the 'Unreleased' heading, and they should be categorized according to their change type.  Descriptions of each change type can be found within the boilerplate text above.  Each changelog entry should contain a brief (one line) description of the change as well as a link to the issue that it resolves.  If no issue exists for the change, then one should be created.  For guidance on creating an issue, visit the [issue creation guidelines](./guidelines-for-reporting-issues.md).  An example of a changelog entry is as follows:
 

``` Markdown
...
## [Unreleased]

### Changed

### Added
 - Added sinusoidal projection to the list of available projections. [#42](https://github.com/USGS-Astrogeology/awesome-repo/issues/42)
### Deprecated

### Removed

...

```



## Updating the Changelog for a Release
When releasing a package containing a changelog, the "Unreleased" tag should be replaced with the version and date of the release, and a new "Unreleased" tag should be placed above.  In this way, all previously unreleased changes are captured under the new version tag.  Following the "1.0" release of our fake "awesome-repo" in the example above, the changelog would look like:

``` Markdown
...
## [Unreleased]
### Changed
### Added
### Deprecated
### Removed
### Fixed
### Security

## [1.0.0] - 12/31/1999
### Changed
### Added
 - Added sinusoidal projection to the list of available projections. [#42](https://github.com/USGS-Astrogeology/awesome-repo/issues/42)
### Deprecated
### Removed
### Fixed
### Security
...

```