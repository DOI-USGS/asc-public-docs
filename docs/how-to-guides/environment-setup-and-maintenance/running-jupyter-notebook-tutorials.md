# Running Jupyter Notebook Tutorial

## Use the `run_notebook.sh` script

```sh
source <(curl https://raw.githubusercontent.com/chkim-usgs/asc-public-docs/refs/heads/jupyter/scripts/run_notebook.sh) -z <zip-filename>
```

???+ info "Script Details"

    The `run_notebook.sh` script is a bash script that automates the Jupyter Notebook tutorial setup and launch.

    ## Prerequisites

    Before running the installation script, ensure you have:

    - A Linux or macOS operating system
    - Internet connection
    - Bash shell

    ## Script Parameters

    The script accepts several command-line arguments to customize the installation:

    | Parameter | Description |
    |-----------|-------------|
    | `-d, --data` | Tutorial data folder path |
    | `-e, --env-yaml` | File path for conda environment yaml file |
    | `-h, --help` | Display help information |
    | `-d, --data-prefix`    | The directory where ISISDATA is located |
    | `-j, --jupyter-notebook` | File path for Jupyter Notebook (.ipynb) |
    | `-m, --miniforge-dir` | Installation directory |
    | `-p, --port` | Port where the Jupyter Notebook will run |
    | `-z, --zip-name` | Zip file to download from ASC Public Docs.|
    

    ## Installation Process

    The script performs the following steps:

    1. **Setup Tutorial Configurations**:  
        1a. Retrieves ZIP data from ASC Public Docs    
        1b. Given user input from script parameters
    2. **Install Miniforge** (if method is `conda`): Downloads and installs Miniconda if not already available
    3. **Create Environment**: Sets up a conda environment with required packages
    4. **Launch Jupyter Notebook Tutorial**: Runs the notebook locally in your browser

## Setup manually

### 1. Download the ZIP file from the tutorial page
    - The ZIP file includes
        - environment.yaml - conda environment file
        - *.ipynb - Jupyter Notebook
        - data/ - folder containing tutorial data

### 2. Create the conda environment
```sh
mamba create -f environment.yaml
```

### 3. Run tutorial
```sh
jupyter lab
```
Defaults to port 8888 so the notebook should automatically open up a browser page to URL http://127.0.0.1:8888


## Setting up Jupyter Notebook tutorials

1. Add tutorial admonitions  
Add the following admonitions to a markdown cell below the header:

    - Allows user to run the `run_notebook.sh` script using the `-z` option.

    !!! quote "Tutorial ZIP name"

        ```
        <zip-filename>
        ```

    - Gives the user options on installing and running the tutorial automatically vs manually.

    !!! tip "Running this Jupyter Notebook locally"

        === "Via script"

            Run this command in the terminal:
            ```bash
            source <(curl https://raw.githubusercontent.com/DOI-USGS/asc-public-docs/refs/heads/jupyter/scripts/run_notebook.sh) -z <zip-filename>
            ```
            Read more about the [script details](../../how-to-guides/environment-setup-and-maintenance/running-jupyter-notebook-tutorials.md#use-the-run_notebooksh-script).

        === "Manual setup"

            Download the zip file and follow the [manual setup instructions](../../how-to-guides/environment-setup-and-maintenance/running-jupyter-notebook-tutorials.md#setup-manually).
        
            [Download zip :material-download:](../data/downloads/knoten-camera.zip){ .md-button }

2. Create a ZIP file
The ZIP file needs to include the environment.yml file, *.ipynb notebook, and the data/ folder. The file needs to be moved to the `docs/getting-started/data/downloads` folder of the repo.




