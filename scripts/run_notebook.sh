#!/bin/bash

# Define environment name and package to install
ENV_YAML="environment.yml"
NOTEBOOK_FILE="temp.ipynb"
DATA_DIR="data/"
PORT=8888
BASE_URL="https://astrogeology.usgs.gov/docs/getting-started/data/downloads"
ZIP_NAME="temp"
STOP="return 1 2>/dev/null || exit 1"

# --- SOURCING CHECK ---
# This stops the user from running ./run_notebook.sh (which won't activate)
# and ensures they use 'source run_notebook.sh'
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "ERROR: Please run this script using: source run_notebook.sh"
    echo "This is necessary in order to activate the newly created conda"
    echo "environment and run the Jupyter Notebook."
    exit 1
fi

# Apply check for optional arguments that expect a value
check_valid_arg() {
    if [[ "$2" = "-"* ]]; then
        echo "Invalid argument: $2"
        echo "Found after $1"
        exit 1
    fi

    if [[ -z $2 ]]; then
        echo "No value for $1 provided"
        exit 1
    fi
}

print_help() {
    printf "Usage: $0 [options]\n"
    printf "Options:\n"
    printf "\t-d, --data                The directory where sample data. Will default search\n"
    printf "\t                          for 'data/' folder in current directory.\n"
    printf "\t-e, --env-yaml            File path for conda environment yaml file.\n"
    printf "\t                          Will default to 'environment.yml' file in current\n"
    printf "\t                          directory\n" 
    printf "\t-h, --help                Show this help message and exit\n"
    printf "\t-j, --jupyter-notebook    File path for Jupyter Notebook (.ipynb).\n"
    printf "\t                          Will default search for *.ipynb file in current\n"
    printf "\t                          directory\n" 
    printf "\t-m, --miniforge-dir       Define the directory to an anaconda package\n"
    printf "\t                          manager install location. If you have an\n"
    printf "\t                          anaconda package manager already this\n"
    printf "\t                          argument will be ignored. If not a version\n"
    printf "\t                          of miniforge will be installed at this\n"
    printf "\t                          location\n"
    printf "\t-p, --port                Port where the Jupyter Notebook will run. Default is\n"
    printf "\t                          8888 at 127.0.0.1:8888\n"
    printf "\t-z, --zip-name            Zip file to download from ASC Public Docs.\n"
    printf "\n"
    printf "\tDefining variables on the command line will skip the\n"
    printf "\tinteractive elements within this script\n"
    printf "\n\n"
}

for arg in "$@"; do
    case $arg in
        -h|--help)
            print_help
            eval $STOP
    esac
done

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--data)
            check_valid_arg $1 $2
            DATA_DIR="$2"
            shift # past argument
            shift # past value
            ;;
        -e|--env-yaml)
            check_valid_arg $1 $2
            ENV_YAML="$2"
            shift # past argument
            shift # past value
            ;;
        -j|--jupyter-notebook)
            check_valid_arg $1 $2
            NOTEBOOK_FILE="$2"
            shift # past argument
            shift # past value
            ;;
        -m|--miniforge-dir)
            check_valid_arg $1 $2
            MINIFORGE_DIR="$2"
            shift # past argument
            shift # past value
            ;;
        -p|--port)
            check_valid_arg $1 $2
            PORT=$2
            shift # past argument
            shift # past value
            ;;
        -z|--zip-name)
            check_valid_arg $1 $2
            ZIP_NAME=$2
            shift # past argument
            shift # past value
            ;;
        -*|--*)
            echo "Unknown option $1"
            echo ""
            print_help
            eval $STOP
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

# --- ROSETTA 2 CHECK FOR ARM64 MACS ---
if [[ "$(uname -m)" == "arm64" ]]; then
    # Check if Rosetta is installed by looking for the translation daemon
    if ! pgrep -q oahd; then
        echo "------------------------------------------------------------"
        echo "NOTICE: You are on Apple Silicon (ARM64)."
        echo "The ISIS/Knoten tools require an Intel (osx-64) environment."
        echo "Rosetta 2 is NOT installed and is necessary to run these tools."
        echo "------------------------------------------------------------"
        
        read -p "Would you like to install Rosetta 2 now? (y/n): " install_rosetta
        
        if [[ "$install_rosetta" =~ ^[Yy]$ ]]; then
            echo "Installing Rosetta 2... (You may be prompted for your password)"
            sudo softwareupdate --install-rosetta --agree-to-license
            
            if [ $? -ne 0 ]; then
                echo "Error: Rosetta 2 installation failed."
                eval $STOP
            fi
            echo "Rosetta 2 installed successfully!"
        else
            echo "Error: Rosetta 2 is required for this project. Exiting."
            eval $STOP
        fi
    fi
fi

# Determine the OS type
case "$(uname)" in
    "Linux")
        MINIFORGE_INSTALLER="Miniforge3-Linux-x86_64.sh"
        LIBGL_INSTALL=""
        ;;
    "Darwin")
        MINIFORGE_INSTALLER="Miniforge3-MacOSX-x86_64.sh"
        LIBGL_INSTALL=""
        export CONDA_SUBDIR=osx-64
        ;;
    *)
        echo "Unsupported OS: $(uname)"
        exit 1
        ;;
esac

