# Using ISIS - Comprehensive Docs

Everything you need to know about using ISIS.  
*Something Missing? 
Check the [:material-github: Docs Issue Board](https://github.com/DOI-USGS/asc-public-docs/issues) and/or 
[:material-file-edit-outline: edit this page.](https://github.com/DOI-USGS/asc-public-docs/edit/main/docs/getting-started/using-isis-first-steps/isis-comprehensive.md)*

## Setup
    
!!! quote ""

    **This install_isis script sets up miniforge, ISIS, and the data area.** [:octicons-code-24: Source](https://github.com/DOI-USGS/ISIS3/blob/dev/isis/scripts/install_isis.sh). [:octicons-info-24: Details](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md).

    ```sh
    bash <(curl https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh)
    ```

-   [Setting up the Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md)  
    *In case you didn't during installation, or need data for additional missions.*

## Fundamentals

!!! warning inline end ""

    :star: - Start with these to learn ISIS quickly.

- [:star: Using ISIS - Introduction](introduction-to-isis.md)
- [Locating and Ingesting Image Data](locating-and-ingesting-image-data.md)
- [:star: Add SPICE Data](adding-spice.md)
- [Exporting ISIS Data](exporting-isis-data.md)
- [FAQ](isis-faq.md)

## Missions

- [Missions Hub](../../concepts/missions/index.md)
- The MRO pages have in-depth guides for processing,  
  from import to map-projecting/mosaicking:
    - [:star: MRO HiRISE](../../concepts/missions/mro/hirise/index.md#cartographic-processing-hirise-data)
    - [:star: MRO CTX](../../concepts/missions/mro/ctx-data.md)

## General Image Processing

- [Spatial Filters](../../concepts/image-processing/the-power-of-spatial-filters.md)
- [Noise and Artifacts](../../concepts/image-processing/overview-of-noise-and-artifacts.md)
- [Removing Striping Noise](../../how-to-guides/image-processing/removing-striping-noise.md)
- [General Utility with `fx`](../../how-to-guides/image-processing/general-utility-with-fx.md)
- [Radiometric Calibration](../../concepts/image-processing/overview-of-radiometric-calibration.md)

## ISIS Concepts

- [ISIS Cube Format](../../concepts/isis-fundamentals/cube-format.md)
- [Bit Types](../../concepts/isis-fundamentals/bit-types.md)
- [Core & Base Multipliers](../../concepts/isis-fundamentals/core-base-and-multiplier.md)
- [Special Pixels](../../concepts/isis-fundamentals/special-pixels.md)
- [Command Line Usage](../../concepts/isis-fundamentals/command-line-usage.md)

## Cartography

- [SPICE Kernels](../../concepts/spice/spice-overview.md)
- [Camera Geometry](../../concepts/camera-geometry-and-projections/camera-geometry.md)
- [Map Projections](../../concepts/camera-geometry-and-projections/learning-about-map-projections.md)

## Advanced

- [Image Registration](../../concepts/control-networks/image-registration.md)
- [Automatic Registration](../../concepts/control-networks/automatic-registration.md)
- [Autoseed](../../concepts/control-networks/autoseed.md)
- [Multi-Instrument Registration](../../concepts/control-networks/multi-instrument-registration.md)

## Developing ISIS/Contributing Code

- [Developing ISIS with cmake](../../how-to-guides/isis-developer-guides/developing-isis3-with-cmake.md)
- [ISIS Programming Exercise 1: `mirror`](../../how-to-guides/isis-developer-guides/exercise-1.md)
- [ISIS Programming Exercise 2: `diff`](../../how-to-guides/isis-developer-guides/exercise-2.md)

## Demos and Workshops

- [Interactive Demos](../../how-to-guides/demos/isis-demos.md)
- [Online Workshops (Archive)](../../getting-started/archive/isis-demos-and-workshops.md)