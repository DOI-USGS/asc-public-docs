# Setting Up the ISIS Data Area

Many ISIS apps need extra data to carry out their functions.  This data varies depending on the mission, and may be **quite large**, so it is **not included** with the ISIS binaries. It resides in the **ISIS Data Area**.

??? info "More Info on the ISIS Data Area"

    ### Structure

    Each mission supported by ISIS has a directory with mission-specific processing data (like flat files and SPICE kernels).  There is also a base data area with shared data, and a test data area for ISIS testing and development.

    #### Output of `tree -L 2 $ISISDATA`
    ```sh
    ~/isis_data/
    ├── apollo15
    │   ├── calibration
    │   ├── kernels
    │   └── reseaus
    ├── apollo16
    │   ├── kernels
    │   └── reseaus
    ├── base
    │   ├── dems
    │   ├── examples
    │   ├── kernelTesting
    │   └── kernels
    ├── cassini
    │   ├── calibration
    │   ├── kernels
    │   └── unitVectors
    ├── chandrayaan1
    │   ├── bandBin
    │   └── kernels
    ├── clementine1
    │   ├── calibration
    │   └── kernels
    ├── dawn
    │   └── kernels
    ...
    ```
        

    ### Hosting

    The ISIS Data Area is hosted on a combination of AWS S3 buckets and public http servers (NAIF, Jaxa, ESA), not through conda like ISIS binaries.  The `downloadIsisData` script facilitates downloading ISIS data from various sources.

    ### Versions

    For ISIS 4.1.0 and above, some apps require the [`base`](#__tabbed_2_1) and/or [mission-specific](#mission-specific-data-areas) data areas, while other apps may run without them.

    Apps from ISIS versions lower than 4.1.0 require the [`legacybase`](#__tabbed_2_2) area.

    ### Example ISISDATA usage in ISIS Apps

    - **Calibration** apps need **flat files** to do _flat field corrections_.
    - **Map Projection** apps need **DTMs** to accurately _compute intersections_.
    - `spiceinit` uses SPICE Data is used to _initialize ISIS cubes_.

    ### Size

    All the ISIS data from various missions adds up to a total of over 2TB.  But, using the [ISIS SPICE Web Service](#isis-spice-web-service) (instead of downloading all the SPICE files) reduces the necessary download to a much more manageable ~10GB base.


## Setting the ISISDATA Environmental Variable

Any location can be used for the ISIS Data Area, ISIS just needs the `$ISISDATA` environmental variable to point to it.

=== "Conda"

    ```sh
    # Activate your environment (assuming it's named isis)
    conda activate isis

    # Set the variable
    conda env config vars set ISISDATA=<path/to/isisdata>

    # Reactivate your environment
    conda deactivate
    conda activate isis
    ```

=== "Shell"

    ```sh
    export ISISDATA=<path/to/isisdata>
    ```


## Downloading ISISDATA

You can use the `downloadIsisData` script to download ISIS data.

```sh
# General Usage
downloadIsisData [mission] [download destination] [optional flags]

# More Info
downloadIsisData --help
```

??? "downloadIsisData script for ISIS 7.0.0 and earlier"

    The `downloadIsisData` was not included with earlier versions of ISIS.  To use it for those versions, download three things first: rclone, the `downloadIsisData` script and the `rclone.conf` file.

    ```sh
    # Install rclone 
    conda install -c conda-forge rclone

    # Download the script and rclone config file
    curl -LJO https://github.com/USGS-Astrogeology/ISIS3/raw/dev/isis/scripts/downloadIsisData
    curl -LJO https://github.com/USGS-Astrogeology/ISIS3/raw/dev/isis/config/rclone.conf

    # Use python 3 when you run the script,
    # and use --config to point to where you downloaded the config file 
    python3 downloadIsisData --config rclone.conf <mission> $ISISDATA
    ```

### Full Download

To download **ALL** Isis data, including the base and all of the mission data areas:

```sh
downloadIsisData all $ISISDATA
```

!!! warning "That's a lot of data!"

    Downloading *all* takes over 2TB of space!  See [Partial Downloads](#partial-downloads) if you want a smaller subset, or try the [ISIS SPICE Web Service](#isis-spice-web-service).

### Partial Downloads

#### The Base Data Area

Some data (like DEMs and Leap Second Kernels) are shared between multiple missions; this is the base data area.

If you work with camera models (using `cam2map`, `campt`, `qview`, etc.), or are using a legacy version of ISIS, we recommend downloading the base data area:

=== "Current"

    ```sh
    # For ISIS versions 4.1.0 and up
    downloadIsisData base $ISISDATA
    ```

=== "Legacy"

    ```sh
    # For ISIS versions before 4.1.0
    downloadIsisData legacybase $ISISDATA
    ```

</br>

#### Mission Specific Data Areas

If you are only working with a few missions, save space by downloading just those data areas (find your download command on the following list).

??? abstract "Mission Names & Download Commands"

    - For versions of ISIS prior to ISIS 4.1.0, please use the `--legacy` flag.
    
    - Reference [`rclone.conf`](https://github.com/DOI-USGS/ISIS3/blob/dev/isis/config/rclone.conf) if you can't find/download data for your mission with one of these commands.

    | Mission | Command |
    | ------ | ------ |
    | Apollo 15 | `downloadIsisData apollo15 $ISISDATA` |
    | Apollo 16 | `downloadIsisData apollo16 $ISISDATA` |
    | Apollo 17 | `downloadIsisData apollo17 $ISISDATA` |
    | Cassini | `downloadIsisData cassini $ISISDATA` | 
    | Chandrayaan 1 | `downloadIsisData chandrayaan1 $ISISDATA` |
    | Clementine 1 | `downloadIsisData clementine1 $ISISDATA` |
    | Dawn | `downloadIsisData dawn $ISISDATA` |
    | ExoMars | `downloadIsisData tgo $ISISDATA` |
    | Galileo | `downloadIsisData galileo $ISISDATA` | 
    | Hayabusa 2 | `downloadIsisData hayabusa2 $ISISDATA` |
    | Juno | `downloadIsisData juno $ISISDATA` |
    | Kaguya | `downloadIsisData kaguya $ISISDATA` |
    | Lunar Orbiter | `downloadIsisData lo $ISISDATA` |
    | Lunar Reconnaissance Orbiter | `downloadIsisData lro $ISISDATA` |
    | Mars Exploration Rover  | `downloadIsisData mer $ISISDATA` |
    | Mariner10  | `downloadIsisData mariner10 $ISISDATA` |
    | Messenger | `downloadIsisData messenger $ISISDATA` |
    | Mars Express  | `downloadIsisData mex $ISISDATA` |
    | Mars Global Surveyor  | `downloadIsisData mgs $ISISDATA` |
    | Mars Reconnaissance Orbiter  | `downloadIsisData mro $ISISDATA` |
    | Mars Science Laboratory  | `downloadIsisData msl $ISISDATA` |
    | Mars Odyssey  | `downloadIsisData odyssey $ISISDATA` |
    | Near  | `downloadIsisData near $ISISDATA` |
    | New Horizons  | `downloadIsisData newhorizons $ISISDATA` |
    | OSIRIS-REx  | `downloadIsisData osirisrex $ISISDATA` |
    | Rolo  | `downloadIsisData rolo $ISISDATA` |
    | Rosetta  | `downloadIsisData rosetta $ISISDATA` |
    | Smart1  | `downloadIsisData smart1 $ISISDATA` |
    | Viking 1 | `downloadIsisData viking1 $ISISDATA` |
    | Viking 2 | `downloadIsisData viking2 $ISISDATA` |
    | Voyager 1 | `downloadIsisData voyager1 $ISISDATA` |
    | Voyager 2 | `downloadIsisData voyager2 $ISISDATA` |

#### Excluding Kernels

You can exclude common kernel subdirectories from your download with the `--no-kernels` flag.  For example, to download only calibration files for the MRO mission:
```sh
downloadIsisData mro ~/data/testdata --no-kernels
```

-----

## ISIS SPICE Web Service

ISIS can retrieve the SPICE data over the internet with a web service.
Using the ISIS SPICE Web Service significantly reduces the size 
of the required downloads from the data area.

??? warning "Not all operations are supported by the SPICE Web Service"

    Some instruments require mission data to be present for **radiometric calibration**, which is not supported by the SPICE Web Server.
    Some programs that are designed to run an image *from ingestion through the mapping phase* do not have an option to use the SPICE Web Service. 

    - **MEX HRSC** is a commonly used unsupported instrument.
    - For info on specific apps/instruments, see the [ISIS Application Docs](https://isis.astrogeology.usgs.gov/Application/index.html).
    
    

### Enabling the Web Service for `spiceinit`

To use this instead of local SPICE data, 
click the `WEB` check box in the `spiceinit` window. 
Or at the command line:
```sh
spiceinit from=<yourimage.cub> web=yes
```

### Skipping Kernel Downloads with `downloadIsisData`

#### --exclude

To skip downloading the SPICE kernels, use the `exclude` argument (like a blacklist) on a mission-specific `downloadIsisData` command.  For example:

    downloadIsisData cassini $ISISDATA --exclude="kernels/**"

#### --include

You can also use the `include` argument (like a whitelist) to partially download specific kernels. For example, to include only `ck`s and `fk`s in your LRO mission download:

    downloadIsisData lro $ISISDATA --include="{ck/**,fk/**}"


## The ISIS Test Data Area

There is an ISISTESTDATA area containing files needed to run some of ISIS's older Makefile-based tests.  See [ISIS Test Data](../../how-to-guides/isis-developer-guides/obtaining-maintaining-submitting-test-data.md) for more info.

## See also

 - [Setting up ISIS data for a new mission](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/setup-isis-data)
