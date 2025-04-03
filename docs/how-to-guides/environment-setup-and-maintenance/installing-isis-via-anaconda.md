# Installing ISIS

## Prerequisites

??? "Conda"

    If you don't have conda yet, download and install it.  We recommend getting conda through [MiniForge](https://github.com/conda-forge/miniforge?tab=readme-ov-file#miniforge).

    ```sh
    # Via Miniforge:
    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3-$(uname)-$(uname -m).sh
    ```

??? "x86 emulation on ARM Macs - Rosetta"

    If you have an ARM mac and want to run the x86 version of ISIS, you will need Rosetta.

    ```sh
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    ```
    

## Conda Environment

=== "Native Mac/Unix"

    ```sh
    # Create conda environment, then activate it.
    conda create -n isis 
    conda activate isis
    ```

=== "x86 on ARM Macs"

    ```sh
    # ARM Macs Only - Setup the new environment as x86_64
    export CONDA_SUBDIR=osx-64
    
    #Create a new conda environment to install ISIS in
    conda create -n isis python>=3.9

    #Activate the environment
    conda activate isis
    
    # ARM Macs Only - Force installation of x86_64 packages, not ARM64
    conda config --env --set subdir osx-64
    ```

### Channels

```sh

# Add conda-forge and usgs-astrogeology channels
conda config --env --add channels conda-forge
conda config --env --add channels usgs-astrogeology

# Check channel order
conda config --show channels
```

??? warning "Channel Order: `usgs-astrogeology` must be higher than `conda-forge`"
    
    Show the channel order with:

    ```sh
    conda config --show channels
    ```

    You should see:

    ```
    channels:
        - usgs-astrogeology
        - conda-forge
        - defaults
    ```

    If `conda-forge` is before `usgs-astrogeology`, add usgs-astrogeology again to bring up.  Set channel priority to flexible instead of strict.

    ```sh
    conda config --env --add channels usgs-astrogeology
    conda config --env --set channel_priority flexible
    ```

## Downloading ISIS

The environment is now ready to download ISIS and its dependencies:

=== "Latest Release"

    ```sh
    conda install -c usgs-astrogeology isis
    ```

=== "LTS"

    ```sh
    conda install -c usgs-astrogeology/label/LTS isis
    ```

=== "Release Candidate"

    ```sh
    conda install -c usgs-astrogeology/label/RC isis
    ```


=== "Dev"

    ```sh
    conda install -c usgs-astrogeology/label/dev isis
    ```


## Environmental Variables

ISIS requires these environment variables to be set in order to run correctly:

- `ISISROOT` - Directory path containing your ISIS install
- `ISISDATA` - Directory path containing the [ISIS Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md)

We also recommend setting:

- `PATH` - Where your computer looks for runnable apps, including ISIS apps.

???+ example "Setting Environmental Variables"

    The **Conda Env** method is recommended, and the **Python Script** automates that method:

    === "Conda Env"

        ??? "Requires Conda 4.8 or above"

            Check your conda version, and update if needed:

            ```sh
            # Check version
            conda --version

            # Update
            conda update -n base conda
            ```

        1.  Activate your ISIS environment.  
            ```
            conda activate isis

            # Now you can set variables with:
            # conda config vars set KEY=VALUE
            ```

        1.  This command sets both required variables and the PATH (fill in your `ISISDATA` location):

                conda env config vars set ISISROOT=$CONDA_PREFIX ISISDATA=[your data path] PATH=$PATH:$CONDA_PREFIX/bin

        1.  Re-activate your isis environment. 
            ```sh
            conda deactivate
            conda activate isis
            ```

        The environment variables are now set and ISIS is ready for use every time the isis conda environment is activated.


    === "Python Script"

        You should have your conda environment active before running this script:
        
            conda activate isis
        
        By default, running this script will set `ISISROOT=$CONDA_PREFIX` and `ISISDATA=$CONDA_PREFIX/data`:

            python $CONDA_PREFIX/scripts/isisVarInit.py
        
        You can specify a different path for `$ISISDATA` using the optional value:

            python $CONDA_PREFIX/scripts/isisVarInit.py --data-dir=[path to data directory]

        Optionally, set the path variable:

            conda env config vars set PATH=$PATH:$CONDA_PREFIX/bin

        Now every time the isis environment is activated, `$ISISROOT` and `$ISISDATA` will be set to the values passed to isisVarInit.py.
        This does not happen retroactively, so re-activate the isis environment:

            conda deactivate
            conda activate isis


    === "export (shell)"

        `export` sets a variable in your current shell environment until you close it.  Adding `export` commands to your `.bashrc` or `.zshrc` can make them persistent.

        ```sh
        export ISISROOT=[path to ISIS]
        export ISISDATA=[path to data]
        export PATH=$PATH:[path to ISIS]/bin
        ```


    === "ISIS <4.2.0"

        Use the python script per instructions from [the old readme](https://github.com/USGS-Astrogeology/ISIS3/blob/adf52de0a04b087411d53f3fe1c9218b06dff92e/README.md).


## The ISIS Data Area

Many ISIS apps need extra data to carry out their functions.  This data varies depending on the mission, and may be quite large, so it is not included with ISIS; You will need to [download it separately](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md).

-----

!!! success "Installation Complete"
    
    If you followed the above steps and didn't encounter any errors, you have completed your installation of ISIS.

-----


## Updating ISIS

If ISIS was already installed with Conda, you can update it with:

=== "Latest Release"

    ```sh
    conda update -c usgs-astrogeology isis
    ```

=== "LTS"

    ```sh
    conda update -c usgs-astrogeology/label/LTS isis
    ```

=== "Release Candidate"

    ```sh
    conda update -c usgs-astrogeology/label/RC isis
    ```


## Uninstalling ISIS

To uninstall ISIS, deactivate the ISIS Conda Environment, and then remove it.  If you want to uninstall conda as well, see your conda installation's website ([Miniforge](https://github.com/conda-forge/miniforge?tab=readme-ov-file#uninstallation) if you installed conda with the above instructions).

```sh
conda deactivate
conda env remove -n isis
```

-----

## ISIS in Docker

!!! quote ""

    The ISIS production Dockerfile automates the conda installation process above.
    You can either build the Dockerfile yourself or use the
    [usgsastro/isis](https://hub.docker.com/repository/docker/usgsastro/isis)
    image from DockerHub.

    === "Prebuilt Image"

        ```sh
        docker run -it usgsastro/isis bash
        ```

    === "Building the Dockerfile"


        Download [the production Docker file](https://github.com/DOI-USGS/ISIS3/blob/dev/docker/production.dockerfile), build, and run it:

        ```sh
        # Build
        docker build -t isis -f production.dockerfile .

        # Run
        docker run -it isis bash
        ```

    ### Mounting the ISIS data area

    Usually you'll want to mount an external directory containing the ISIS data.
    The data is not included in the Docker image.

    ```
    docker run -v /my/data/dir:/opt/conda/data -v /my/testdata/dir:/opt/conda/testData -it usgsastro/isis bash
    ```

    Then [download the data](#the-isis-data-area) into /my/data/dir to make it accessible inside your
    container.
