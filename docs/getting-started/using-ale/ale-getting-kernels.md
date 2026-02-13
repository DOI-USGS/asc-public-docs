# Specifying Kernels in ALE (isd_generate)

Ale has a few options for getting kernels:

1. Search for kernels locally in $ALESPICEROOT (default).
1. Search for kernels online.
1. Specify kernels manually.

## Search for Kernels Locally

Searching for a local kernel is the default behavior in ALE's isd_generate.  Just input your cube's name, no need for additional flags.

```sh
isd_generate B10_013341_1010_XN_79S172W.cub
```

???+ warning "Kernel Download and Setup Required"

    For ALE to successfully find kernels locally:

    1. The NAIF Kernels for your mission must be downloaded
    1. The $ALESPICEROOT environmental variable must be set to point to the NAIF Data.
    1. The metakernel for your cube in the NAIF Data must be setup.

    See [Setting Up NAIF Data](../../getting-started/using-ale/isd-generate.md#setting-up-naif-data) for more info.

## Search for Kernels Online

Use the -w flag to search for kernels online with the USGS SpiceQL web service.  This is a good option if you don't want to download and setup kernels locally on your computer.

```sh
isd_generate -w B10_013341_1010_XN_79S172W.cub
```

## Specify Kernels Manually

To specify kernels in ALE on the command line, use a metakernel file.  In the metakernel file, in the data section (which starts at `\begindata`):

1. Set `PATH_VALUES` to the directory containing the kernels
1. List the kernels under `KERNELS_TO_LOAD`.  
   (Use the value of `PATH_SYMBOLS` to point to the directory you specified in `PATH_VALUES`)

*You can also specify single kernel file or a cube to use as the kernels. But typically, you will need to use a metakernel file to list multiple kernels, for the sake of complete information in the ISD you are generating.*

```sh
isd_generate -k mro_B10_72W.tm B10_013341_1010_XN_79S172W.cub
```

???+ quote "Metakernel Format"

    This metakernel has a path value of `.`, which tells it to look for other kernels in its own folder.  You could change . to another location if the rest of your kernels were somewhere else.

    ```
    ...
    metakernel information section
    ...

    \begindata

       PATH_VALUES     = ( '.' )

       PATH_SYMBOLS    = ( 'KERNELS' )

       KERNELS_TO_LOAD = (
                           '$KERNELS/naif0012.tls'
                           '$KERNELS/pck00008.tpc'
                           '$KERNELS/mro_sclkscet_00082_65536.tsc'
                           '$KERNELS/mro_v16.tf'
                           '$KERNELS/mro_ctx_v11.ti'
                           '$KERNELS/B10_013341_1010_XN_79S172W_0.bsp'
                           '$KERNELS/B10_013341_1010_XN_79S172W_1.bsp'
                           '$KERNELS/mro_sc_psp_090526_090601_0_sliced_-74000.bc'
                           '$KERNELS/mro_sc_psp_090526_090601_1_sliced_-74000.bc'
                         )

    \begintext
    ```