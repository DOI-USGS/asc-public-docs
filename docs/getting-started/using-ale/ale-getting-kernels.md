# Getting Kernels in ALE

Ale has a few options for getting kernels:

1. Search for kernels locally in $ALESPICEROOT or $ISISDATA (default).
1. Search for kernels online.
1. Specify kernels manually...
    a. ...in your command.
    b. ...in a metakernel file.

## Search for Kernels Locally

Searching for a local kernel is the default behavior in ALE.

```sh
isd_generate B10_013341_1010_XN_79S172W.cub
```

???+ warning "Kernel Download and Setup Required"

    For ALE to successfully find kernels locally:

    1. The Kernels for your mission must be downloaded
    1. The $ALESPICEROOT environmental variable must be set.

    See [Setting Up NAIF Data](../../getting-started/using-ale/isd-generate.md#setting-up-naif-data) for more info.

## Search for Kernels Online

Use the -w flag to search for kernels online with the USGS SpiceQL web service.

```sh
isd_generate -w B10_013341_1010_XN_79S172W.cub
```

## Specify Kernels Manually

### Specifying Kernels in an ALE Command

### Specifying Kernels in a Metakernel File

```sh
isd_generate -n -k mro_B10_72W.tm B10_013341_1010_XN_79S172W.cub
```