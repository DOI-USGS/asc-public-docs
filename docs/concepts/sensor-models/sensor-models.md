# Sensor Models

This document is intended to provide information related to sensor models by presenting an introduction to sensor models, a brief explanation of the Community Sensor Model (CSM), and an overview of several ASC software packages that directly relate to the instantiation and exploitation of sensor models.

## Introduction to Sensor Models

### Reference Systems and Reference Frames

Before describing sensor models, it is first necessary for the reader to have an understanding of reference systems and reference frames.

In order to describe the location of an object, it is necessary to identify a point of reference by which the object can be localized. One might think of the object with respect to their own position, but it is also possible to describe the object as being at a certain location on a grid, or even some angular distance from a known location.  Despite the differences in the methods of localizing the object, each of these descriptions produces a valid representation of the object's location with respect to some point of reference.  By specifying an origin about which other objects can be oriented, we begin to form the basis of a "reference system," which establishes a coordinate system that can be used to describe positions. In practice, a reference system is required to provide a point of origin, a set of axes (with an associated plane in which angular measurements can be made), and a fixed point about which the reference frame is oriented.  Some examples of common photogrammetric reference systems are as follows:

- Image Reference System: a 2-dimensional (column/row or line/sample) reference system with a defined (0,0) origin, typically at the upper-left of the the frame
- Distorted Focal Plane Reference System: a 2-dimensional (x,y) reference system nominally represented in Cartesian space and measured millimeters.  This reference system is used to account for the distortion in an image reference system.
- Sensor Reference System: a 3-dimensional (x,y,z) reference system in which the z axis typically follows the sensor's boresight (if it is an optical sensor) as well as x and y axes that are traditionally parallel to the sensor's x and y axes.
- Spacecraft Reference System: a 3-dimensional (x,y,z) reference system in which the origin is centered on the spacecraft's center of mass. Axes are often represented using 𝜔, 𝜙, 𝜅, which are analogous to yaw, pitch, and roll, but instead of representing axial rotations with respect to onboard navigation, they are expressed with respect to axes of an arbitrary coordinate system.
- Body Centered Body Fixed (BCBF): a 3-dimensional (x,y,z) reference system in which the origin is centered on the target's center of mass.

It is important to note that a reference system does not provide a description of an object's location, but it instead provides a _means_ for describing locations.  When locations are described using a reference system, the result is a "coordinate reference frame," which offers information related to an object's position, orientation, and velocity at a single instant in time.

!!! INFO "Reference System vs Reference Frame"
    A __reference system__ provides an origin, axes / planes, and a fixed point that allows for the description of an object.  A __reference frame__ is a description within the context of that reference system, and provides the location of an object at a given moment in time.

Finally, reference frames often have dependencies on other reference frames, which results in a "frame chain" that must be calculated. For example, consider a common scenario in which a camera is intended to record an image of a planetary body.  The camera is mounted on a gimbal, which is mounted on the spacecraft.  In order to move from the image plane to a BCBF system, it is necessary to know the location of the camera and the planetary body.  However, in order to know the location of the camera, it is necessary to know the extrinsics not only of the camera, but also of the gimbal and the spacecraft to which it is mounted.  The dependency chain that is formed is known as a "frame chain," and the entire chain of extrinsics must be calculated in order to accurately model the objects' relative locations.


### Sensor Models
Briefly, a sensor model encapsulates a sensor's geometric information. In this context, "geometric information" refers to two classes of information -- interior (intrinsic) and exterior (extrinsic).  Intrinsic information describes information that is internal to the sensor, such as focal length,  resolution, distortion, etc. Extrinsic information relates to the sensor's physical position, velocity, and orientation, which is to say that extrinsic information may be used answer the question "where is the sensor and where is it pointing."

@TODO expand this section, include rigorous and rational models, uses of sensor models 

!!! NOTE
    The overarching goal of a sensor model is to provide a means for moving between and among a variety of reference frames, which is a necessary step in facilitating geolocation and other geodetic processes.


## The Community Sensor Model

Because the only requirement of a sensor model is that it models a sensor's geometric information, the design and implementation of a sensor model largely remains open-ended.  Of particular importance is the sensor's interface, i.e. what information is required to create the model and what information is produced by the model.  Without a concrete interface specification, each sensor model may require and provide its own set of information, which makes it incredibly difficult to facilitate interoperability between sensor models. In order to address these concerns about interoperability, the US defense and intelligence community established the Community Sensor Model (CSM) working group, which is responsible for developing and maintaining a set of standards upon which sensor models can be implemented.  The resulting CSM standard describes an application programming interface (API) for multiple sensor types.

