??? note "Setting up Kernels, Calibration Files, and/or SpiceQL"

    For most missions, ISIS can use 
    [downloaded kernels](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/isis-data-area) locally, 
    or use [SpiceQL](https://astrogeology.usgs.gov/docs/how-to-guides/SPICE/using-web-spice-in-isis-and-ale) 
    to fetch kernel data online. 
    Calibration files must be downloaded locally.

    ### Using Online Kernels with SpiceQL

    The IsisPreferences file is located at `$ISISROOT/IsisPreferences`. 
    Set `UseSpiceQL = "true"` in the `SpiceQL` group:

    ```sh title="Open IsisPreferences"
    nano $ISISROOT/IsisPreferences
    ```

    ```json title="SpiceQL Settings"
    Group = SpiceQL
      UseSpiceQL = "true"
    EndGroup
    ```

    ### Checking for Local Kernels/Setting up ISISDATA

    If using local kernels, it's a good idea to check what's already set up:

    ```sh
    conda activate <your-isis-env>      # Activate your ISIS environment
    echo $ISISDATA                      # Check where/if ISISDATA location is set
    ls $ISISDATA                        # show files in ISISDATA (base + missions)
    ls $ISISDATA/<mission-short-name>   # show files for your mission 

    # If ISISDATA is unset, set it with:
    export ISISDATA=/my/isisdata/folder
    ``` 

    ### Downloading/Updating Local Kernels

    Use the ISIS short-name for your mission 
    (see [Mission Names & Download Commands](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/isis-data-area/#mission-specific-data-areas)) 
    to download its kernels.  (NOTE: Kernelsets may be large - hundreds of GB!)

    ```sh
    downloadIsisData <mission-short-name> $ISISDATA
    ```

    *The same `downloadIsisData` command may be run again later to download updated kernels.*

    ### Downloading Calibration Files

    Many missions need a few local files for calibration. 
    Fetching calibration data from the web isn't supported by SpiceQL.
    To download calibration files locally without downloading kernels:

    ```sh
    downloadIsisData <mission-short-name> $ISISDATA --no-kernels
    ```