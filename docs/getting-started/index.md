# Getting Started

!!! info ""

    **Use the :octicons-search-24: search in the upper right corner :material-arrow-top-right: to find something fast!**

## ISIS

ISIS (Integrated Software for Imagers and Spectrometers) is a [collection of apps](https://isis.astrogeology.usgs.gov/Application/index.html) for working with planetary imagery. It includes command-line and interactive visual apps.  ISIS can import images from various spacecraft, and create mosaics and maps from multiple images.

<div class="grid cards" markdown>

-   :octicons-book-16:{ .lg .middle } __Learn ISIS basics__

    ---

    - [All About ISIS](using-isis-first-steps/introduction-to-isis.md)
    - [Find Image Data](using-isis-first-steps/locating-and-ingesting-image-data.md)
    - [Add SPICE Data](using-isis-first-steps/adding-spice.md)
    - [Process Mission Data](../concepts/missions/index.md)

-   :octicons-download-16:{ .lg .middle } __Install ISIS__

    ---

    Our script sets up miniforge, ISIS, and the data area for you.

    ```sh
    bash <(curl https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh)
    ```

    [:octicons-arrow-right-24: More on Installing ISIS](../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md)

</div>

## CSM Stack

The CSM (Community Sensor Model) Stack is a collection of apps ([ALE](https://github.com/DOI-USGS/ale), [Knoten](https://github.com/DOI-USGS/knoten)) that allow for programmatic processing of planetary image data and related spacecraft positional data.

<div class="grid cards" markdown>

-   :material-rotate-orbit:{ .lg .middle } __Using ALE__

    ---

    Calculate spacecraft orientation information.

    [:octicons-arrow-right-24: Generate an ISD file](../getting-started/using-ale/ale-getting-kernels.md)

    [:octicons-arrow-right-24: Specifying Kernels](../getting-started/using-ale/ale-getting-kernels.md)

-   :material-camera-marker:{ .lg .middle } __Using Knoten/CSM__

    ---

    Convert coordinates from image to ground reference frames.

    [:octicons-arrow-right-24: CSM Image-to-ground](../getting-started/csm-stack/image-to-ground-tutorial.ipynb)

-   :octicons-book-16:{ .lg .middle } __Sensor Model Concepts__

    ---

    - [Reference Frames](../concepts/sensor-models/reference-frames.md)
    - [Sensor Models](../concepts/sensor-models/sensor-models.md)
    - [USGS Software](../concepts/sensor-models/sensor-model-software.md)


</div>

## SpiceQL

SpiceQL is a library for indexing and querying information from spacecraft SPICE kernels.

<div class="grid cards" markdown>

-   :material-database-search:{ .lg .middle } __SpiceQL Example__

    ---

    Get positional data for the Cassini Spacecraft.

    [:octicons-arrow-right-24: Make a simple query](../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md)

-   :material-list-box:{ .lg .middle } __SpiceQL API__

    ---

    Examples and basics of the REST, Python, and C++ APIs for SpiceQL.

    [:octicons-arrow-right-24: Explore the API](../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md)


</div>

## FAQ

??? Question annotate "If the tutorial has dependencies, how do I install them?"
	We recommend using [miniforge's instructions](https://github.com/conda-forge/miniforge#install) as the package manager of choice for installing dependencies. This is a lite installation that comes with `mamba`, which is a C++ re-implementation of conda that solves packages much faster than conda. For some dependencies like ISIS, this can save a lot of time. Instructions will assume you are using mamba. (1) 

    Once you have mamba installed, you can create environments with `mamba create -n <env name> <package list>`, activate with `mamba activate <env name>`, and install new packages with `mamba install <package>` (2). 
    
1. Alternatively, if mini-forge isn't working (they are in active development and things move fast), you can follow [conda's instructions](https://docs.anaconda.com/free/anaconda/install/). If you are running a conda installation, replace the `mamba` commands with `conda`.
2. :exclamation::exclamation::exclamation: If you installed conda instead, remember to replace the `mamba` commands with `conda`. So environment creation becomes `conda create -n <env name> <package list>`, and environment activation becomes `conda activate env name`, etc.
    

??? Question "How do I run jupyter notebooks?" 
    As some tutorials require data, the easiest way to work with tutorials is by cloning the repo.
    ```shell
    # Clone the repo and go to the tutorials page
    git clone git@code.usgs.gov:astrogeology/asc-public-docs.git
    cd asc-public-docs/docs/getting-started/
    # install dependencies, tutorials often list dependencies at the top
    # We recommend a new env for each tutorial unless they happen to use the exact same dependencies. 
    mamba create -n tutorial-name -c conda-forge jupyter 
    jupyter notebook
    ``` 

-----

??? info "Contributing/Writing *Getting Started* Pages"

    Getting Started tutorials are lessons. Readers should be given a reasonable starting point, and should able to follow the tutorials with no external guidance. They are learning-oriented documents designed with the purpose of enabling new users to get started with a particular part of the software portfolio. 

    When creating a new getting-started tutorial, first you need to make sure what you are creating is a tutorial. Ask yourself: 

    * What is the lesson? Tutorials should have a lesson that the user is expected to learn. 
    * Does your tutorial have a concrete beginning? Tutorials should always have an obvious start with clear instructions on how to get any lesson examples running. 
    * Does your tutorial have a goal? Tutorials should have a clear goal that the user will accomplish. 

    ### Examples

    * Getting Started: ISIS image ingestion to map projected image, ingesting, bundling, and projecting an image list 
    * Getting Started: Generating an ISD and CSM camera model
    * Getting Started: Generate a control network with an image matcher 

    ### Items to Include 

    - [ ] If your tutorial requires software, list the software with versions and installation instructions. Feel free to link to existing docs with boilerplate info, for example:
    ```
    See [User Preferences File](../concepts/isis-fundamentals/preference-dictionary.md#user-preference-file) 
    or [Project Preference File](../concepts/isis-fundamentals/preference-dictionary.md#project-preference-file) 
    for more info on custom ISISPreferences files.
    ```
    - [ ] If your tutorial has data, use generative data or data that is in the repo. Avoid external data dependencies. Before data is committed into the repo, check if [existing data can be reused](https://github.com/DOI-USGS/asc-public-docs/tree/main/docs/assets). If new data needs to be committed, minimize the size so as not to increase the data burden. 
    - [ ] Make the objectives clear in the title. Also, clarify the tutorial with a summary of objectives. 

    See the [git repo](https://code.usgs.gov/astrogeology/asc-public-docs) for more in-depth info on how to contribute new docs. 
