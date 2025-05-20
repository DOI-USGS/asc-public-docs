# Installing ISIS


## Install via script 

You can install miniforge and ISIS at the same time using a bash script. This will walk you through the process and set environmment variables for you. 

```bash 
bash <(curl https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh)
```

!!! warning "If you use conda/miniconda and not miniforge"

    This script requires replacing anaconda/miniconda with [miniforge](https://github.com/conda-forge/miniforge). Miniforge is far faster. ISIS can take hours to resolve in anaconda, compared to a few minutes in miniforge.

??? info "Script Details"

    The `install_isis.sh` script is a bash script that automates the installation process of the USGS ISIS software.

    ## Prerequisites

    Before running the installation script, ensure you have:

    - A Linux or macOS operating system
    - Sufficient disk space (at least 40GB recommended for software + base data)
    - Internet connection
    - Bash shell

    ## Script Parameters

    The script accepts several command-line arguments to customize the installation:

    | Parameter | Description |
    |-----------|-------------|
    | `-m, --miniforge-dir` | Installation directory |
    | `-l, --anaconda-label` | Conda channel to use (default: `usgs-astrogeology`) |
    | `-p, --data-prefix`    | The directory where ISISDATA is located |
    | `-v, --isis-version` | ISIS version to install, `latest` always installs latest |
    | `-n, --env-name` | Name of the conda environment |
    | `--no-data` | Skip Data Downloads (flag) |
    | `--download-base` | Download Base Data |
    | `-h, --help` | Display help information |

    ## Installation Process

    The script performs the following steps:

    1. **Install Miniforge** (if method is `conda`): Downloads and installs Miniconda if not already available
    2. **Create Environment**: Sets up a conda environment with required packages
    3. **Install ISIS**: Installs ISIS software either from conda packages or source code
    4. **Download Data**: Fetches required data files based on specified options
    5. **Set Up Environment Variables**: Configures necessary environment variables

??? Info "CLI Examples"

    === "wget"

        ```bash 
        wget -O install_isis.sh https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh"
        ```

    === "curl"

        ```bash
        curl -fsSLo install_isis.sh https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh" 
        ```

    In order to install ISIS in an automated pipeline, set the flags: 

      1. `-l` to set the label for the conda channel
      2. `-v` to set the ISIS version
      3. `-n` to set the env name, use `auto` and the script creates one at runtime
      4. `--prefix` only if you are installing somewhere other than your default conda directory. 
      4. Set data flags as needed (you cannot mix these flags): 
        * `--no-data` to skip data install (you can download data later via [downloadIsisData.py](isis-data-area.md))
        * `--download-base` to download base data and shape models + calibration files. 
     
    !!! warning "Why only base data?"
     
        The base data is the most important data for ISIS. It is not necessary to download the entire dataset, but it is recommended to download the base data and enable `web=true` when using [spiceinit](https://isis.astrogeology.usgs.gov/9.0.0/Application/presentation/Tabbed/spiceinit/spiceinit.html). 
    
    ### Specific Install Examples

    You can add `--download-base` instead of `--no-data` to the end of the command to download base data and shape models + calibration files. 

    === "Latest main"

        ```bash 
        ./install_isis.sh -l main -v latest -n auto -p $HOME/isisdata --no-data
        ```

    === "Latest dev"

        ```bash
        ./install_isis.sh -l dev -v latest -n auto -p $HOME/isisdata --no-data
        ```

    === "Latest lts"
        
        ```bash 
        ./install_isis.sh -l lts -v latest -n auto -p $HOME/isisdata --no-data
        ```

    === "Complex Example"
        
        This also: 

          1. Downloads base data, shape models, and calibration files for ISIS 8.3.0 
          2. Installs ISIS with a custom prefix.
          3. Force redownload of miniforge 

        ```bash
        ./install_isis.sh --force-mamba -m $HOME/miniforge/ -l main -v 8.3.0 -n auto -p $HOME/isisdata --download-base --prefix $HOME/isis_installs/
        ```

## After install consideratrions 

### ISIS DATA

The script can download various types of ISIS data:

- **Base Data**: Essential data required for ISIS functionality
- **Mission-specific Data**: Data for specific planetary missions

We recommend only installing base, and use web spice for most spice operations. See [ISIS Data Docs](isis-data-area.md) for more information.

## Environment Variables

Key environment variables set up by the script:

- `ISISROOT`: Points to the ISIS installation directory
- `ISISDATA`: Points to the ISIS data directory
- `PATH`: Updated to include ISIS binaries

On activation, the environment will automatically set ISISROOT, ISISDATA, and PATH for you. To change these variables after installation (in case they were set incorrectly or your ISISDATA folder changes) see [setting environment variables](#setting-environmental-variables). 

## Updating ISIS

!!! Warning
    Mamba is bad at updating envs after they have been created. This often causes conflicts and long resolve times. If you installed ISIS using this script, we recommend simply deleting the old environment and creating new one, or versioning your env names. 


```bash 
# initial install 
./install_isis.sh -l main -v 8.0.0 -n isis8.0.0 -p $HOME/isisdata --download-base

# After 8.3.0 release 
./install_isis.sh -l main -v 8.3.0 -n isis8.3.0 -p $HOME/isisdata --no-data
```


## Additional Resources

- [ISIS GitHub Repository](https://github.com/USGS-Astrogeology/ISIS3)
- [Report ISIS Issues](https://github.com/DOI-USGS/ISIS3/issues)

-----

# Install Manually Via Miniforge  
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
    export CONDA_SUBDIR=osx-64
    
    #Create a new mamba environment to install ISIS in
    mamba create -n isis python>=3.9

    #Activate the environment
    mamba activate isis
    
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
    mamba install -c usgs-astrogeology/label/dev isis
    ```


## Setting Environmental Variables

ISIS requires these environment variables to be set in order to run correctly:

- `ISISROOT` - Directory path containing your ISIS install
- `ISISDATA` - Directory path containing the [ISIS Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md)

???+ example "Setting Environmental Variables"

    The **conda env** method is recommended, and the **Python Script** automates that method:

    === "conda env"

        ??? "Requires conda 4.8 or above"

            Check your conda version, and update if needed:

            ```sh
            # Check version
            conda --version

            # Update
            conda update -n base conda
            ```

        1.  Activate your ISIS environment.  
            ```
            mamba activate isis

            # Now you can set variables with:
            # mamba env config vars set KEY=VALUE
            ```

        1.  This command sets both required variables (fill in your `ISISDATA` path):

                mamba env config vars set ISISROOT=$CONDA_PREFIX ISISDATA=[your data path]

        1.  Re-activate your isis environment. 
            ```sh
            mamba deactivate
            mamba activate isis
            ```

        The environment variables are now set and ISIS is ready for use every time the isis mamba environment is activated.


    === "Python Script"

        By default, running this script will set `ISISROOT=$CONDA_PREFIX` and `ISISDATA=$CONDA_PREFIX/data`:

            python $CONDA_PREFIX/scripts/isisVarInit.py
        
        You can specify a different path for `$ISISDATA` using the optional value:

            python $CONDA_PREFIX/scripts/isisVarInit.py --data-dir=[path to data directory]

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
