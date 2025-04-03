# Installing ISIS

<div class="grid cards" markdown>

- [:octicons-arrow-left-24: __Introduction__ to ISIS](../../getting-started/using-isis-first-steps/introduction-to-isis.md)
- [:octicons-arrow-right-24: Setting up the  __ISIS Data Area__](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md)

</div>


## Install via script 

You can install miniforge and ISIS at the same time using a bash script. This will walk you through the process and set environmment variables for you. 

```bash 
bash <(curl https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh)
```

## Install Manually Via Miniforge  
### Prerequisites

??? "Mamba/Miniforge"

    If you don't have mamba yet, download and install it.  We recommend getting mamba through [MiniForge](https://github.com/mamba-forge/miniforge?tab=readme-ov-file#miniforge).

    ```sh
    # Via Miniforge:
    curl -L -O "https://github.com/mamba-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3-$(uname)-$(uname -m).sh
    ```

??? "x86 emulation on ARM Macs - Rosetta"

    If you have an ARM mac and want to run the x86 version of ISIS, you will need Rosetta.

    ```sh
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    ```
    

### Mamba Environment

=== "Native Mac/Unix"

    ```sh
    # Create mamba environment, then activate it.
    mamba create -n isis 
    mamba activate isis
    ```

=== "x86 on ARM Macs"

    ```sh
    # ARM Macs Only - Setup the new environment as x86_64
    export mamba_SUBDIR=osx-64
    
    #Create a new mamba environment to install ISIS in
    mamba create -n isis python>=3.9

    #Activate the environment
    mamba activate isis
    
    # ARM Macs Only - Force installation of x86_64 packages, not ARM64
    mamba config --env --set subdir osx-64
    ```

### Channels

```sh

# Add mamba-forge and usgs-astrogeology channels
mamba config --env --add channels mamba-forge
mamba config --env --add channels usgs-astrogeology

# Check channel order
mamba config --show channels
```

??? warning "Channel Order: `usgs-astrogeology` must be higher than `mamba-forge`"
    
    Show the channel order with:

    ```sh
    mamba config --show channels
    ```

    You should see:

    ```
    channels:
        - usgs-astrogeology
        - mamba-forge
        - defaults
    ```

    If `mamba-forge` is before `usgs-astrogeology`, add usgs-astrogeology again to bring up.  Set channel priority to flexible instead of strict.

    ```sh
    mamba config --env --add channels usgs-astrogeology
    mamba config --env --set channel_priority flexible
    ```

### Downloading ISIS

The environment is now ready to download ISIS and its dependencies:

=== "Latest Release"

    ```sh
    mamba install -c usgs-astrogeology isis
    ```

=== "LTS"

    ```sh
    mamba install -c usgs-astrogeology/label/LTS isis
    ```

=== "Release Candidate"

    ```sh
    mamba install -c usgs-astrogeology/label/RC isis
    ```


=== "Dev"

    ```sh
    conda install -c usgs-astrogeology/label/dev isis
    ```


## Environmental Variables

ISIS requires these environment variables to be set in order to run correctly:

- `ISISROOT` - Directory path containing your ISIS install
- `ISISDATA` - Directory path containing the [ISIS Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md)

???+ example "Setting Environmental Variables"

    The **mamba Env** method is recommended, and the **Python Script** automates that method:

    === "mamba Env"

        ??? "Requires mamba 4.8 or above"

            Check your mamba version, and update if needed:

            ```sh
            # Check version
            mamba --version

            # Update
            mamba update -n base mamba
            ```

        1.  Activate your ISIS environment.  
            ```
            mamba activate isis

            # Now you can set variables with:
            # mamba config vars set KEY=VALUE
            ```

        1.  This command sets both required variables (fill in your `ISISDATA` path):

                mamba env config vars set ISISROOT=$mamba_PREFIX ISISDATA=[your data path]

        1.  Re-activate your isis environment. 
            ```sh
            mamba deactivate
            mamba activate isis
            ```

        The environment variables are now set and ISIS is ready for use every time the isis mamba environment is activated.


    === "Python Script"

        By default, running this script will set `ISISROOT=$mamba_PREFIX` and `ISISDATA=$mamba_PREFIX/data`:

            python $mamba_PREFIX/scripts/isisVarInit.py
        
        You can specify a different path for `$ISISDATA` using the optional value:

            python $mamba_PREFIX/scripts/isisVarInit.py --data-dir=[path to data directory]

        Now every time the isis environment is activated, `$ISISROOT` and `$ISISDATA` will be set to the values passed to isisVarInit.py.
        This does not happen retroactively, so re-activate the isis environment:

            mamba deactivate
            mamba activate isis


    === "export (shell)"

        `export` sets a variable in your current shell environment until you close it.  Adding `export` commands to your `.bashrc` or `.zshrc` can make them persistent.

        ```sh
        export ISISROOT=[path to ISIS]
        export ISISDATA=[path to data]
        ```


    === "ISIS <4.2.0"

        Use the python script per instructions from [the old readme](https://github.com/USGS-Astrogeology/ISIS3/blob/adf52de0a04b087411d53f3fe1c9218b06dff92e/README.md).


### The ISIS Data Area

Many ISIS apps need extra data to carry out their functions.  This data varies depending on the mission, and may be quite large, so it is not included with ISIS; You will need to [download it separately](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md).

-----

!!! success "Installation Complete"
    
    If you followed the above steps and didn't encounter any errors, you have completed your installation of ISIS.

-----


### Updating ISIS

If ISIS was already installed with mamba, you can update it with:

=== "Latest Release"

    ```sh
    mamba update -c usgs-astrogeology isis
    ```

=== "LTS"

    ```sh
    mamba update -c usgs-astrogeology/label/LTS isis
    ```

=== "Release Candidate"

    ```sh
    mamba update -c usgs-astrogeology/label/RC isis
    ```


## Uninstalling ISIS

To uninstall ISIS, deactivate the ISIS mamba Environment, and then remove it.  If you want to uninstall mamba as well, see your mamba installation's website ([Miniforge](https://github.com/mamba-forge/miniforge?tab=readme-ov-file#uninstallation) if you installed mamba with the above instructions).

```sh
mamba deactivate
mamba env remove -n isis
```

-----

## ISIS in Docker

!!! quote ""

    The ISIS production Dockerfile automates the mamba installation process above.
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
    docker run -v /my/data/dir:/opt/mamba/data -v /my/testdata/dir:/opt/mamba/testData -it usgsastro/isis bash
    ```

    Then [download the data](#the-isis-data-area) into /my/data/dir to make it accessible inside your
    container.
