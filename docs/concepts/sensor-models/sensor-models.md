# Sensor Models

This document is intended to provide information related to sensor models by presenting an introduction to sensor models, a brief explanation of the Community Sensor Model (CSM), and an overview of several ASC software packages that directly relate to the instantiation and exploitation of sensor models.

!!! NOTE "Prerequisites"
    An understanding of sensor models requires familiarity with [reference systems and reference frames](../sensor-models/reference-frames.md).

## Introduction to Sensor Models

!!! NOTE "The Purpose of Sensor Models"
    The overarching goal of a sensor model is to provide a means for moving between and among a variety of reference frames, which is a necessary step in facilitating geolocation and other geodetic processes.

A sensor model provides a mathematical description of the relationship between an object and its representation within the sensor.  Within the context of imaging, this sensor model (or camera model) describes the relationship between a 3-dimensional object and its 2-dimensional representation on an imaging plane.  As a mathematical model, a sensor model is responsible for capturing the sensor's geometric information, which refers to two classes of information -- interior orientation and exterior orientation.  A sensor's interior orientation describes information that is internal to the sensor, such as focal length, resolution, and distortion, and exterior orientation relates to the sensor's physical position, velocity, and pointing information.

It is important to understand that a camera model itself does not capture any information related to an image observation. As a purely mathematical representation, a camera model is responsible for mapping the location of a line/sample on the sensor to a location on the target body, and it is completely agnostic of the information that is captured by the sensor.  More information related to image observations and digital numbers will be provided in further documentation.

Sensor models that support full transformation from the image plane to the BCBF coordinate system fall into two general classes -- rigorous models and rational functional models.  Rigorous sensor models function by taking ephemeris information (position, orientation, and velocity) with respect to some reference frame and utilize mathematical models to spatialize the image location onto the target body [(Laura et al., 2020)](https://doi.org/10.1029/2019EA000713).  Rational functional models approximate this information using rational polynomial coefficients without exposing the interior and exterior orientation of the instrument.  Within this document (and the ASC sensor model ecosystem), we focus on rigorous models due to the availability of interior and exterior orientation information.


## The Community Sensor Model

!!! INFO "CSM -- Quick Definition"
    The CSM is a standard that defines an API for sensor models, thereby providing a common structure that guarantees interoperability of any sensor models that adhere to the standard.

Because the only requirement of a sensor model is that it models a sensor's geometric information, the design and implementation of a sensor model largely remains open-ended.  Of particular importance is the sensor's interface, i.e. what information is required to create the model and what information is produced by the model.  Without a concrete interface specification, each sensor model may require and provide its own set of information, which makes it incredibly difficult to facilitate interoperability between sensor models. In order to address these concerns about interoperability, the US defense and intelligence community established the [Community Sensor Model (CSM) working group](https://gwg.nga.mil/gwg/focus-groups/Community_Sensor_Model_Working_Group_(CSMWG).html) , which is responsible for developing and maintaining a set of standards upon which sensor models can be implemented.  The resulting CSM standard describes an application programming interface (API) for multiple sensor types.

Alone, a CSM is of little practical use. The standard defines an interface but does not define where necessary sensor metadata should be sourced, the format of said metadata, or the implementation of the photogrammetric algorithms used by the sensor. Therefore, a CSM exists within a broader ecosystem. First, some external capability or method must be used to generate the inputs (interior and exterior orientations) to the sensor model. Within the CSM, these inputs are known as image support data (ISD).  Then, the CSM can parse and use the ISD to extract the parameters (interior and exterior orientation) necessary to perform photogrammetric operations (as defined by the CSM API). Finally, a SET is likely used to orchestrate the pieces of the CSM ecosystem and exploits said pieces in order to use the sensor for some desired operation [(Laura et al., 2020)](https://doi.org/10.1029/2019EA000713)


!!! INFO "Sensor Model Software"
    There are numerous [software packages](../sensor-models/sensor-model-software.md) that allow for the convenient instantiation, management, and exploitation of those software models.