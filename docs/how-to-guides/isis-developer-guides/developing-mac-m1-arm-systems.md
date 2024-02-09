# ISIS Development on the Mac M1 ARM System

*Borrowed largely from Kris Becker's original GitHub post [here.](https://github.com/DOI-USGS/ISIS3/issues/5188)*

There are at least two ways to develop ISIS on the M1. The current ISIS configuration can be built on the M1 in the Rosetta Translation Environment using the x86_i386 Intel-based instruction set. Building ISIS natively using the x86_64 ARM instruction set is not yet possible. The instructions to set up both environments is provided here, but the x86_i386 is recommended until all the required dependencies are available in the ARM environment.


???+ note

    This guide is based on a M1 Mac system running Apple macOS Monterey. Here is some additional information regarding the system used to install, configure and build ISIS on the M1:

    ```
    Hardware Overview
      Model Name:	MacBook Pro
      Model Identifier:	MacBookPro18,2
      Chip:	Apple M1 Max
      Total Number of Cores:	10 (8 performance and 2 efficiency)
      Memory:	32 GB
    Graphics/Display
      Type:	GPU
      Bus:	Built-In
      Total Number of Cores:	24
    System Software Overview:
      System Version:	macOS 12.6.3 (21G419)
      Kernel Version:	Darwin 21.6.0
    ```
    The methods and processes described below pertains to the Monterey OS. Apparently, it is different in the Ventura OS since it no longer allows duplication of the Terminal app, but there are [alternative ways](https://stackoverflow.com/questions/74198234/duplication-of-terminal-in-macos-ventura) to make it possible in Ventura. Also, it is unknown if this will work with the Mac M2 ARM chip.

    To determine which environment you are running in, run the following command in `Terminal`:

    ```
    # Rosetta Intel
    % uname -m
    x86_64
    % uname -p
    i386

    # Native ARM
    % uname -m
    arm64
    % uname -p
    arm
    ```

## Mac M1 Rosetta x86_i386 Intel Configuration Steps
Apple provides the [Rosetta Translation Environment](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment) to run applications that contain the Intel-based x86_64 instruction set. Using this environment, the current ISIS configuration can be used to compile and run the resulting ISIS build on the Apple M1 platform.

Before building ISIS, it is essential to install the conda environment on the Mac M1. Refer to the [Anaconda and ISIS dependencies](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/developing-isis3-with-cmake/#anaconda-and-isis3-dependencies) for guidance on downloading Anaconda. Alternatively, find instructions for downloading Miniconda [here](https://docs.conda.io/projects/miniconda/en/latest/). 

While there are various ways to set up the Rosetta development environment, creating a copy of the Terminal app in /Applications folder and configuring it to run in the Rosetta environment automatically is considered the most straightforward method. The instructions in this [blog](https://www.courier.com/blog/tips-and-tricks-to-setup-your-apple-m1-for-development/) are followed to set up a Rosetta Terminal before installing Miniconda and building ISIS. 

There is an option to install just the Intel version of Miniconda, or a more [complex procedure](https://towardsdatascience.com/how-to-install-miniconda-x86-64-apple-m1-side-by-side-on-mac-book-m1-a476936bfaf0) can be used to install both the ARM and Rosetta Intel versions side-by-side, with potential consequences. 

For simplicity, the instructions below describe only the Rosetta Intel x86_i386 environment configuration install, as the native ARM-based ISIS development environment is not expected to be available for a while (refer to the [Native ARM configuration](#mac-m1-native-x86_arm64-arm-configuration-steps) section below for details). 

Prior to attempting these steps, duplication of the Terminal app (or application of a suitable alternative) is necessary. **NOTE:** It's important to note that a significant complication to the duplication approach is that every time there is an update to a new version of Monterey, the `Terminal Rosetta` app is removed, requiring recreation after each update.

1. Run the `Terminal Rosetta` app.
    * `uname -m` should report `x86_64`
2. Install the Bash version of [Mac Intel Miniconda](https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh)
    * `bash Miniconda3-latest-MacOSX-x86_64.sh`
3. Configure conda according to the ISIS installation instructions. This is mainly to setup the proper channels and establish priority.
    * `conda config --env --add channels conda-forge`
    * `conda config --env --add channels usgs-astrogeology`
4. Create a directory and install ISIS from GitHub
    * `mkdir -p IsisMacIntel`
    * `cd IsisMacIntel`
    * `git clone --recurse-submodules https://github.com/DOI-USGS/ISIS3.git`
5. Build ISIS using the instructions as documented [here.](https://astrogeology.usgs.gov/docs/how-to-guides/isis-developer-guides/developing-isis3-with-cmake/)
    * `ninja install`

The build times are quite impressive - 11 minutes - using the Rosetta Translation Environment. Behavior is similar to other Mac platforms since ISIS installs/uses the Anaconda [cpp-compiler](https://anaconda.org/conda-forge/cxx-compiler).

## Mac M1 Native x86_arm64 ARM Configuration Steps

Building the ARM version of ISIS is easier than the Intel version because there are no additional special setup requirements as there are for Rosetta. However, support for ARM is relatively new in Miniconda, [released](https://www.anaconda.com/blog/new-release-anaconda-distribution-now-supporting-m1) on May 5, 2022. If the Rosetta Intel installation above was followed, the environment must be removed unless an appropriate alternative procedure was used. To remove a Miniconda installation, follow the [recommended instructions](https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html#uninstalling-anaconda-or-miniconda). Then, open a native Terminal and prepare to [install](https://conda.io/projects/conda/en/stable/user-guide/install/macos.html#install-macos) the ARM version of Miniconda. 

1. Ensure you are running the native Terminal app.
    * `uname -m` should report `arm64`
2. Install the Bash version of Mac Native ARM Miniconda
    * `bash Miniconda3-latest-MacOSX-arm64.sh`
3. Configure conda properly
    * `conda config --env --add channels conda-forge`
    * `conda config --env --add channels usgs-astrogeology`
4. Create a directory and install ISIS from GitHub
    * `mkdir -p IsisMacARM`
    * `cd IsisMacARM`
    * `git clone --recurse-submodules https://github.com/DOI-USGS/ISIS3.git`
5. Configure ISIS
    * `conda env create -n IsisArmDev -f environment.yml`

Here are the results of the first attempt to install the ISIS development dependencies on the Mac M1 ARM platform:

```
Collecting package metadata (repodata.json): done
Solving environment: failed

ResolvePackageNotFound:
  - usgs-astrogeology::bullet
  - inja
  - qt[version='>=5.9.6,<5.15.0']
  - usgs-astrogeology::kakadu==1
  - tnt
  - xalan-c
  - jama
  - nn
  - ale=0.8.6
  - embree[version='>=2.17,<3']
  - csm[version='>=3.0.3,<3.0.4']
  - boost=1.72
  - armadillo
  - ninja==1.7.2
```
ISIS make configuration fails due to missing dependencies. ISIS cannot be built natively on the Mac M1 because 14 conda package dependencies are missing. Some are pinned to a specific version that is not available for the M1; [Qt](https://anaconda.org/anaconda/qt) was initially not supported per the [release notes](https://www.anaconda.com/blog/new-release-anaconda-distribution-now-supporting-m1). However, support was officially added in the October 18, 2022 [release](https://docs.anaconda.com/free/anaconda/release-notes/) but only for 5.15.2 and higher. Other ISIS dependency packages have no native Mac M1 version available and may never have one as support for some of them may have been completely dropped. And, there are some dependency packages the USGS maintains that currently do not have a Mac M1 version. It is unclear how/when/if any of these packages may be available for the Mac M1.

**Note:** Qt applications will not display until you `export QT_MAC_WANTS_LAYER=1` in the terminal as was reported in [#4773](https://github.com/DOI-USGS/ISIS3/issues/4773).

## Summary/Comments
It is possible to use the Apple Mac M1 ARM platform to develop ISIS applications. However, it currently must be done using the Rosetta Translation environment.

The process to set up Rosetta on the M1 is complex and different under Monterey and Ventura. Apple's Rosetta support seems to continue to evolve and will likely be sunsetted at some point. It is unknown at this time if this process can be used with the M2 chip.

Amazon also provides [EC2 Mac instances](https://aws.amazon.com/ec2/instance-types/mac/), which include M1 systems with Monterey installed. This may help those who have access to such resources.

