# ALE Quick Start

This document provides a set of steps to get setup for generating Image Support
Data (ISD) for an image.

## Installation

Install ALE with conda. (If you don't have conda, [get it via miniforge](https://conda-forge.org/download/).)
```sh
    conda create -n ale
    conda activate ale  # Activate your environment every time you need to use ALE.
    conda install -c conda-forge ale
```

## Data

Planetary imagery is not archived with sufficient data to generate an ISD
from only the image and its label. ALE currently supports two supplementary data
sources: ISIS cubes with attached SPICE, and NAIF SPICE Kernels.

For ISIS cubes with attached SPICE (the
[`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
application has been run on them) then ALE will use the data embedded in the
cube file.

For PDS3 images or ISIS cubes without attached
SPICE, download the required NAIF SPICE Kernels for your
image. We recommend using the metakernels provided in the
[PDS kernel archives](https://naif.jpl.nasa.gov/naif/data_archived.html).
Specify the path for ALE to search for metakernels via the
`ALESPICEROOT` environment variable. This should be set to the directory where
you have the PDS kernel archives downloaded. An example structure would be

* $ALESPICEROOT
    * mro-m-spice-6-v1.0
    * dawn-m_a-spice-6-v1.0
    * mess-e_v_h-spice-6-v1.0

See `ale.base.data_naif.NaifSpice.kernels` for more information about how to
specify NAIF SPICE kernels.

## `load` and `loads`

The `ale.drivers.load` and `ale.drivers.loads` functions are
the main interface for generating ISDs. Simply pass them the path to your image
file/label and they will attempt to generate an ISD for it.

```py
import ale

image_label_path = "/path/to/my/image.lbl"
isd_string = ale.loads(image_label_path)
```
  
