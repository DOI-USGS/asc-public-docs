# Public Software Release Process Step-By-Step Instructions
-------
#### Software Table of Contents

- [ISIS](#isis-public-release-process)
- [ALE](#ale-public-release-process)
- [Plio](#plio-public-release-process)
- [Knoten](#knoten-public-release-process)
- [USGSCSM](#usgscsm-public-release-process)
-------

## **ISIS Public Release Process**
-------
  
ISIS release process chjanges depending on the type of release: 

* **RC**: Release Cadidate, new feature releases (e.g. going from `8.0`->`8.1` or `8.5`->`9.0`) are released first as RCs.
* **LR**: Live Release, if no changes are suggested for the RC after a month, we do a LR from the RC.  
* **LTS**: Long Term Support, the previous major release is supported for a year in LTS. It only recieves bug fixes, no feature adds. 

### 1. **Check current test failures**

Check the [AWS CodeBuild test results](https://us-west-2.codebuild.aws.amazon.com/project/eyJlbmNyeXB0ZWREYXRhIjoiNDJNZ2MxbHFKTkwxV1RyQUxJekdJY3FIanNqU29rMHB4Nk1YUzk4REIrZUZDeEtEaW9HQlZ1dTZOSHpML2VUTGVDekYydmVFcU9sUHJKN20wQzd1Q0UzSzJscnB0MElDb1M3Ti9GTlJYR1RuMWJTV3V1SkJTa3NoYmc9PSIsIml2UGFyYW1ldGVyU3BlYyI6IjF3U2NTSGlDcEtCc29YVnEiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D) for whatever branch you plan to release. If false positives are suspected, at least two contributing devlopers need to agree before moving forward. 

!!! Success "Step 1 Complete"
    
    Move on to step 2 when you confirmed builds are passing or have accounted for the false positives. 

### 2. **Update the GitHub documents**

In this step, we will update the documents that are stored in the GitHub repository. There will either be one or two PRs as a result of this step depending on:

!!! warning "Update docs at the end" 
    The update docs PR into `dev` should be merged *after* the release is officially out and at the end of the public release process to ensure the new ISIS docs endpoint is live and working.



=== "RC" 

    - [ ] Update the Changelog. Label all the currently unreleased changes as part of this release. See comments on the  [CHANGELOG.md](https://raw.githubusercontent.com/DOI-USGS/ISIS3/dev/CHANGELOG.md) for instructions. 
    - [ ] Update `code.json` by adding a new entry with the RC version. e.g. an 8.0.0 release candidate would be labeled `8.0_RC1` for the first RC, `8.0_RC2` for the second, etc. 
    - [ ] **Update the Authors List**:  If there are any new contributors to the project since the last release, update the `AUTHORS.rst` file to include them.
    - [ ] Submit a Pull Request: Submit a pull request into the dev branch. If a release branch exists, create a PR there as well.

=== "LR"

    - [ ] Update the Changelog: Update the release date on the version to be released in the changelog. See comments on the  [CHANGELOG.md](https://raw.githubusercontent.com/DOI-USGS/ISIS3/dev/CHANGELOG.md) for instructions. 
    - [ ] Update `code.json` by adding a new entry with the new version number and the date last modified.   
    - [ ] **Update the Authors List**:  If there are any new contributors to the project since the last release, update the `AUTHORS.rst` file to include them.
    - [ ] Submit a Pull Request: Submit a pull request into the dev branch. If a release branch exists, create a PR there as well. 

=== "LTS"

    - [ ] Update the Changelog. Move **only the bug fixes** under this release. Follow the instructions in [CHANGELOG.md](https://raw.githubusercontent.com/DOI-USGS/ISIS3/dev/CHANGELOG.md) for how to do this.
    - [ ] Update `code.json` by adding a new entry with the LTS version. e.g. an 8.0.0 LTS would be released as 8.0 (no LTS in the version name).
    - [ ] **Update the Authors List**:  If there are any new contributors to the project since the last release, update the `AUTHORS.rst` file to include them.
    - [ ] Submit a Pull Request: Submit a pull request into the release branch. 


!!! Success "Step 2 Complete" 
    
    Move on to step 3 after your PR(s) are merged. 

### Step 3: Set Up Git repos

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
    - [ ] Update `recipe/meta.yml` to match the LC version. i.e. **without** the `_RC#`.
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

!!! Success 
    Move on to step 4 after you successfully create the new branch on the upstream repo. 


### Step 4: Create a release

!!! Warning "Do Not Make a Release for RCs"

    **Skip this step for Release Candidates (RCs).** Only pull a release if it's a full release (i.e. NOT an RC). RCs should instead be in their own branch until ready for full release.  

=== "LR" 

    - [ ] In the release tab on GitHub, draft a release and set the target branch to the branch created in Step 3.
    - [ ] On the same page, create a new tag for the release version.
    - [ ] Name the release "ISISX.Y.Z Public Release".

=== "LTS"

    - [ ] In the release tab on GitHub, draft a release and set the target branch to the branch created in Step 3.
    - [ ] On the same page, create a new tag for the release version.
    - [ ] Name the release "ISISX.Y.Z LTS". 

!!! Note "If releasing a custom build"

    Mission and non-standard builds (including release candidates) must be tagged as pre-release. 
 

!!! Success 

    When you create the release, move on to step 5. 


### Step 5: Create the Builds for Anaconda Cloud 

!!! Warning 
   
    Anaconda leverages caching in many places which can cause issues. If you are getting unexpected issues, try a different installation and/or a different machine. You can also try running `conda clean -a`


#### Part A: Operating System 

* Ensure the OS on the machine you are building the release on is the appropriate operating system (Mac OS 11.6+ or Ubuntu 18 LTS). 


#### Part B: Setup Anaconda 

* Run `conda clean --all` to clean out your package cache and ensure you pull fresh packages for the build. 

* Activate the base environment: ```conda activate```. 

* Ensure that you have anaconda-client, conda-build, and conda-verify installed in your base environment 

  * You can check by running ```anaconda login```, ```conda build -h```, and ```conda-verify --help```, respectively. 

    * If any of these packages are not in your base environment, they can be installed using the following  

commands: 

`conda install anaconda-client` 

`conda install -c anaconda conda-build`  

`conda install -c anaconda conda-verify` 

    * If running ```anaconda login``` resulted in an error message similar to ```[ERROR] API server not found. Please check your API url configuration``` run the following command and try again: ```anaconda config --set ssl_verify False```  


#### Part C: Run the Build 

* Go to the root of the repository you set up in [Step 3 Part A](#part-a-setup-repository). Make sure it is up to date. 

    * Switch to the appropriate version branch 

```git checkout <version branch>``` 

    * Ensure you are at the head of the release branch ```git pull upstream <version branch>``` 

* Run the bash script in the root of the directory: ``` buildCondaRelease.sh```. This script will remove a CMake parameter that is used for jenkins and create a conda build running the conda build command:```conda build recipe/ -c conda-forge -c usgs-astrogeology --override-channels``` 

  * The -c options are to give conda a channel priority. Without these, conda will always attempt to download from the default Anaconda channel first. (Unlike the environment.yml files, channel priority cannot be defined within the meta.yaml.)

  

### Step 5: Test the Conda Build 


After the conda build completes, it should be tested by uploading it to your personal anaconda cloud account and conda installing it locally.  

* Use the command ```anaconda upload -u <conda-cloud-username> <path-to-the-.tar.bz2-file>``` to upload the conda build to your personal anaconda channel. 

* Follow the standard [installation instructions](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md#isis-installation-with-conda) to install this package locally for testing, but at the installation step, instead of running `conda install -c usgs-astrogeology isis`, run `conda install -c <conda-cloud-username> -c usgs-astrogeology isis`  

    ???+ Note "Troubleshooting conda install"
        If you are having trouble installing ISIS from your personal account, try specifying the version, e.g., `conda install -c <conda-cloud-username> -c usgs-astrogeology isis=8.1.0_RC1`
        
* Run an ISIS application, like `spiceinit -h` and insure that it runs without error. This is testing whether the conda environment set up during the install is complete enough to run ISIS.   


### Step 6: Upload the Build to Anaconda Cloud 


In this step, we will upload the build(s) that we just created into the Anaconda Cloud to distribute them to our users. Uploading the .tar.bz2 file requires one command, however, non-standard builds (release candidates or custom builds), must be uploaded with a label.  

* If you missed the location of the .tar.bz2 file at the bottom of the build, use ```conda build recipe/ --output``` to reprint. This command does not confirm the file exists - only where it *would* be saved with a successful build. 

* For a standard release, use the command ```anaconda upload -u usgs-astrogeology <path-to-the-.tar.bz2-file>``` 

* For an Release Candidate, use the command ```anaconda upload -u usgs-astrogeology -l RC <path-to-the-.tar.bz2-file>``` 

* For a custom build, specify a custom label and use the command ```anaconda upload -u usgs-astrogeology -l <custom-label> <path-to-the-.tar.bz2-file>``` 

   * For example, when generating a custom build for the CaSSIS team, we would use the "cassis" label and the command ```anaconda upload -u usgs-astrogeology -l cassis <path-to-the-.tar.bz2-file>``` 

If the upload fails or displays a prompt for a username and password, try adding an API token for usgs-astrogeology to your environment by running `export ANACONDA_API_TOKEN=<token>`. Ask another developer for the API token. This approach is recommended over adding `-t <token>` to your anaconda upload command, because of a known bug where `-t` is either interpreted as a package type or a token depending on its position in the `anaconda upload` command.  


### Step 7: Back up the Build  

Back up the build by copying the .tar.bz2 to: 

  * /work/projects/conda-bld/osx-64/ for Mac OS 11.6.  

  * /work/projects/conda-bld/linux-64/ for Ubuntu 18 LTS. 


### Step 8: Update Data and TestData Areas on rsync Servers 


This step covers how to update the data on the public s3 buckets. This is where our external users will have access to the data necessary for running ISIS. There are two locations, one is the S3 bucket where users directly download data from. The other is and EFS drive that only accessible internally and is mounted for daily use. See the [internal only documentation](https://code.chs.usgs.gov/asc/ASC_Software_Docs/-/blob/main/ISIS/Maintaining%20ISIS%20Data.md) for more info on how these are setup. Action is only required if there are smithed kernels that need to be uploaded to /usgs_data/. 

**Please pay careful attention to where you are rclone'ing the data to on the S3 buckets.

### Step 9: Create Internal Builds/Installs for Astro 


This step covers creating the builds and the installation environments of ISIS for our internal users here on the ASC campus using the shared anaconda installs. Setting up the conda environments involve installing the conda build of ISIS that we just pushed up to Anaconda, and will follow the instructions found in the README.MD of the isis3 repository. These commands must be run as isis3mgr for permission purposes. 


#### Part A: Shared Anaconda Installs 

* You will need to install the new version of ISIS into the two shared Anaconda installs on the ASC campus. 

    * For Linux: `/usgs/cpkgs/anaconda3_linux` 

    * For MacOS: `/usgs/cpkgs/anaconda3_macOS` 


#### Part B: Installing ISIS 

* Follow the standard [installation instructions](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md#isis-installation-with-conda) to install the latest version of ISIS into a new environment. 

    * For a standard release, the environment should be named `isisX.Y.Z`. 

    * For a release candidate, the environment should be named `isisX.Y.Z-RC#`. 

    * For a custom build, the environment should be named `isisX.Y.Z-<custom-label>`. 

    * For the step which sets up the data and testData areas, make sure to use the new isis_data and isis_testData directories, i.e.: `python $CONDA_PREFIX/scripts/isisVarInit.py --data-dir=/usgs/cpkgs/isis3/isis_data  --test-dir=/usgs/cpkgs/isis3/isis_testData` 

* Confirm that the environment has been set-up properly by deactivating it, reactivating it, and running an application of your choice. 


### Step 10: Update Documentation 


**This step is only done for standard feature releases.** 

This step will update the ISIS documentation on our [website](https://isis.astrogeology.usgs.gov/UserDocs/) for our users worldwide.


#### Part A: Build the documentation 

* Add the new version to Documentation Versions in the [menu.xsl](https://github.com/DOI-USGS/ISIS3/blob/dev/isis/src/docsys/build/menu.xsl#L105).

* Perform a local build (not a conda build) using the instructions for [developing ISIS with cmake](../../how-to-guides/isis-developer-guides/developing-isis3-with-cmake.md).

* setisis to the build directory from [Step 3 Part A](#part-a-setup-repository). 

* Run the ```ninja docs``` command from this build directory to build the documentation for this version of the code. 


#### Part B: Upload the documentation

This step requires that you have an rclone config for the `asc-docs` bucket. You can get credentials from vault.

In the `$ISISROOT` directory run the following commands, but replace <your-config> with your config for `asc-docs` and <version-number> with the version of ISIS you are releasing. For example if you config is called `s3-docs` and you are releasing 8.1.0, the first command would be `rclone sync --dry-run docs/8.1.0 s3-docs://asc-docs/isis-site/8.1.0/`

* Optionally add the `--dry-run` flag to test prior to actually uploading, `rclone sync docs/<version-number> <your-config>://asc-docs/isis-site/<version-number>/`


### Step 11: Communicate Availability of Build 


This step will will communicate that a new version of ISIS is available. 


#### Step 5: Create a DOI for the release

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


#### Part A: External Announcement 

* Create a new topic under the [ISIS Release Notes](https://astrodiscuss.usgs.gov/c/ISIS/isis-release-notes) category on [astrodiscuss](https://astrodiscuss.usgs.gov/). 

* Fill in the following template for the release notes post: 

``` 

## How to install or update to <X.Y.Z> 


Installation instructions of ISIS can be found in the README on our [github page ](https://github.com/DOI-USGS/ISIS3). 


If you already have a version of ISIS 4.0.0 or later installed in an anaconda environment, you can update to <X.Y.Z> by activating your existing isis conda environment and running `conda update isis` . 


### How to get access to <X.Y.Z> at the ASC 


The new process proposed in the internal [RFC](https://astrodiscuss.usgs.gov/t/internal-rfc-distribution-of-isis3-at-asc/52/26) is now in full effect. Please review the process of using anaconda environments to activate isis [here](https://astrodiscuss.usgs.gov/t/using-the-asc-conda-environment-for-isisx-y-z/106). 


Once a version of conda is active, run the command: `conda activate isis<X.Y.Z>` to use this newest version of ISIS. 


## Changes for <X.Y.Z> 

<!---
Copy this release's section of the Changelog here
-->


## Notes 


The following operating systems are supported for this release: 


* Ubuntu 18.04 
* macOS Mohave 11.6

(Other Linux/macOS variants may be able to run this release, but are not officially supported.) 


If you find a problem with this release, please create an issue on our [GitHub issues page](https://github.com/DOI-USGS/ISIS3/issues/new/choose/) 

``` 

* For a Release Candidate, add the following under "Notes":  


``` 

There are some important considerations to keep in mind when using this release candidate: 


* Do not use this version for production work. A stable isisX.XX.XX release will be uploaded after a month. 
* The ISIS online documentation will not be updated until the stable release is announced. 

``` 


#### Part B: Internal Announcement 


* Send an email to all of astro (GS-G-AZflg Astro <gs-g-azflg_astro@usgs.gov>) informing them of internal availability. 

    * Your e-mail can simply be a link to the external announcement.

### Step 12: Publish Record to DOI
Referring to [Part F](#part-f-create-a-doi-for-the-release), make sure to check that the code.usgs.gov link for the release is live and publish the record on DOI.

### Step 13: Update the Release Schedule

Update the [release schedule](https://github.com/DOI-USGS/ISIS3/wiki/Release-Schedule) with the date of the release and update any future releases with the appropriate dates. Releases should be nominally 3 months apart.


## Problems 

### _Could not find conda environment_
If you test the conda environment you created for the ISIS build, i.e., isis3.7.1, on prog24 as isis3mgr and get the following warning: 

``` 

Could not find conda environment: <isis version> 

You can list all discoverable environments with `conda info --envs`. 

``` 

Run the following command: 

``` 

source /usgs/cpkgs/anaconda3_macOS/etc/profile.d/conda.sh 

``` 

This problem occurs because we are building ISIS with the shared anaconda on cpkgs instead of /jessetest/miniconda3 (which is the version of anaconda being sourced in .bashrc). You may also do a conda activate with a full path to the environment instead of running the above source command. 

### mpi issue
If you run into an `mpi`/`mpich` error like below when running `buildCondaRelease.sh`,

```
ValueError: Incompatible component merge:
    - '*mpich*'
    - 'mpi_mpich_*'
```

try removing the cache in the respective `conda-bld/` dir:

```sh
rm -rf ~/mambaforge3/conda-bld/osx-64/.cache
```

------
## **ALE Public Release Process**
------
Step-by-step instructions for the release process of [ALE](https://github.com/DOI-USGS/ale).

### Step 1. Update the Changelog 

Update the Changelog to label all the currently unreleased changes as part of the new release. 

### Step 2. Add new entry to code.json 

Update `code.json` by adding a new entry with the new version number and the date last modified.

### Step 3. Update setup.py Version 

Update version number in `setup.py`.

### Step 4. Update CMakeLists.txt

Update the VERSION variable in `CMakeLists.txt` to the new version number.

### Step 5. Update recipe/meta.yaml

Update the version variable in `recipe/meta.yaml` to the new version number.

### Step 6. Submit a Pull Request

Submit a pull request with the changes from steps 1-5.

### Step 7. Create a Github Release 

Once your pull request as been approved and merged, draft a new github release. Tag the release with the new version. Name the release with the version number and include the changelog information in the description. 

------
## **Plio Public Release Process**
------
Step-by-step instructions for the release process of [Plio](https://github.com/DOI-USGS/plio).

### Step 1. Update the Changelog 

Update the Changelog to label all the currently unreleased changes as part of the new release. 

### Step 2. Add new entry to code.json 

Update `code.json` by adding a new entry with the new version number and the date last modified.

### Step 3. Update setup.py Version 

Update the VERSION variable in `setup.py` to the new version number.

### Step 4. Submit a Pull Request

Submit a pull request with the changes from steps 1-3.

### Step 5. Create a Github Release 

Once your pull request as been approved and merged, draft a new github release. Tag the release with the new version. Name the release with the version number and include the changelog information in the description. 

------
## **Knoten Public Release Process**
------
Step-by-step instructions for the release process of [Knoten](https://github.com/DOI-USGS/knoten).

### Step 1. Update the Changelog 

Update the Changelog to label all the currently unreleased changes as part of the new release. 

### Step 2. Add new entry to code.json 

Update `code.json` by adding a new entry with the new version number and the date last modified.

### Step 3. Update setup.py Version 

Update the VERSION variable in `setup.py` to the new version number.

### Step 4. Submit a Pull Request

Submit a pull request with the changes from steps 1-3.

### Step 5. Make Github Release 

Once your pull request as been approved and merged, draft a new github release. Tag the release with the new version. Name the release with the version number and include the changelog information in the description. 

------
## **USGSCSM Public Release Process**
------
Step-by-step instructions for the release process of [USGSCSM](https://github.com/DOI-USGS/usgscsm).

### Step 1. Update the Changelog 

Update the Changelog to label all the currently unreleased changes as part of the new release.

### Step 2. Add new entry to code.json 

Update `code.json` by adding a new entry with the new version number and the date last modified.

### Step 3. Update CMakeLists.txt

Update the VERSION variable in `CMakeLists.txt` to the new version number.

### Step 4. Submit a Pull Request

Submit a pull request with the changes from steps 1-3.

### Step 5. Make Github Release 

Once your pull request as been approved and merged, draft a new github release. Tag the release with the new version. Name the release with the version number and include the changelog information in the description. 