# Getting Started with ALE

## :material-numeric-1-circle-outline: Install ALE & Get SPICE Data

<div class="grid cards" markdown>

-   :material-package-variant:{ .lg .middle } __Install ALE in [conda](https://conda-forge.org/download/)__ 

    ---
    
    ```sh
    conda create -n ale
    conda activate ale
    conda install -c conda-forge ale
    ```

    [:octicons-link-external-16: ALE Readme](https://github.com/DOI-USGS/ale/blob/main/README.md)

-   :octicons-download-16:{ .lg .middle } __Get SPICE Data__

    ---

    Download SPICE Data.  
    Tell ALE where to find it.  
    Learn about image/driver types.  

    [:octicons-arrow-right-24: Setup SPICE Data for ALE](../../getting-started/using-ale/ale-naif-spice-data-setup.md)

</div>

-----

## :material-numeric-2-circle-outline: ALE Basic Usage

<div class="grid cards" markdown>

-   :octicons-terminal-16:{ .lg .middle } __ALE on the Command Line__

    ---

    Use `isd_generate` to create ISDs

    [:octicons-arrow-right-24: Generate an ISD](../../getting-started/using-ale/isd-generate.md)

-   :simple-python:{ .lg .middle } __ALE in Python__

    ---

    Create ISDs with `ale.load` & `ale.loads`

    [:octicons-arrow-right-24: Get Started in Python](../../getting-started/using-ale/ale-python-load-loads.md)

</div>

-----

## :material-numeric-3-circle-outline: Using ALE in the CSM Stack

<div class="grid cards" markdown>

-   [:octicons-arrow-right-24: Instantiating a CSM Camera Model](../../getting-started/csm-stack/image-to-ground-tutorial.ipynb)

-   [:octicons-arrow-right-24: Knoten - Basic Camera Operations](../../getting-started/csm-stack/knoten-camera-tutorial.ipynb)

</div>

-----

## :material-numeric-4-circle-outline: Advanced Topics & ALE Development

<div class="grid cards" markdown>

-   [:octicons-arrow-right-24: Creating an ALE Driver](../../how-to-guides/ale-developer-guides/creating-ale-drivers.md)

-   [:octicons-arrow-right-24: ALE Drive Architecture](../../concepts/ale/ale-driver-architecture.md)

</div>