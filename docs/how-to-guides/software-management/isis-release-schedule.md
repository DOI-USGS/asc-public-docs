# ISIS Release Schedule
This document describes the cadence and schedule for ISIS releases.

## Release Cadence
Releases and development of ISIS3 follows a time based schedule with a new release occurring every three months. Below, we illustrate a sample four month snapshot of software development.

<figure markdown>
  ![Release Cadence](../../../assets/release-schedule/release_schedule.png)
  <figcaption>Example of ISIS Release Cadence</figcaption>
</figure>



At the start of Month 1, a Release Candidate (RC1) is created from the `dev` branch of our GitHub repository. This RC contains all development from the previous (not shown) three months. RC1 is made publicly available as both a labelled branch and via our Anaconda.org (conda) [download page](https://anaconda.org/usgs-astrogeology/isis). During Month 1, we solicit input and testing from the broader community. Any issues identified in RC1 will be fixed during Month 1. At the conclusion of Month 1, the release is packaged and the next ISIS3 release is made available for the general public using Anaconda.org (and the default `main` label).

During Month 1 through Month 3, we continue with new feature development for RC2. At the start of Month 4, we repeat the same release candidate and release process as described above.

## Feature Freeze
When a Release Candidate is branched from the `dev` branch, a feature freeze is put into effect. Any feature additions that occur after a release candidate has been branched will be included in a future RC (and release). In other words, features added prior to the creation of a RC will be included in the next release. The only instances where this may not hold true is if significant, previously unidentified issues are identified during the testing of a RC that are associated with a new feature addition. In that case, we would back out the feature and recreate the RC.

## Release
As described above, we will release on a three month cadence. Releases will be labelled via GitHub for those users that wish to build from source. Additionally, releases will be uploaded to our Anaconda.org [repository](https://anaconda.org/usgs-astrogeology/isis) for `conda` installation.

## Release Schedule
| Version # / Label | Type | Date | 
|-------------------|------|------------|
| 4.3.0 | Release | 10.26.20 |
| 4.4.0 | Release | 2.8.21 |
| 5.0.0_RC | Release Candidate | 4.1.21 |
| 5.0.0 | Release | 4.27.21 |
| 6.0.0_RC | Release Candidate | 8.1.21 | 
| 6.0.0 | Release | 7.25.21 |
| 7.0.0_RC1 | Release Candidate | 3.4.22 |
| 7.0.0_RC2 | Release Candidate | 4.15.22 |
| 7.0.0 | Release | 5.2.22 |
| 7.1.0_RC | Release Candidate | 8.1.22 |
| 7.1.0 | Release | 9.20.22 |
| 7.2.0_RC | Release Candidate | 11.7.22 |
| 7.2.0 | Release | 03.21.23 |
| 8.0.0 | LTS Release | 8.2.23 |
| 8.1.0 | Release | 11.2.23 |
| 8.2.0 | Release | 04.27.24 |
| 9.0.0 | LTS Release | 8.2.24 |
| 8.0.* | LTS End of Life | 2.2.25 |