if [[ "$ZIP_NAME" != "temp" ]]; then
    echo "Retrieving $ZIP_NAME.zip file from $BASE_URL..."
    # Append .zip extension
    if [[ "$ZIP_NAME" != *.zip ]]; then
        ZIP_NAME="${ZIP_NAME}.zip"
    fi

    # --- DOWNLOAD AND UNZIP ---
    FULL_URL="${BASE_URL}/${ZIP_NAME}"
    echo "Setting up workspace from: $FULL_URL"

    curl -f -L "$FULL_URL" -o "$ZIP_NAME"

    if [[ $? -eq 0 ]]; then
        unzip -oq "$ZIP_NAME"
        rm "$ZIP_NAME"
    else
        echo "Error: Could not download [$ZIP_NAME] from $BASE_URL"
        eval $STOP
    fi

    # --- DYNAMIC VARIABLE ASSIGNMENT ---
    # Now that we've unzipped, we point our variables to the actual files
    ENV_YAML=$(ls environment.yml 2>/dev/null)
    NOTEBOOK_FILE=$(ls *.ipynb | head -n 1 2>/dev/null)

    # --- VALIDATION ---
    if [[ -f "$ENV_YAML" && -f "$NOTEBOOK_FILE" && -d "$DATA_DIR" ]]; then
        echo "------------------------------------------------------------"
        echo "SUCCESS: Workspace variables set."
        echo "Environment: $ENV_YAML"
        echo "Data Folder: $DATA_DIR"
        echo "Notebook:    $NOTEBOOK_FILE"
        echo "------------------------------------------------------------"
    else
        echo "Error: Zip content missing required 'environment.yml', *.ipynb file, or 'data' folder."
        eval $STOP
    fi
fi

# --- VALIDATION ---
if [[ ! -f "$NOTEBOOK_FILE" ]]; then
    echo "Error: Notebook file '$NOTEBOOK_FILE' not found."
    eval $STOP
fi

if [[ ! -f "$ENV_YAML" ]]; then
    echo "Error: $ENV_YAML not found."
    eval $STOP
fi

# --- CONDA/MAMBA INSTALLATION ---

# Install Miniforge if it's not already installed
if ! command -v mamba &> /dev/null; then

    echo "Miniforge not found, installing Miniforge..."

    # If a MINIFORGE_DIR is not set, ask the user
    if [ -z "$MINIFORGE_DIR" ]; then
        MINIFORGE_DIR="$HOME/miniforge3"

        printf "Miniforge will be installed at this location:\n\n" 
        printf "\t$MINIFORGE_DIR/\n\n"
        printf "\\n"
        printf "  - Press ENTER to confirm the Miniforge install location\\n"
        printf "  - Press CTRL-C to abort the installation\\n"
        printf "  - Or specify a different location below\\n"
        printf "\\n"
        printf "[%s] >>> " "$MINIFORGE_DIR"

        read -r miniforge_install_path

        # If input was given, set it
        if [ -n "$miniforge_install_path" ]; then
            MINIFORGE_DIR=$miniforge_install_path
        fi
    fi

    # Check if MINIFORGE_DIR exists but mamba is not in PATH
    if [ -d "$MINIFORGE_DIR" ]; then
        echo "Miniforge directory exists at $MINIFORGE_DIR, reusing existing installation"
    else
        curl -kL "https://github.com/conda-forge/miniforge/releases/latest/download/$MINIFORGE_INSTALLER" -o Miniforge3.sh || { echo "Miniforge download failed"; eval $STOP }
        bash Miniforge3.sh -b -p $MINIFORGE_DIR || { echo "Miniforge installation failed"; eval $STOP }
    fi

    $MINIFORGE_DIR/bin/conda init bash || eval $STOP
    $MINIFORGE_DIR/bin/conda init zsh || eval $STOP
    export PATH="$MINIFORGE_DIR/bin:$PATH"
else
    echo "Miniforge is already installed."
    MINIFORGE_DIR=$(conda info --base)
    echo "Setting MINIFORGE_DIR to $MINIFORGE_DIR"
fi

# After install, we MUST refresh the shell to see 'mamba'
eval "$($MINIFORGE_DIR/bin/conda shell.bash hook)"

# --- ENVIRONMENT LOGIC ---
ENV_NAME=$(grep '^name:' "$ENV_YAML" | sed 's/name:[[:space:]]*//' | tr -d '\r')
# Construct the full path to the environment
ENV_PATH="$MINIFORGE_DIR/envs/$ENV_NAME"

echo "Targeting environment path: $ENV_PATH"

# Use the absolute path to the mamba binary to ensure we use the base install's logic
MAMBA_BIN="$MINIFORGE_DIR/bin/mamba"

if conda info --envs | grep -q "^$ENV_NAME "; then
    echo "Updating existing environment..."
    "$MAMBA_BIN" env update -p "$ENV_PATH" -f "$ENV_YAML" --prune -y || { echo "Mamba update failed"; eval $STOP }
else
    echo "Creating new environment..."
    "$MAMBA_BIN" create -p "$ENV_PATH" -f "$ENV_YAML" -y || { echo "Mamba creation failed"; eval $STOP }
fi

# --- ACTIVATION ---
eval "$(conda shell.bash hook)"
conda activate "$ENV_NAME"

echo "Current Environment: $CONDA_DEFAULT_ENV"

# --- LAUNCH ---
jupyter lab $NOTEBOOK_FILE --port=$PORT
