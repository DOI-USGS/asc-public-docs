
# ALE on the Command Line - `isd_generate`

<div class="grid cards" markdown>

-   [:octicons-arrow-left-24: ALE SPICE Data Setup](../../getting-started/using-ale/ale-naif-spice-data-setup.md)

-   [:octicons-arrow-right-24: ALE in Python](../../getting-started/using-ale/ale-python-load-loads.md)

</div>

*See [Getting Started with ALE](../../getting-started/using-ale/index.md) for an overview of ALE Installation, NAIF SPICE Data Setup, and other ALE Topics.*


## Using isd_generate

The basic usage of isd_generate is as follows:

```sh
isd_generate [--arguments] [your-image-name]
```

-----

!!! example "isd_generate default run, no arguments"

    To run isd_generate with no arguments on a .cub named [B10_013341_1010_XN_79S172W.cub](../../getting-started/data/image_to_ground/B10_013341_1010_XN_79S172W.cub):

    ```sh
    isd_generate B10_013341_1010_XN_79S172W.cub
    ```

-----

### Output

Upon a successful run of `isd_generate`, an uncompressed ISD file will be generated.
By default, this is your image's name, with a .json file extension (i.e. `B10_013341_1010_XN_79S172W.json`).

!!! example "Specifying Output"

    [Example .cub](../../getting-started/data/image_to_ground/B10_013341_1010_XN_79S172W.cub)

    To output to a specified filename, use `--out` or `-o`.  This example outputs a 'MyIsd.json' file:

    ```sh
    isd_generate -o MyIsd.json B10_013341_1010_XN_79S172W.cub
    ```

    To output a brotli-compressed ISD, use `--compress` or `-c`.  This results in a .br file:

    ```sh
    isd_generate -c B10_013341_1010_XN_79S172W.cub
    ```

    To uncompress an ISD (converts .br to .json):

    ```sh
    python -c "import ale.isd_generate as isdg; isdg.decompress_json('B10_013341_1010_XN_79S172W.br')"
    ```


### Verbosity

When using the `--verbose` (`-v`) argument, program run information 
is printed to the console, followed by the text of the ISD.  This can be helpful when [troubleshooting](#troubleshooting).


### NAIF SPICE Data and Kernels

To ensure the use of a NaifSpice Driver (and NAIF SPICE Data) to generate an ISD, use the `--only_naif_spice` (`-n`) flag.  If you have a `spiceinit`ed .cub and you want to avoid re-`spiceinit`ing it or using NAIF SPICE Data, use the `--only-isis-spice` (`-i`) flag.

When using an NAIF SPICE Data, you can specify a metakernel using the `--kernel` (`-k`) argument, followed by the path to your metakernel.

!!! example "Using a NaifSpice Driver with a metakernel"

    Folder with example NAIF Data: 
    [[Download as .zip](../../getting-started/data/image_to_ground/image-to-ground.zip)] 
    [[View in GitHub](https://github.com/DOI-USGS/asc-public-docs/tree/main/docs/getting-started/data/image_to_ground)]

    This folder contains NAIF Data consisting of the various kernels 
    necessary to generate an ISD for the `B10_013341_1010_XN_79S172W` image.
    You can open the kernels ending in `.t*` and view their contents as text files. 
    The kernels ending in `.b*` are binary kernels; 
    [NAIF SPICE Utilities](https://naif.jpl.nasa.gov/naif/utilities.html) 
    can be used to investigate their contents.

    `mro_B10_72W.tm` is the metakernel file. 
    If you open it, you can see it is a list of other kernels. 
    If you needed to use specific kernels, you could copy a metakernal and edit the list.

    To use a NaifSpice Driver and specify a metakernal:

    ```sh
    isd_generate -n -k mro_B10_72W.tm B10_013341_1010_XN_79S172W.cub
    ```

## Troubleshooting

!!! bug "Troubleshooting Checklist"

    - [ ] Is your image in ISIS format (or PDS format for Pds3Label Drivers)?
        - [use](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md#introduction-to-importing) 
          a [`-2isis` app](https://isis.astrogeology.usgs.gov/Application/index.html) to convert images to ISIS format.
    - [ ] Do you have [spice data set up](../../getting-started/using-ale/ale-naif-spice-data-setup.md)?
        - If using a NaifSpice Driver:
            - [ ] Spice Data [Downloaded from NAIF](../../getting-started/using-ale/ale-naif-spice-data-setup.md#downloading-naif-spice-data-with-wget)?
            - [ ] [`$ALESPICEROOT` set](../../getting-started/using-ale/ale-naif-spice-data-setup.md#setting-alespiceroot)?
            - [ ] [Metakernel `PATH_VALUE` set](../../getting-started/using-ale/ale-naif-spice-data-setup.md#setting-the-path-value-in-a-metakernel)?
        - If using an IsisSpice Driver:
            - [ ] Spice Data attached to your image by [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)?
    - [ ] Check what's wrong with a `--verbose` run.

-----
### Investigating with --verbose

Use the `--verbose` (`-v`) argument to troubleshoot and see why ALE might not be recognizing your image.
Check for info about the failure under `Trying <class 'ale.drivers.[X]_drivers...'>` where [X] is 
ALE's abbreviation for the spacecraft/sensor that captured your image.

```sh
isd_generate -v B10_013341_1010_XN_79S172W.cub
```

If requesting assistance, it may be helpful to post what version of ALE you have, shown with:

```sh
isd_generate --version
```

-----




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

