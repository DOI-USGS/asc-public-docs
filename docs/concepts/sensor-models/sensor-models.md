# Sensor Models

This document is intended to provide information related to sensor models by presenting an introduction to sensor models, a brief explanation of the Community Sensor Model (CSM), and an overview of several ASC software packages that directly relate to the instantiation and exploitation of sensor models.

!!! NOTE "Prerequisites"
    An understanding of sensor models requires familiarity with [reference systems and reference frames](../sensor-models/reference-frames.md).

## Introduction to Sensor Models

!!! NOTE
    The overarching goal of a sensor model is to provide a means for moving between and among a variety of reference frames, which is a necessary step in facilitating geolocation and other geodetic processes.

A sensor model provides a mathematical description of the relationship between an object and its representation within the sensor.  Within the context of imaging, this sensor model (or camera model) describes the relationship between a 3-dimensional object and its 2-dimensional representation on an imaging plane.  As a mathematical model, a sensor model is responsible for capturing the sensor's geometric information, which refers to two classes of information -- interior orientation and exterior orientation.  A sensor's interior orientation describes information that is internal to the sensor, such as focal length, resolution, and distortion, and exterior orientation relates to the sensor's physical position, velocity, and pointing information.

It is important to understand that a camera model itself does not capture any information related to an image observation. As a purely mathematical representation, a camera model is responsible for mapping the location of a line/sample on the sensor to a location on the target body, and it is completely agnostic of the information that is captured by the sensor.  More information related to image observations and digital numbers can be found [here](@TODO).

Sensor models that support full transformation from the image plane to the BCBF coordinate system fall into two general classes -- rigorous models and rational functional models.  Rigorous sensor models function by taking ephemeris information (position, orientation, and velocity; Kidder, 2015) with respect to some reference frame and utilize mathematical models to spatialize the image location onto the target body. (@TODO cite).  Rational functional models approximate this information using rational polynomial coefficients without exposing the interior and exterior orientation of the instrument.  Within this document (and the ASC sensor model ecosystem), we focus on rigorous models.


## The Community Sensor Model

