# ALE SPICE Data Setup & Driver Types

<div class="grid cards" markdown>

-   [:octicons-arrow-left-24: ALE - Getting Started](../../getting-started/using-ale/index.md)

-   [:octicons-arrow-right-24: ALE on the Command Line](../../getting-started/using-ale/isd-generate.md)

</div>

## To use ALE, you will need:

- [ ] An [ALE Installation](https://github.com/DOI-USGS/ale/blob/main/README.md).
- [ ] An image ([Locating Image Data](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md)) 
  formatted according to your driver type.
- [ ] ***SPICE Data according to your driver type***.

## ALE Driver Types and their requirements

=== "IsisLabel + NaifSpice"
    
    For **NaifSpice + IsisLabel** Drivers, you will need:
    
    - An image [imported](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md#introduction-to-importing) into [ISIS](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md) cube (.cub) format with a [`-2isis` app](https://isis.astrogeology.usgs.gov/Application/index.html).

    - NAIF SPICE Kernels (See [Setting up NAIF Data](#setting-up-naif-data) below).


=== "IsisLabel + IsisSpice"

    For **IsisLabel + IsisSpice** Drivers, you will need:
    
    - An image [imported](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md#introduction-to-importing) into [ISIS](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md) cube (.cub) format with a [`-2isis` app](https://isis.astrogeology.usgs.gov/Application/index.html),

    - AND the resulting ISIS cube must be [`spiceinit`ed](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html) with `spiceinit from=<your.cub>`.
    

=== "Pds3Label + NaifSpice"

    For **NaifSpice + Pds3Label** Drivers, you will need:

    - An image in PDS3 format

    - NAIF SPICE Kernels (See [Setting up NAIF Data](#setting-up-naif-data) below).

-----

??? info "How Each Driver Mixin Works - *NaifSpice, IsisSpice, IsisLabel, and Pds3Label*"

    **NaifSpice** drivers use the NAIF Kernels to look up spice data to an image, while **IsisSpice** drivers depend on an ISIS cube already having spice data attached with `spiceinit`.

    **IsisLabel** drivers use images in the ISIS cube (.cub) format, while **Pds3Label** drivers use images in the PDS format.

    There are 3 possible combinations of these mixins: `IsisLabel + NaifSpice`, `IsisLabel + IsisSpice`, and `Pds3Label + NaifSpice`.

    **NaifSpice + IsisLabel** is the most commonly used driver type, but you can check the ALE driver to find out if IsisLabel + IsisSpice or Pds3Label + NaifSpice drivers are available instead or in addition:

    1. Look at the [drivers in the ALE repository](https://github.com/DOI-USGS/ale/tree/main/ale/drivers). 
    1. Click on the drivers for the spacecraft that captured your image.
    1. Find the class for your sensor, and look for NaifSpice, IsisSpice, IsisLabel, or Pds3Label next to the class name.

    There may be a class for both NaifSpice and IsisSpice; in that case you can use either, or use the `-n` or `-i` argument to specify which one to use.  You might use `-i` for IsisSpice if you want to avoid re-`spiceinit`ing a .cub.

    By default, ALE will run through different drivers until either it finds the first one that works (at which point it will use that driver and complete its run), or all drivers fail.

## Setting Up NAIF Data

For use of NAIF Data with ISIS, see the [ISIS Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md).  For use of NAIF data with ALE, continue below.

### Downloading NAIF SPICE Data with wget

!!! warning ""

    [[NAIF SPICE Data Home](https://naif.jpl.nasa.gov/naif/data.html)] 
    [[Getting Spice Kernels from the NAIF Server](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/Tutorials/pdf/individual_docs/34_naif_server.pdf)]

    If you have enough space, NAIF recommends downloading the entire dataset for your spacecraft, detailed below.
    Otherwise, you can try subsetting the data as detailed in the [NAIF Server tutorial](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/Tutorials/pdf/individual_docs/34_naif_server.pdf).
    You will need `wget`, a common download utility.

    Let's download the Clementine archive as a test.

    1.  Find your mission on the [PDS SPICE Archives](https://naif.jpl.nasa.gov/naif/data_archived.html) and copy the **Archive Link**.

        -  The url for the Clementine archive is:    
           `https://naif.jpl.nasa.gov/pub/naif/pds/data/clem1-l-spice-6-v1.0/clsp_1000`

    1.  `cd` into you spice folder, the folder you have or will set as `$ALESPICEROOT`.

    1.  Piece together the `wget` command.
        1.  Starting with this base command... (Don't run it yet!)    
            `wget -m -nH --cut-dirs=5 -R 'index.html*'`

        1.  add the url...  
            `-nv https://naif.jpl.nasa.gov/pub/naif/pds/data/clem1-l-spice-6-v1.0/`

        1.  then filter by the directory path (last half of url)...    
            `-I pub/naif/pds/data/clem1-l-spice-6-v1.0/`

        1.  and download into this folder (just the folder at the end of the url).    
            `-P clem1-l-spice-6-v1.0/`

    1. Run the complete wget command:

        ```sh
        wget -m -nH --cut-dirs=5 -R 'index.html*' -nv https://naif.jpl.nasa.gov/pub/naif/pds/data/clem1-l-spice-6-v1.0/clsp_1000 -I pub/naif/pds/data/clem1-l-spice-6-v1.0/clsp_1000 -P clem1-l-spice-6-v1.0/
        ```

    -----
    *The Mars Reconnaissansce Orbiter (MRO) archive, which corresponds to the B10_013341_1010_XN_79S172W 
    used in the related tutorials, is 340 GB.  A subset of SPICE data is provided in the tutorials, but if you will be 
    working with more MRO images, and you have the space, you can try downloading the MRO Spice data.*

### Setting $ALESPICEROOT

!!! warning ""

    When you are using a NaifSpice Driver, ALE looks under the `$ALESPICEROOT` directory for SPICE Kernels.
    You can echo it to see if it is set.

    ```sh
    echo $ALESPICEROOT
    ```

    To work with MRO images for example, you might download the MRO NAIF SPICE Kernels to a data drive.
    If your directory structure looks like `/Volumes/data/spice-data/mro-m-spice-6-v1.0/mrosp_1000`, 
    then you should set `$ALESPICEROOT` like:

    ```sh
    export ALESPICEROOT=/Volumes/data/spice-data
    ```

### Setting the Path Value in a metakernel

!!! warning ""

    When using a NaifSpice Driver, $ALESPICEROOT must point to the relevant NAIF SPICE Data, 
    and the metakernel within that data must be set.

    ```sh
    isd_generate -n -v B10_013341_1010_XN_79S172W.cub
    ```

    If the path value in your metakernel has not been set, you may get an error like this:

    ```sh
    File B10_013341_1010_XN_79S172W.cub: No Such Driver for Label
    ```

    Look up further in the verbose data, and if an unset metakernel is causing the problem, you will find something like:

    ```sh
    Trying <class 'ale.drivers.mro_drivers.MroCtxIsisLabelNaifSpiceDriver'>
    Failed:
    ================================================================================

    Toolkit version: CSPICE_N0067

    SPICE(NOSUCHFILE) --

    The first file './data/lsk/naif0012.tls' specified by KERNELS_TO_LOAD in the file /Volumes/data/spice-data/mro-m-spice-6-v1.0/mrosp_1000/extras/mk/mro_2009_v14.tm could not be located.
    ```
    
    Open that .tm file (`mro_2009_v14.tm`), and change the PATH_VALUES line to point to your data; the folder containing folders for lsk, pck, sclk, fk, ik, spk, ck, etc...
    
    ```
    PATH_VALUES     = ( './data' )
    ```
    
    if your `$ALESPICEROOT` is `/Volumes/data/spice-data`, and you are working with an MRO image, you might change it to:

    ```
    PATH_VALUES     = ( '/Volumes/data/spice-data/mro-m-spice-6-v1.0/mrosp_1000/data' )
    ```

    Now save the metakernel try again, and, if your SPICE Data is correctly configured, you should not see the same error:

    ```sh
    isd_generate -n -v B10_013341_1010_XN_79S172W.cub
    ```