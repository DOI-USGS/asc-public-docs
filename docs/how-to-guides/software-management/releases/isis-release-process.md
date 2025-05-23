# ISIS Public Release Process

!!! info "For releasing other Astro software, see the [general release process :octicons-arrow-right-16:](general-release-process.md)"
  
The ISIS release process changes depending on the type of release: 

- **RC** (Release Candidate)
    - new feature releases are released first as RCs  
      (e.g. going from `8.0`->`8.1` or `8.5`->`9.0`)
* **LR** (Live Release)
    - If no changes are suggested for the RC after a month,  
      **do a LR from the RC**.  
* **LTS** (Long Term Support)
    - The previous major release is supported for a year in LTS.
    - It only receives bug fixes, no feature adds. 

### 1. **Check current test failures**

Check the [AWS CodeBuild test results](https://us-west-2.codebuild.aws.amazon.com/project/eyJlbmNyeXB0ZWREYXRhIjoiNDJNZ2MxbHFKTkwxV1RyQUxJekdJY3FIanNqU29rMHB4Nk1YUzk4REIrZUZDeEtEaW9HQlZ1dTZOSHpML2VUTGVDekYydmVFcU9sUHJKN20wQzd1Q0UzSzJscnB0MElDb1M3Ti9GTlJYR1RuMWJTV3V1SkJTa3NoYmc9PSIsIml2UGFyYW1ldGVyU3BlYyI6IjF3U2NTSGlDcEtCc29YVnEiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D) for whatever branch you plan to release. If false positives are suspected, at least two contributing developers need to agree before moving forward. 

!!! Success ""
    
    Move on to step 2 after **confirming that builds are passing** (or **accounting for false positives**).

### 2. **Update Version in AWS S3** (for [ISIS Application Docs](https://isis.astrogeology.usgs.gov))

!!! info "LR/LTS only, not for RCs."

- [ ] Add the new version to `versions.json` in AWS S3  
    `arn:aws:s3:::asc-public-docs/isis-site/versions.json`

!!! Success "" 
    
    Move on to step 3 after **updating versions.json**. 

### 3. **Update the GitHub documents**

=== "RC" 

    - [ ] Update the Changelog. Label all the currently unreleased changes as part of this release. See comments on the  [CHANGELOG.md](https://raw.githubusercontent.com/DOI-USGS/ISIS3/dev/CHANGELOG.md) for instructions. 
    - [ ] Update `code.json` by adding a new entry with the RC version. e.g. an 8.0.0 release candidate would be labeled `8.0_RC1` for the first RC, `8.0_RC2` for the second, etc. 
    - [ ] **Update the Authors List**:  If there are any new contributors to the project since the last release, update the `AUTHORS.rst` file to include them.
    - [ ] Submit a Pull Request: Submit a pull request into the dev branch. If a release branch exists, create another PR there as well.

=== "LR"

    - [ ] Update the Changelog: Update the release date on the version to be released in the changelog. See comments on the  [CHANGELOG.md](https://raw.githubusercontent.com/DOI-USGS/ISIS3/dev/CHANGELOG.md) for instructions. 
    - [ ] Update `code.json` by adding a new entry with the new version number and the date last modified.   
    - [ ] **Update the Authors List**:  If there are any new contributors to the project since the last release, update the `AUTHORS.rst` file to include them.
    - [ ] Submit a Pull Request: Submit a pull request into the dev branch. If a release branch exists, create another PR there as well. 

=== "LTS"

    - [ ] Update the Changelog. Move **only the bug fixes** under this release. Follow the instructions in [CHANGELOG.md](https://raw.githubusercontent.com/DOI-USGS/ISIS3/dev/CHANGELOG.md) for how to do this.
    - [ ] Update `code.json` by adding a new entry with the LTS version. e.g. an 8.0.0 LTS would be released as 8.0 (no LTS in the version name).
    - [ ] **Update the Authors List**:  If there are any new contributors to the project since the last release, update the `AUTHORS.rst` file to include them.
    - [ ] Submit a Pull Request: Submit a pull request into the release branch. 


!!! Success "" 
    
    Move on to step 4 after **merging PR(s)**. 

### 4. **Create/setup git branch**

Clone the repo locally with git clone. 

=== "RC" 

    - [ ] Create a branch from dev with `x.x.x_RCy` where `x.x.x` is the version and y (e.g. `8.1.2_RC1` or `5.4.1_RC3`). 
        * Example: `git checkout -b 8.1.2_RC1 upstream/dev`.
    - [ ] Update VERSION variable in CMakeLists.txt, do not add `_RC` here.
    - [ ] Update RELEASE_STAGE variable in CMakeLists.txt to `beta``
    - [ ] Update `recipe/meta.yaml` to match the name of the RC branch. i.e. **with** the `_RC#`.
    - [ ] Update the `build` section by copying the current contents of `environment.yaml` into the `build` section. 
    - [ ] Update the `run` section to include any new packages and remove any packages that are no longer needed. 
    - [ ] Push the new branch into upstream

=== "LR" 

    - [ ] Create a branch from the RC branch.
        * Example: `git checkout -b 8.1.2 upstream/8.1.2_RC1`.
    - [ ] Check VERSION variable in CMakeLists.txt matches release version.
    - [ ] Update RELEASE_STAGE variable in CMakeLists.txt to `stable`.
    - [ ] Update `recipe/meta.yml` to match the LR version. i.e. **without** the `_RC#`.
    - [ ] Update the `run` section to include any new packages and remove any packages that are no longer needed. Rare for LRs, often no changes are needed. 
    - [ ] Push the new branch into upstream 

=== "LTS"

    - [ ] Create a branch from the previous LTS.
        * Example: `git checkout -b 8.1.3 upstream/8.1.2`.
    - [ ] Update VERSION variable in CMakeLists.txt.
    - [ ] Check RELEASE_STAGE variable in CMakeLists.txt is set to `stable`.
    - [ ] Update the `run` section to include any new packages and remove any packages that are no longer needed. Rare for LRs, often no changes are needed.
    - [ ] Push the new branch into upstream  

!!! Danger "Ensure to update the version and build_number is set to 0 in recipe/meta.yml"

    The build number should be incremented for each build produced at the **same version** of source code and should always begin at 0 for each release version. **Uploading the a new build using the same build number AND version number will overwrite the previous release**.

??? Note "meta.yml vs environment.yml versions"
     Make sure you look closely at the changes in terms of syntax. Our `environment.yaml`s seem to have a looser restriction than what is expected in the `meta.yaml`. Check out conda's [package match specifications](https://docs.conda.io/projects/conda-build/en/latest/resources/package-spec.html#package-match-specifications) for more info.        

!!! Success ""
    Move on to step 5 after **creating the new branch on the upstream repo**. 


### 5. **Create a release**

!!! Warning "No Release for RCs"

    **Skip this step for Release Candidates (RCs).** Only pull a release if it's a full release (i.e. LR/LTS, NOT an RC). RCs should instead be in their own branch until ready for full release.  

=== "LR" 

    - [ ] In the release tab on GitHub, draft a release and set the target branch to the branch created in Step 4.
    - [ ] On the same page, create a new tag for the release version.
    - [ ] Name the release "ISISX.Y.Z Public Release".

=== "LTS"

    - [ ] In the release tab on GitHub, draft a release and set the target branch to the branch created in Step 4.
    - [ ] On the same page, create a new tag for the release version.
    - [ ] Name the release "ISISX.Y.Z LTS". 

!!! note ""

    Tag **custom** builds as **pre-release**, including ***mission-specific*** and ***non-standard*** builds.
 
!!! success ""

    Move on to step 6 after **creating the release**. 

### 6. **Publish Record to DOI**

!!! info "LR/LTS only, not for RCs."

- [ ] Check that the code.usgs.gov link for the release is live and create a DOI record.

??? abstract "Creating a DOI"

    * A DOI is only needed for standard releases.  Release candidates do not need a DOI.

    * Go to the [USGS Asset Identifier Service (AIS)](https://www1.usgs.gov/identifiers/) and click `Manage DOIs` to Login.
        
        * You will need the assistance of USGS staff for this.

        * The AIS has known compatibility issues with Firefox, if you have trouble logging in, switch browsers.
        
    * Click `Create DOI` and Reserve a DOI.

        * **Title**: `Integrated Software for Imagers and Spectrometers (ISIS) X.Y.Z`

        * **Data Source**: `Astrogeology Science Center`

        * ISIS `Does Not` use the *ScienceBase Data Release Process*.

        * Clicking `Reserve My DOI` returns the DOI that's on hold.
        
            * Record this number in the GitHub release, and in the ISIS Readme at the top as a badge and in the Citing ISIS section.

    * Add More Information

        * Under "Manage Record"

            * Add other USGS Staff members who can manage the DOI.

        * Under "Required Information"

            * **Creator(s) / Author(s)**: Add the ISIS Team Lead

            * **Landing Page URL**: https://code.usgs.gov/astrogeology/isis/-/tags/[X.Y.Z]

            * **Resource Type**: Software

            * **IPDS Number**: IP-141314 for ISIS 8.x.x releases.  Major Versions will need a new number/release approval from [IPDS](https://ipds.usgs.gov).

            * This product **is not** associated with a primary USGS-authored publication.

        * Under "Recommended Information"

            * Fill info if available.
        
        * Saving and Publishing

            * Once the Landing Page URL on code.usgs.gov is live, publish the record to DataCite.

            * You can save the record without publishing it if the release landing page is not ready. 

!!! quote "Markdown format for DOI Number"

        DOI [`12.3456/XXXXXXXX`](https://doi.org/12.3456/XXXXXXXX)

- [ ] Post the DOI number/link to...  
    - [ ] [GitHub Release Post for this ISIS Version](https://github.com/DOI-USGS/ISIS3/releases)
    - [ ] [ISIS Readme](https://github.com/DOI-USGS/ISIS3/blob/dev/README.md)
        - [ ] Badge at the top of the readme
        - [ ] [Citing ISIS](https://github.com/DOI-USGS/ISIS3/blob/dev/README.md#citing-isis) section:
            - DOI, Version Number, Release Date, Readme Updated Date

!!! success ""
    Move on to step 7 after **getting a DOI number** and posting it to the release and readme.
    
    Include the DOI number in the announcement in step 7 below!

### 7. **Announce the Build** 

- [ ] Create a new [ISIS3 GitHub Discussion](https://github.com/DOI-USGS/ISIS3/discussions/categories/announcements)
    in the announcements category.

    - [ ] Fill in the Release Notes Template for the post: 

??? quote "Release Notes Template"

    ``` 

    ISIS X.Y.Z has been released.

    DOI [`12.3456/XXXXXXXX`](https://doi.org/12.3456/XXXXXXXX)


    ## How to install or update to <X.Y.Z> 

    A guide to [installing ISIS](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda/) can be found in the Astro Software Docs.

    If you already have a version of ISIS 4.0.0 or later installed in an anaconda environment, you can update to <X.Y.Z> by activating your existing isis conda environment and running `conda update isis`. 


    ### How to get access to <X.Y.Z> at the ASC 

    Internal builds available via Hovenweep.

    Once a version of conda is active, run the command: `conda activate isis<X.Y.Z>` to use this newest version of ISIS. 


    ## Changes for <X.Y.Z> 

    <!---
    Copy this release's section of the Changelog here
    -->


    ## Notes 

    Latest Operating System Support for this Release: 

    * Ubuntu 24.04 
    * macOS 13

    (Other Linux/macOS variants and versions may be able to run this release, but are not officially supported.) 

    If you find a problem with this release, please create an issue on our [GitHub issues page](https://github.com/DOI-USGS/ISIS3/issues/new/choose/) 

    ``` 

??? note "Additional Notes for Release Candidates"

    Add the following under "Notes":   

    ``` 
    There are some important considerations to keep in mind when using this release candidate: 

    * Do not use this version for production work. A stable isisX.XX.XX release will be uploaded after a month. 
    * The ISIS online documentation will not be updated until the stable release is announced. 
    ```

-----

!!! success "ISIS Release Complete"