Because the only requirement of a sensor model is that it models a sensor's geometric information, the design and implementation of a sensor model largely remains open-ended.  Of particular importance is the sensor's interface, i.e. what information is required to create the model and what information is produced by the model.  Without a concrete interface specification, each sensor model may require and provide its own set of information, which makes it incredibly difficult to facilitate interoperability between sensor models. In order to address these concerns about interoperability, the US defense and intelligence community established the [Community Sensor Model (CSM) working group](https://gwg.nga.mil/gwg/focus-groups/Community_Sensor_Model_Working_Group_(CSMWG).html) , which is responsible for developing and maintaining a set of standards upon which sensor models can be implemented.  The resulting CSM standard describes an application programming interface (API) for multiple sensor types.

Alone, a CSM is of little practical use. The standard defines an interface but does not define where necessary sensor metadata should be sourced, the format of said metadata, or the implementation of the photogrammetric algorithms used by the sensor. Therefore, a CSM exists within a broader ecosystem. First, some external capability or method must be used to generate image support data (ISD) that can be used to parameterize a CSM. Then, the CSM can parse and use the ISD to extract the parameters (interior and exterior orientation) necessary to perform photogrammetric operations (as defined by the CSM API). Finally, a SET is likely used to orchestrate the pieces of the CSM ecosystem and exploits said pieces in order to use the sensor for some desired operation [(Laura et al., 2020)](https://doi.org/10.1029/2019EA000713)

!!! INFO "CSM -- Quick Definition"
    The CSM is a standard that defines an API for sensor models, thereby providing a common structure that guarantees interoperability of any sensor models that adhere to the standard.

## The ASC Sensor Model Ecosystem
The Astrogeology Science Center has created and maintains a suite of software packages that provide end-to-end processing for sensor models, including a metadata specification, CSM-compliant sensor model implementation, and tools to leverage those sensor models for scientific processing.


### Abstraction Library for Ephemerides (ALE)
The [Abstraction Library for Ephemerides](https://github.com/DOI-USGS/ale/) (ALE) provides the tools and information necessary to derive and access a sensor's exterior orientation.  ALE provides a suite of instrument-specific drivers that combine information from a variety of metadata formats (image labels), sensor types, and data sources into a single CSM compliant format. It is important to note that ALE is responsible for abstracting away intermediate reference frames between the body-centered, body-fixed frame and the sensor frame so that the resulting model can transform directly from the sensor frame to the BCBF frame.

ALE uses a collection of drivers and class mixins to provide ISDs for a variety of sensor models.  [Drivers](https://github.com/DOI-USGS/ale/tree/main/ale/drivers) for many major missions are available in ALE.  Each driver is required to provide support for at least one label type (ISIS or PDS3) and one source of SPICE data (ISIS or NAIF). It is important to note that not all drivers currently support all combinations of labels and SPICE data sources.

!!! INFO "ALE -- Quick Definition"
    ALE is a software package that relies on a collection of instrument-specific drivers in order to calculate and provide access to camera exterior orientations.  This information is output in a standard ISD format that provides all the information required to instantiate a CSM sensor model.

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
The [USGS Community Sensor Model](https://github.com/DOI-USGS/usgscsm) is a concrete implementation of sensor models according to the standards described in the CSM.  Where the CSM is the set of rules and standards that guides the creation of sensor models, the USGSCSM is a library of sensor models that adheres to those rules.  The USGSCSM library provides generic instances of sensor models for instantaneous (framing) cameras, time-dependent (line-scan) cameras, push-frame cameras, synthetic aperture radar (SAR), and projected sensor models.  Additionally, USGSCSM provides an extensible plugin architecture that allows for additional, interface-compliant sensor models to be dynamically loaded.

A camera model can be instantiated using image support data (ISD), but the CSM does not describe any particular source or format for that information.  USGSCSM allows ISDs to be formatted as [JSON](https://www.json.org/json-en.html), [NITF](https://pro.arcgis.com/en/pro-app/latest/help/data/nitf/introduction-to-nitf-data.htm), or bytestreams.  Because an ISD is intended to provide all the information necessary to instantiate a sensor model, it is required to contain both interior and exterior orientation information.

Sensor models implemented within USGSCSM are stateful in that their underlying geometries can be modified.  Moreover, it is possible to save a model's current state to a _state string_ so that a future model can be instantiated with that exact model state.  This is an important capability when performing incremental modifications via a process like bundle adjustment, particularly if the user decides to undo those adjustments or share the modified state with collaborators.


!!! INFO "USGSCSM -- Quick Definition"
    USGSCSM is a software library that provides generic, CSM-compliant sensor model implementations.  USGSCSM sensor models can be instantiated via an ISD or a USGSCSM state string.


## Extended Sensor Model Ecosystem
This section details several packages that are created and maintained outside the Astrogeology Science Center but are commonly used in conjunction with elements of the ASC sensor model ecosystem.

### SOCET Geospatial eXploitation Products (GXP)
[SOCET GXP](https://www.geospatialexploitationproducts.com/content/socet-gxp/) is a software toolkit used to identify and analyze ground features. While it is possible to use a subset of GXP's capability's with simple sensor models, its core capabilities are largely dependent on rigorous sensor models.  GXP not only includes its own sensor model implementations, but it also allows for external sensor models via CSM plugin support. By leveraging these sensor models, users can perform photogrammetric operations such as triangulation, mensuration, stereo viewing, automated DTM generation, and orthophoto generation.  Unlike ISIS, GXP can be used for both terrestrial and extraterrestrial applications.

### Ames Stereo Pipeline (ASP)

The NASA [Ames Stereo Pipeline](https://stereopipeline.readthedocs.io/en/latest/introduction.html) (ASP) is an open-source toolkit used to create cartographic products from stereographic images captured by satellites, rovers, aerial cameras, and historical images.  ASP is commonly used to create digital elevation models (DEMs), orthographic images, 3D models, and bundle adjusted networks of images. (@TODO cite https://stereopipeline.readthedocs.io/en/latest/introduction.html)

While there is considerable overlap in the tools provided by ISIS and ASP, ASP specializes in stereographic imagery, and it provides both terrestrial and non-terrestrial imaging capabilities while ISIS focuses solely on non-terrestrial imagery. ASP adopts the USGSCSM camera model implementation and can therefore easily interoperate with ISIS and the ASC ecosystem.

@TODO Create a graphic / flowchart / interface diagram of "requires and provides" to illustrate when/where to use each library.

``` mermaid
graph TD
  A[/ISIS Data/] --> C
  B[/PDS Data/] --> C
  C[ALE] --> |ISD|D[USGSCSM]
  D <--> |Sensor Model|E[ISIS] & F[SOCET GXP] & G[ASP] --> H(Science Ready Data Product)
```