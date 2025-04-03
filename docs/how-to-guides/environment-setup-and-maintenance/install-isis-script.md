# ISIS Software Installation Script 

This document provides a comprehensive explanation of the `install_isis.sh` script used to install the USGS ISIS (Integrated Software for Imagers and Spectrometers) software.

## Overview

The `install_isis.sh` script is a bash script that automates the installation process of the USGS ISIS software.

## Prerequisites

Before running the installation script, ensure you have:

- A Linux or macOS operating system
- Sufficient disk space (at least 20GB recommended for software + base data)
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

## Install ISIS in a pipeline

=== "wget"

    ```bash 
    wget -O install_isis.sh https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh"
    ```

=== "curl"

    ```bash
    curl -fsSLo install_isis.sh https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh" 
    ```

In order to install ISIS in a CI or other automated pipeline, set flags for the label, version, env name and `--no-data` to skip data install. Install data via [downloadIsisData.py](isis-data-area.md). 

## Command Line Examples 

### Install the latest dev version of ISIS 

```bash
./install_isis.sh -l dev -m $HOME/miniforge -v latest -n isisdev -p $HOME/isisdata --no-data
```

### Install the latest main version 

```bash 
./install_isis.sh -l main -v latest -n isislatest -p $HOME/isisdata --no-data
```

### Install the latest LTS 

```bash 
./install_isis.sh -l lts -v latest -n isislts -p $HOME/isisdata --no-data
```

### Install 8.3.0 

```bash
./install_isis.sh -l main -v 8.3.0 -n isis8.3.0 -p $HOME/isisdata --download-base
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

On activation, the environment will automatically set ISISROOT, ISISDATA, and PATH for you. To change these variables after installation in case they were set incorrectly or your ISISDATA folder changes, see [Conda's docs on setting environment variables](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#saving-environment-variables). 

## Updating ISIS

!!! Warning
    Mamba is bad at updating envs after they have been created. This often causes conflicts and long resolve times. If you installed ISIS using this script, we reccomnend simply deleting the old environment and creating new one. Or versioning your env names. 


```bash 
# initial install 
./install_isis.sh -l main -v 8.0.0 -n isis8.0.0 -p $HOME/isisdata --download-base

# After 8.3.0 release 
./install_isis.sh -l main -v 8.3.0 -n isis8.3.0 -p $HOME/isisdata --no-data
```


## Additional Resources

- [ISIS GitHub Repository](https://github.com/USGS-Astrogeology/ISIS3)
- [Report ISIS Issues](https://github.com/DOI-USGS/ISIS3/issues)

