
# ALE on the Command Line - `isd_to_kernel`

## Overview

The `isd_to_kernel` command-line tool converts ISD (Image Support Data) JSON files into SPICE kernel formats. This enables you to extract spacecraft position, pointing, and other metadata from ISDs and write them as reusable SPICE kernels that can be used with NAIF SPICE toolkit applications or loaded into other missions.

## Prerequisites

Before you can convert an ISD to a kernel, you will need:

- [ALE](https://github.com/DOI-USGS/ale?tab=readme-ov-file#setting-up-dependencies-with-conda-recommended)
- An ISD JSON file (see [Generating an ISD](isd-generate.md) to create one)
- SPICE Data appropriate for your mission (see [ALE SPICE Data Setup](ale-naif-spice-data-setup.md))

*See [Getting Started with ALE](index.md) for an overview of ALE Installation, NAIF SPICE Data Setup, and other ALE Topics.*

-----

## Using isd_to_kernel

The basic usage of `isd_to_kernel` is as follows:

```sh
isd_to_kernel -f [isd-file] -k [kernel-type] [--options]
```

See the [Arguments](#arguments) section below for details on all available options.

### Examples

!!! example "Creating an SPK Kernel"

    Generate a spacecraft position kernel (SPK) from a CTX ISD:

    ```sh
    isd_to_kernel -f B10_013341_1010_XN_79S172W.json -k spk
    ```

    This creates an SPK kernel named `B10_013341_1010_XN_79S172W.bsp` containing the spacecraft positions.

!!! example "Creating a CK Kernel"

    Generate a spacecraft pointing kernel (CK) from a HiRISE ISD:

    ```sh
    isd_to_kernel -f hirise_observation.json -k ck
    ```

    This creates a CK kernel named `hirise_observation.bc` containing the spacecraft orientation data.

!!! example "Creating Text Kernels"

    For text-based kernels (IK, FK, etc.), you can provide keyword data as a JSON object:

    ```sh
    isd_to_kernel -k ik -d '{"INS_ID": "-12345", "INS_FOV": "0.5"}' -o instrument.ti
    ```

!!! example "Specifying a Custom Output File"

    To specify a custom output filename instead of using the ISD filename:

    ```sh
    isd_to_kernel -f ctx_isd.json -k spk -o ctx_custom.bsp
    ```

!!! example "Adding Comments to Kernels"

    Add descriptive comments to the kernel header for documentation:

    ```sh
    isd_to_kernel -f ctx_isd.json -k ck -c "Updated pointing from bundle adjustment 2026-07-10"
    ```

    Comments are written to the kernel's comment area.

!!! example "Using web SpiceQL"

    Use the `--web` flag to retrieve supporting kernels from the SpiceQL web service instead of a local SPICE data area. This lets you create a kernel without downloading ISIS data or setting `$ALESPICEROOT`. This is especially useful for CK creation, which needs supporting kernels (LSK, SCLK) to convert the ISD's pointing data:

    ```sh
    isd_to_kernel -f ctx_isd.json -k ck --web
    ```

    !!! tip "Only binary kernels need SPICE data"

        Binary kernel (CK and SPK) generation requires SPICE data, so use `--web` or set a local `$ALESPICEROOT` data area for those. Text kernels (FK, IK, LSK, etc.) are built from the ISD alone and need neither.

??? info "Verbose Output"

    Use verbose mode to see detailed information about the conversion process:

    ```sh
    isd_to_kernel -f ctx_isd.json -k spk -v
    ```

    This displays information about kernel loading, data extraction, and file writing.

-----

## Arguments

### Required Arguments

`-f`, `--isd_file` [filename]

:   Input ISD JSON file to extract kernel information from.

`-k`, `--kernel_type` [type]

:   Kernel type to create from ISD. Acceptable kernel types are:
    
    - **`spk`** - Spacecraft ephemeris (position and velocity)
    - **`ck`** - Spacecraft orientation (pointing)  
    - **`fk`**, **`ik`**, **`lsk`**, **`mk`**, **`pck`**, **`sclk`** - Text kernels

### Output Options

`-o`, `--outfile` [filename]

:   Optional output file. If not specified, this will be set to the ISD file name with the appropriate kernel extension.

    ??? note "Output File"

        **Binary Kernels (SPK, CK)**

        When creating binary kernels, SPK kernels use the `.bsp` extension and CK kernels use the `.bc` extension.

        **Text Kernels (FK, IK, LSK, etc.)**

        Text kernels use extensions like `.tf`, `.ti`, `.tls`, etc. depending on the kernel type.

`-c`, `--comment` [text]

:   Optional comment string to append to the kernel's comment area. Useful for documenting the source, processing steps, or version information.

`--overwrite`

:   Allow overwriting an existing kernel file. Without this flag, the tool will fail if the output file already exists.

### Text Kernel Data

`-d`, `--data` [json]

:   JSON object of keywords for text kernels only. Provide as a JSON string, e.g., `'{"KEY1": "VALUE1", "KEY2": 123}'`.

### SPICE Configuration

`--web`

:   Enable web-based SpiceQL search for kernel information. This allows `isd_to_kernel` to retrieve necessary supporting kernels from the SpiceQL web service rather than requiring local kernel files.

### Other Options

`-v`, `--verbose`

:   Display information as the program runs, including kernel loading, data extraction, and file writing progress.

-----

## Verifying Generated Kernels

Once you have created a kernel, you can verify its contents using NAIF SPICE [utilities](https://naif.jpl.nasa.gov/naif/utilities.html):

### Inspecting SPK Kernels

Use `brief` to view the coverage and bodies in an SPK file:

```sh
brief test_spk.bsp
```

### Inspecting CK Kernels

Use `ckbrief` to view the pointing coverage in a CK file:

```sh
ckbrief test_ck.bc
```

### Viewing Comments

Use `commnt` to read the header comments:

```sh
commnt -r test_spk.bsp
```

-----

## Use Cases

### Archiving Observation Data

Convert ISDs to SPK and CK kernels to archive spacecraft state information in a standardized SPICE format:

```sh
isd_to_kernel -f observation_2026_07_10.json -k spk -c "Archive SPK for observation XYZ"
isd_to_kernel -f observation_2026_07_10.json -k ck -c "Archive CK for observation XYZ"
```

### Bundle Adjustment Results

After performing bundle adjustment, create updated pointing kernels from the refined ISD:

```sh
isd_to_kernel -f refined_pointing.json -k ck -c "Updated pointing from bundle adjustment v2.0" -o refined.bc
```

### Sharing Position Data

Create SPK kernels from ISDs to share spacecraft position information with collaborators who need SPICE-compatible formats:

```sh
isd_to_kernel -f mission_positions.json -k spk -o shared_ephemeris.bsp --overwrite
```

-----

## Troubleshooting

!!! bug "Common Issues"

    **Error: "Could not complete isd_to_kernel task"**
    
    - [ ] Verify your ISD file is valid JSON and contains the required fields
    - [ ] Check that you have SPICE data available *if* creating CK or SPK
    - [ ] Use `-v` (verbose mode) to see detailed error messages
    
    **Error: "Output file already exists"**
    
    - [ ] Add the `--overwrite` flag to allow overwriting existing files
    - [ ] Or specify a different output filename with `-o`
    
    **SPK/CK kernel appears empty or invalid**
    
    - [ ] Verify the ISD contains position/pointing data
    - [ ] Check that the ISD was generated correctly using `isd_generate`
    - [ ] Use verbose mode (`-v`) to check for warnings during kernel creation

-----

## Related Topics

<div class="grid cards" markdown>

- [Generating an ISD :octicons-arrow-right-24:](isd-generate.md)

    Create ISD files from images using `isd_generate`

- [ALE SPICE Data Setup :octicons-arrow-right-24:](ale-naif-spice-data-setup.md)

    Learn about setting up SPICE data for ALE

- [SPICE Overview :octicons-arrow-right-24:](../../concepts/spice/spice-overview.md)

    Learn more about SPICE and kernel types

</div>
