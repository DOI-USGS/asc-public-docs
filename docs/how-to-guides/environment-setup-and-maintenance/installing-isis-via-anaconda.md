# Installation

This installation guide is for ISIS users interested in installing ISIS (3.6.0)+ through conda.

## ISIS Installation With Conda

1. Download either the Anaconda or Miniconda installation script for your OS platform. Anaconda is a much larger distribution of packages supporting scientific python, while Miniconda is a minimal installation and not as large: [Anaconda installer](https://www.anaconda.com/download), [Miniconda installer](https://conda.io/miniconda.html)
1. If you are running on some variant of Linux, open a terminal window in the directory where you downloaded the script, and run the following commands. In this example, we chose to do a full install of Anaconda, and our OS is Linux-based. Your file name may be different depending on your environment.
    
    ```bash
    chmod +x Anaconda3-5.3.0-Linux-x86_64.sh
    ./Anaconda3-5.3.0-Linux-x86_64.sh
    ```
    This will start the Anaconda installer which will guide you through the installation process.

1. If you are running Mac OS X, a pkg file (which looks similar to Anaconda3-5.3.0-MacOSX-x86\_64.pkg) will be downloaded. Double-click on the file to start the installation process.
1. After the installation has finished, open up a bash prompt in your terminal window.
1. If you have an ARM64 Mac (M1/M2) running Catalina (or later), additional prerequisites must be installed for ISIS to run in emulation:
 - Install [XQuartz](https://www.xquartz.org/). (Tested with XQuartz 2.8.5 on MacOS Catalina)
 - Install Rosetta2. From the terminal run: `/usr/sbin/softwareupdate --install-rosetta --agree-to-license`
 - Include the `# MacOS ARM64 Only` lines below
1. Next setup your Anaconda environment for ISIS. In the bash prompt, run the following commands:

    ```bash
    
    #MacOS ARM64 Only - Setup the new environment as an x86_64 environment
    export CONDA_SUBDIR=osx-64
    
    #Create a new conda environment to install ISIS in
    conda create -n isis python>=3.9

    #Activate the environment
    conda activate isis
    
    #MacOS ARM64 Only - Force installation of x86_64 packages instead of ARM64
    conda config --env --set subdir osx-64

    #Add the following channels to the environment
    conda config --env --add channels conda-forge
    conda config --env --add channels usgs-astrogeology

    #Verify you have the correct channels:
    conda config --show channels

    #You should see:

    channels:
        - usgs-astrogeology
        - conda-forge
        - defaults

    #The order is important.  If conda-forge is before usgs-astrogeology, you will need to run:

    conda config --env --add channels usgs-astrogeology
    
    #Then set channel_priority to flexible in case there is a global channel_priority=strict setting
    conda config --env --set channel_priority flexible
    ```

1. The environment is now ready to download ISIS and its dependencies:

    ```bash
    conda install -c usgs-astrogeology isis
    ```

1. Finally, setup the environment variables:

    ISIS requires several environment variables to be set in order to run correctly.
    The variables include: ISISROOT and ISISDATA.

    The following steps are only valid for versions of ISIS after 4.2.0.
    For older versions of ISIS follow the instructions in [this readme file.](https://github.com/USGS-Astrogeology/ISIS3/blob/adf52de0a04b087411d53f3fe1c9218b06dff92e/README.md)

    There are two methods to configure the environment variables for ISIS:

    A. Using `conda env config vars` *preferred*

       Conda has a built in method for configuring environment variables that are specific to a conda environment since version 4.8.
       This version number applies only to the conda package, not to the version of miniconda or anaconda that was installed.

       To determine if your version of conda is recent enough run:

           conda --version

       If the version number is less than 4.8, update conda to a newer version by running:

           conda update -n base conda

       The version number should now be greater than 4.8.

       To use the built in environment variable configuration feature, first activate the environment by first running:

           conda activate isis

       After activation, the environment variables can be set using the syntax: `conda config vars set KEY=VALUE`.
       To set all the environment variables ISIS requires, run the following command, updating the path to `ISISDATA` as needed:

           conda env config vars set ISISROOT=$CONDA_PREFIX ISISDATA=[path to data directory]

       To make these changes take effect, re-activate the isis environment by running:

           conda activate isis

       The environment variables are now set and ISIS is ready for use every time the isis environment is activated.

    !!! Warning "The above method will not enable tab completion for arguments in C-Shell."
-----

    B. Using the provided isisVarInit.py script:

       To use the default values for: `$ISISROOT` and `$ISISDATA`, run the ISIS variable initialization script with default arguments:

           python $CONDA_PREFIX/scripts/isisVarInit.py

       Executing this script with no arguments will result in $ISISROOT=$CONDA\_PREFIX and $ISISDATA=$CONDA\_PREFIX/data. The user can specify different directories for `$ISISDATA` using the optional value:

           python $CONDA_PREFIX/scripts/isisVarInit.py --data-dir=[path to data directory]

       Now every time the isis environment is activated, $ISISROOT and $ISISDATA will be set to the values passed to isisVarInit.py.
       This does not happen retroactively, so re-activate the isis environment with one of the following commands:

           for Anaconda 3.4 and up - conda activate isis
           prior to Anaconda 3.4 - source activate isis

