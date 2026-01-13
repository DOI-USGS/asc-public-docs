# Sensor Model Software
This document provides a list of several software packages that implement, manage, or interact with sensor models.  This is not a complete list, and it is only intended to provide examples of how software packages can be used to create or interact with sensor models.

## The ASC Sensor Model Ecosystem
The Astrogeology Science Center has created and maintains a suite of software packages to manage the creation and exploitation of sensor models.  These tools provide an end-to-end pipeline for the creation, management, and exploitation of sensor models, including a metadata specification, a CSM-compliant sensor model implementation, and tools to leverage those sensor models for scientific processing.


### Abstraction Library for Ephemerides (ALE)
!!! INFO "ALE -- Quick Definition"
    ALE is a software package that relies on a collection of instrument-specific drivers in order to calculate and provide access to a camera's interior and exterior orientations.  This information is output in a standard ISD format that provides all the information required to instantiate a CSM sensor model.

The [Abstraction Library for Ephemerides](https://github.com/DOI-USGS/ale/) (ALE) provides the tools and information necessary to derive and access a sensor's interior and exterior orientation.  ALE provides a suite of instrument-specific drivers that combine information from a variety of metadata formats (image labels), sensor types, and data sources into a single CSM compliant format. It is important to note that ALE is responsible for abstracting away intermediate reference frames between the body-centered, body-fixed frame and the sensor frame so that the resulting model can transform directly from the sensor frame to the BCBF frame.

ALE uses a collection of drivers and class mixins to provide an ISD for a variety of sensor models.  [Drivers](https://github.com/DOI-USGS/ale/tree/main/ale/drivers) for many major missions are available in ALE.  Each driver is required to provide support for at least one label type (ISIS or PDS3) and one source of SPICE data (ISIS or NAIF). It is important to note that not every supported mission provides a driver for all combinations of label types and SPICE data sources.

### Integrated Software for Imagery and Spectrometry (ISIS)
[ISIS](https://github.com/DOI-USGS/ISIS3) is a software suite that comprises a variety of image analysis tools ranging from traditional tools like contrast, stretch, image algebra, and statistical analysis tools to more complex processes such as mosaicking, photometric modeling, noise reduction, and bundle adjustment. In addition to these analysis tools, ISIS defines the .cub format which can capture 3-dimensional image data (lines, samples, and bands) as well as image metadata in the form of an image label.  In addition to capturing image data and metadata, .cub files can be augmented with camera geometry information such that elements of the camera model are captured alongside the data.

#### Bundle Adjustment / Jigsaw
ISIS's Jigsaw program provides a bundle adjustment algorithm, which is a full 3-dimensional scene reconstruction algorithm that

1. provides estimates of the 3-dimensional coordinates of ground points
1. provides estimates of the sensor's exterior orientations
1. minimizes error between the reconstructed scene and observed point locations

Bundle adjustmnet is a critical part of the sensor model ecosystem in that it can be used to iteratively refine and correct a model's geometry, which allows for more accurate transitions between reference frames, i.e. correctly geolocating a ground point from an image plane.

More information related to bundle adjustment can be found [here](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/jigsaw/jigsaw.html)

#### ISIS Camera Models
Because ISIS predates the CSM, it contains camera models that are not compliant with the CSM API. ISIS contains camera models for framing, pushframe, linescan, radar, point, and rolling shutter cameras. While ISIS's cameras models are authoritative and mathematically correct, they are only usable within the context of ISIS.  However, ISIS has also been modified to interoperate with CSM cameras.  While ISIS camera models are still actively used, efforts are being taken to replace these proprietary models with CSM compliant models via the USGSCSM library.

### USGS Community Sensor Model (USGSCSM)

!!! INFO "USGSCSM -- Quick Definition"
    USGSCSM is a software library that provides generic, CSM-compliant sensor model implementations.  USGSCSM sensor models can be instantiated via an ISD or a USGSCSM state string.

The [USGS Community Sensor Model](https://github.com/DOI-USGS/usgscsm) is a concrete implementation of sensor models according to the standards described in the CSM.  Where the CSM is the set of rules and standards that guides the creation of sensor models, the USGSCSM is a library of sensor models that adheres to those rules.  The USGSCSM library provides generic instances of sensor models for instantaneous (framing) cameras, time-dependent (line-scan) cameras, push-frame cameras, synthetic aperture radar (SAR), and projected sensor models.  Additionally, USGSCSM provides an extensible plugin architecture that allows for additional, interface-compliant sensor models to be dynamically loaded.

A camera model can be instantiated using image support data (ISD), but the CSM does not describe any particular source or format for that information.  USGSCSM allows ISDs to be formatted as [JSON](https://www.json.org/json-en.html), [NITF](https://pro.arcgis.com/en/pro-app/latest/help/data/nitf/introduction-to-nitf-data.htm), or bytestreams.  Because an ISD is intended to provide all the information necessary to instantiate a sensor model, it is required to contain both interior and exterior orientation information.

Sensor models implemented within USGSCSM are stateful in that their underlying geometries can be modified.  Moreover, it is possible to save a model's current state to a _state string_ so that a future model can be instantiated with that exact model state.  This is an important capability when performing incremental modifications via a process like bundle adjustment or [performing alignment](https://stereopipeline.readthedocs.io/en/latest/tools/pc_align.html) between digital terrain models and reference DTMs or point clouds, particularly if the user decides to undo those adjustments or share the modified state with collaborators.

!!! WARNING "Serial Number"
    Images processed by ISIS and CSM engines will result in different serial number formats. Running `spiceinit` and `csminit` appends the `Instrument` and `CSMInfo` PVL Group to the processed image, respectively. The table below shows the PVL Group name with the child PVL Keywords used to create a serial number.

    | PVL Group in Cube Label     | Serial Number Format                                   |
    | --------------------------- | ------------------------------------------------------ |
    | `Instrument`                | `SpacecraftName`/`InstrumentId`/`SpacecraftClockCount` |
    | `CSMInfo`                   | `CSMPlatformID`/`CSMInstrumentId`/`ReferenceTime`      |


## Extended Sensor Model Ecosystem
This section details several packages that are created and maintained outside the Astrogeology Science Center but are commonly used in conjunction with elements of the ASC sensor model ecosystem.

### SOCET Geospatial eXploitation Products (GXP)
[SOCET GXP](https://www.geospatialexploitationproducts.com/content/socet-gxp/) is a software toolkit used to identify and analyze ground features. While it is possible to use a subset of GXP's capability's with simple sensor models, its core capabilities are largely dependent on rigorous sensor models.  GXP not only includes its own sensor model implementations, but it also allows for external sensor models via CSM plugin support. By leveraging these sensor models, users can perform photogrammetric operations such as triangulation, mensuration, stereo viewing, automated DTM generation, and orthophoto generation.  Unlike ISIS, GXP can be used for both terrestrial and extraterrestrial applications.

### Ames Stereo Pipeline (ASP)

The NASA [Ames Stereo Pipeline](https://stereopipeline.readthedocs.io/en/latest/introduction.html) (ASP) is an open-source toolkit used to create cartographic products from stereographic images captured by satellites, rovers, aerial cameras, and historical images.  ASP is commonly used to create digital elevation models (DEMs), orthographic images, 3D models, and bundle adjusted networks of images ([Beyer, Ross A., Oleg Alexandrov, and Scott McMichael. 2018](https://doi.org/10.1029/2018EA000409)).

While there is considerable overlap in the tools provided by ISIS and ASP, ASP specializes in stereographic imagery, and it provides both terrestrial and non-terrestrial imaging capabilities while ISIS focuses solely on non-terrestrial imagery. ASP adopts the USGSCSM camera model implementation and can therefore easily interoperate with ISIS and the ASC ecosystem.

``` mermaid
graph TD
  A[/Interior Orientation e.g., SPICE instrument kernel/] --> C
  B[/Exterior Orientation e.g., SPICE ephemeris/] --> C
  C[ALE] --> |ISD|D[USGSCSM]
  D <--> |Sensor Model|E[ISIS] & F[SOCET GXP] & G[ASP] --> H(Science Ready Data Product)
```
