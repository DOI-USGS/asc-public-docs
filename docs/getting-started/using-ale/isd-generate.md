
# Generating an ISD with isd_generate

!!! success "Goal"

    Generate Instrument Support Data (ISD) for an image with ALE's `isd_generate.py`

## Prerequisites

You will need three things before you can generate an ISD from an image:

- [Installation of ISIS](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md)
- [Installation of ALE](https://github.com/DOI-USGS/ale?tab=readme-ov-file#setting-up-dependencies-with-conda-recommended)
- An Image in ISIS format with SPICE data:
    - [Locate an Image](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md)
    - [Ingest the Image into ISIS](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md#introduction-to-importing)
    - Add Spice Data to the image with [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)*
    - Download [SPICE data](https://naif.jpl.nasa.gov/naif/data.html) and set `$ALESPICEROOT`*

??? question "* Does my image use NAIF SPICE or ISIS SPICE?"

    NAIF SPICE is more common than ISIS SPICE, but you can check the ALE driver to find out. 
    
    1. Look at the [drivers in the ALE repository](https://github.com/DOI-USGS/ale/tree/main/ale/drivers). 
    1. Click on the drivers for the spacecraft that captured your image.
    1. Find the class for your sensor, and look for NaifSpice or IsisSpice next to the class name.
        - There may be a class for both NaifSpice and IsisSpice; in that case you can use either, or use the `-n` or `-i` argument to specify which one to use.
    
    ### NAIF SPICE

    You may need to [download NAIF SPICE data](https://naif.jpl.nasa.gov/naif/data.html) for the spacecraft/sensor that captured your image.
    You can set the `$ALESPICEROOT` environmental variable to tell ALE where to look for 
    the NAIF SPICE data you downloaded:
    ```
    export ALESPICEROOT=path/to/naif/spice/data
    ```

    ### ISIS SPICE

    You may need to use ISIS's [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html) 
    to attach spice data to the image before generating an ISD with ALE.



## Using isd_generate

The basic usage of isd_generate is as follows:

```sh
isd_generate [--arguments] [your-isis-cube-name].cub
```

To run isd_generate with no arguments on a cub named M1229488338LE.cub:

```sh
isd_generate M1229488338LE.cub
```

### Output

Upon a successful run of `isd_generate`, an ISD file will be generated.
By default, this is your image's name, with a .json file extension (i.e. `M1229488338LE.json`).
You can specify a different filename with the `--out` (`-o`) argument, as detailed below.

When using the `--verbose` (`-v`) argument, the ISD will be printed to standard output, 
following the program run information.


-----

!!! bug "Troubleshooting"

    - [ ] Is your image in ISIS format?
    - [ ] Does it have SPICE data attached (if required by driver)?
    - [ ] Do you have SPICE data downloaded and `$ALESPICEROOT` set (if required by driver)?

    Use the verbose (`-v`) argument to troubleshoot and see why ALE might not be recognizing your image.
    Check for info about the failure under `Trying <class 'ale.drivers.[X]_drivers...'>` where [X] is 
    ALE's abbreviation for the spacecraft/sensor that captured your image.


## Arguments

### Output File

`-o`, `--out` [filename]

:   Optional output file.  If not specified, this will be set to 
    the input filename with its final suffix replaced with .json. 
    If multiple input files are provided, this option will be ignored 
    and the default strategy of replacing their final suffix with 
    .json will be used to generate the output file paths.

`-c`, `--compress`

:   Output a compressed isd json file with .br file extension. 
    Ale uses the brotli compression algorithm. 
    To decompress an isd file run: 
    `python -c "import ale.isd_generate as isdg; isdg.decompress_json('/path/to/isd.br')"`

### ALE Processing Settings and Info

`-v`, `--verbose`

:   Display extra information as program runs.

`--version`

:   Shows ALE version number

`--max_workers` [integer]

:   If more than one file is provided to work on, this program 
    will engage multiprocessing to parallelize the work.  This 
    multiprocessing will default to the number of processors on the 
    machine.  If you want to throttle this to use less resources on 
    your machine, indicate the number of processors you want to use.

### Spice Data

`-k`, `--kernel` [filename]

:   Typically this is an optional metakernel file, care should be 
    taken by the user that it is applicable to all of the input 
    files.  It can also be a single ISIS cube, which is sometimes 
    needed if the input file is a label file.

`-i`, `--only_isis_spice`

:   Only use drivers that read from spiceinit'd ISIS cubes.

`-n`, `--only_naif_spice`

:   Only use drivers that generate fresh spice data.

### Spatial Settings

`-l`, `--local`

:   Generate local spice data, an isd that is unaware of itself relative
    to target body. This is largely used for landed/rover data.

`-N`, `--nadir`

:   Generate nadir spice pointing, an isd that has pointing 
    directly towards the center of the target body.