Alone, a CSM is of little practical use. The standard defines an interface but does not define where necessary sensor metadata should be sourced, the format of said metadata, or the implementation of the photogrammetric algorithms used by the sensor. Therefore, a CSM exists within a broader ecosystem. First, some external capability or method must be used to generate image support data (ISD) that can be used to parameterize a CSM. Then, the CSM can parse and use the ISD to extract the parameters (interior and exterior orientation) necessary to perform photogrammetric operations (as defined by the CSM API). Finally, a SET is likely used to orchestrate the pieces of the CSM ecosystem and exploits said pieces in order to use the sensor for some desired operation. (@TODO citation)

!!! INFO "CSM -- Quick Definition"
    The CSM is a standard that defines an API for sensor models, thereby providing a common structure that guarantees interoperability of any sensor models that adhere to the standard.

## The ASC Sensor Model Ecosystem
The Astrogeology Science Center has created and maintains a suite of software packages that provide end-to-end processing for sensor models, including a metadata specification, CSM-compliant sensor model implementation, and tools to leverage those sensor models for scientific processing.

### USGS Community Sensor Model (USGSCSM)
The USGS Community Sensor Model is a concrete implementation of sensor models according to the standards described in the CSM.  Where the CSM is the set of rules and standards that guides the creation of sensor models, the USGSCSM is a library of sensor models that adheres to those rules.  The USGSCSM library provides generic instances of sensor models for instantaneous (framing) cameras, time-dependent (line-scan) cameras, push-frame cameras, synthetic aperature radar (SAR), and projected sensor models.  Additionally, USGSCSM provides an extensible plugin architecture that allows for additional, interface-compliant sensor models to be dynamically loaded.

@TODO Introduce ISDs

Sensor models implemented within USGSCSM are stateful in the sense that their underlying geometries can be modified.  Moreover, it is possible to save a model's current state to a _state string_ so that a future model can be instantiated with that exact model state.  This is an important capability when performing incremental modifications via a process like bundle adjustment, particularly if the user decides to undo those adjustments or share the modified state with collaborators.

@TODO is it necessary to discuss reasons for modifying geometries?


!!! INFO "USGSCSM -- Quick Definition"
    USGSCSM is a software library that provides generic, CSM-compliant sensor model implementations.  USGSCSM sensor models can be instantiated via an ISD or a USGSCSM state string.

### Abstraction Library for Ephemerides (ALE)
The Abstraction Library for Ephemerides (ALE) provides the tools and information necessary to derive and access a sensor's exterior information.  ALE provides a suite of instrument-specific drivers that combine information from a variety of metadata formats (image labels), sensor types, and data sources into a single CSM compliant format. It is important to note that ALE is responsible for abstracting away intermediate reference frames between the body-centered, body-fixed frame and the sensor frame.

@TODO discuss what drivers, sensor types, labels, etc. are available in ALE.  Potentially describe future efforts

!!! INFO "ALE -- Quick Definition"
    ALE is a software package that relies on a collection of instrument-specific drivers in order to calculate and provide access to camera extrinsics.  This information is output in a standard ISD format that provides all the information required to instantiate a CSM sensor model.

### Integrated Software for Imagery and Spectrometry (ISIS)
ISIS is a software suite that comprises a variety of imaging analysis tools ranging from traditional tools like contrast, stretch, image algebra, and statistical analysis tools to more complex processes such as mosaicking, photometric modeling, noise reduction, and bundle adjustment.  In addition to these analysis tools, ISIS provides a standard format (.cub) for images and their associated metadata as well as a means for converting non-standardized images to the .cub format. 

#### Cub Files and 2Isis Programs

#### Bundle Adjustment / Jigsaw
ISIS's Jigsaw program provides a bundle adjustment algorithm, which is a full 3-dimensional scene reconstruction algorithm that

1. estimates the 3 dimensional coordinates of ground points
1. estimates sensor extrinsics
1. minimizes error between the reconstructed scene and observed point locations

Bundle adjustmnet is a critical part of the sensor model ecosystem in that it can be used to iteratively refine and correct a model's geometry, which allows for more accurate transitions between reference frames, i.e. correctly geolocating a ground point from an image plane.

@TODO More information related to bundle adjustment can be found at ... 

## Extended Sensor Model Ecosystem
### SOCET Geospatial eXploitation Products (GXP)
### Ames Stereo Pipeline (ASP)


@TODO Create a graphic / flowchart / interface diagram of "requires and provides" to illustrate when/where to use each library.