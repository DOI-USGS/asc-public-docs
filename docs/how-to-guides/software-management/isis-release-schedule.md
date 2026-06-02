# ISIS Release Schedule and Release Types

#### Key Differences

| Release Type | Supported | RC | Versioning | Updates   | MAJOR | MINOR | PATCH |
|--------------|-----------|----|------------|-----------|-------|-------|-------|
| LTS          | 18 months | N  | semver     | biweekly  | N     | N     | Y     |
| Production   | 12 months | N  | semver     | quarterly | N     | Y     | Y     |
| Dev          | 2 weeks   | N  | date-based | biweekly  | Y     | Y     | Y     |
| New Version  | 18 months | Y  | semver     | yearly    | Y     | Y     | Y     |

## Release Types

ISIS has four types of releases:

- **LTS** - Most Stable.  Gets *Bugfixes* but not new *Features* between major releases.
- **Production** - Gets new *Features* and *Bugfixes* but not *Breaking Updates*.
- **Dev** - First to get new *Features*, including *Breaking Updates*.
- **New Version**\* - Updates all other release types with *Breaking Updates*.

!!! note "Notes"

    **Production is the default version of ISIS.**  
    If you install the `main` version of ISIS, or do not specify a label, 
    you will get the production version.

    **Releases can be found** in the 
    [ISIS GitHub repo](https://github.com/DOI-USGS/ISIS3/releases) 
    and on our [conda channel](https://anaconda.org/usgs-astrogeology/isis).

    The **Dev** version ***does not get a release on GitHub***, 
    but can be found in the [dev branch](https://github.com/DOI-USGS/ISIS3/tree/dev) of the repo.  
    It **does** get a release on our conda channel every two weeks.  

    \* The **New Version** release is a special type of LTS release: The ***first LTS release*** of any major version of ISIS (i.e, 9.0.0 LTS, 10.0.0 LTS).

## Types of Updates

Outlined in [Semantic Versioning (external)](https://semver.org), we categorize updates into three types:

- **Major** (breaking) updates can break a workflow that functioned in a previous version.
- **Minor** (feature) updates add features but shouldn't break previously working workflows.
- **Patch** (bugfix) updates fix bugs, but don't add features or change functional workflows.


## Update Cadence and Type

- **Yearly**: ISIS **LTS** and **Production** releases get *Major* updates.
- **Quarterly**: The ISIS **Production** release gets *Minor* and *Patch* updates.
- **Biweekly**:
    - The **Dev** release may get *Major* updates.
    - The **LTS** release gets *Patch* updates only.

## Flow of Updates

#### Flow of MAJOR, MINOR, and PATCH updates from Dev to LTS and Production

- ***Patch*** updates are merged from Dev into **LTS** and **Production** versions of ISIS.
- ***Minor*** updates are merged into the **Production** version.
- ***Major*** updates remain only in **Dev** ISIS, until the yearly RC and LTS Release.

``` mermaid
%%{init: { 'logLevel': 'debug', 'theme': 'base', 'themeVariables': {'git0': '#d00', 'git1': '#096', 'git2': '#07e', 'tagLabelBorder': '#ea0', 'gitInv1': '#fc0'}, 'gitGraph': {'showBranches': true, 'showCommitLabel':true,'mainBranchName': 'Dev'}} }%%
gitGraph

    commit id:"2024.24"

    branch LTS
    checkout LTS
    commit id:"9.0.0 RC"
    commit id:"9.0.0 LTS" type: HIGHLIGHT tag: "New Ver."

    branch Prod
    checkout Prod
    commit id:"9.0.0 Prod"

    checkout LTS
    checkout Dev
    commit id:"2025.1 (PATCH)"

    checkout LTS
    merge Dev id:"9.0.1 LTS"

    checkout Prod
    merge Dev id:"9.0.1 Prod"

    checkout Dev
    commit id:"2025.2 (MINOR)"

    checkout Prod
    merge Dev id:"9.1.0 Prod"

    checkout Dev
    commit id:"2025.3 (MAJOR)"

    checkout LTS
    merge Dev id:"10.0.0 RC"
    commit id:"10.0.0 LTS" type: HIGHLIGHT tag: "New Ver."

    checkout Dev
    commit id:"2025.4"
```


## Release Candidates (New Versions of ISIS)

For the yearly New Version Release (i.e, from ***8***.x.x → ***9***.0.0), 
there is first a *Release Candidate* to test new features before they are included.
While the RC is out, we solicit feedback and testing from the community, 
and identify and fix issues before making an Major ISIS release.

This major release will flow to LTS and Prod channels.

### RC Feature Freeze

When a Release Candidate (RC) is branched from the `dev` branch, a feature freeze is put into effect. 
Any feature additions that occur after an RC has been branched will be included in a future RC (and release). 
A feature added before the creation of an RC will be included in the next major update, 
unless issues are found with the new feature. In that case, the feature will be removed and the RC recreated.

## Minor/Patch Releases

For subsequent releases within the same major version 
(i.e, 8.***2***.0 → 8.***3***.0, 9.0.***1*** → 9.0.***2***), 
there is no release candidate. 
Updates are accumulated on a release-feeder branch for LTS or Production, 
then released.