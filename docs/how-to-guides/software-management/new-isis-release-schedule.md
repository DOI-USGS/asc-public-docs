# ISIS Release Schedule

## Release Types

ISIS has three types of releases:

- **LTS** - Most Stable.  Gets *Bugfixes* but not new *Features* between releases.
- **Production** - Gets new *Features* and *Bugfixes* but not *Breaking Updates*.
- **Dev** - First to get new *Features*, including *Breaking Updates*.


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

-----

#### Flow of MAJOR, MINOR, and PATCH updates from Dev to LTS and Production

``` mermaid
%%{init: { 'logLevel': 'debug', 'theme': 'base', 'gitGraph': {'showBranches': true, 'showCommitLabel':true,'mainBranchName': 'Dev'}} }%%
gitGraph

    commit id:"2024.24"

    branch LTS
    checkout LTS
    commit id:"9.0.0 RC"
    commit id:"9.0.0 LTS"

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
    commit id:"10.0.0 LTS"

    checkout Dev
    commit id:"2025.4"
```

#### Key Differences

| Version    | Supported | RC | Versioning | Updates   | MAJOR | MINOR | PATCH |
|------------|-----------|----|------------|-----------|-------|-------|-------|
| LTS        | 18 months | Y  | semver     | biweekly  | N     | N     | Y     |
| Production | 12 months | N  | semver     | quarterly | N     | Y     | Y     |
| Dev        | 2 weeks   | N  | date-based | biweekly  | Y     | Y     | Y     |


## Release Candidates

For the yearly LTS release, there is first a *Release Candidate* to test new features before they are included.
While the RC is out, we solicit feedback and testing from the community, and identify and fix issues before making an ISIS LTS release.

### RC Feature Freeze

When a Release Candidate (RC) is branched from the `dev` branch, a feature freeze is put into effect. 
Any feature additions that occur after an RC has been branched will be included in a future RC (and release). 
A feature added before the creation of an RC will be included in the next major update,  
unless issues are found with the new feature. In that case, the feature will be removed and the RC recreated.


!!! danger "TODO: Tags... Production vs. Latest Release"

    [Concerning these tags...](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda/#downloading-isis)

    What does "Latest Release" mean?  Should we change "latest" in docs/commands to something else?

    - same as "Production"?
    - does it include dev?
    - should there be a separate production tag?

## Release Schedule Calendar

*port from previous docs, or remove?*