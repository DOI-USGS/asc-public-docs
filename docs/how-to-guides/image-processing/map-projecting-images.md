

# Overview of Map Projecting Images 

## Introduction 

Converting a raw instrument/camera cube (Level1) to a map projected
image (Level2) is a fundamental capability of ISIS.  
The default transformation is based on the original viewing geometry of
the observation, relative position of the target body and the definition
of the output map projection.

The main application to project an image is
[**cam2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
.

``` 
 cam2map from=camera_cube_level1.cub to=level2_cube.cub
```


## ISIS Requirements 

-----

  - The image data must be part of a mission instrument 'camera model'
    that is supported within ISIS
  @TODO
  - Proper ingestion of the image data into ISIS ( [**Importing Mission
    Data**](map-projecting-images.md) )
  @TODO
  - Available [**SPICE**](map-projecting-images.md) information for every
    individual image
  - A [**map template**](../../concepts/camera-geometry-and-projections/learning-about-map-projections.md) to define an
    output map projection


## Supported Map Projections 

-----

[**ISIS Supported Projections**](../../concepts/camera-geometry-and-projections/learning-about-map-projections.md)

  - For detailed information about Map Projections within ISIS refer to
    [Learning About Map Projections](../../concepts/camera-geometry-and-projections/learning-about-map-projections.md) .


## Defining an Output Map 

-----


### ISIS Defaults 

ISIS supplies 'basic' map templates that set the ProjectionName
parameter to a supported map projection.

  - The map templates can be found in: $ISISDATA/base/templates/maps/  

  - These map templates can be selected through the MAP parameter in
    'cam2map' (current default is sinusoidal).

  - In conjunction with the supplied map templates; the default for an
    output map are as follows:
    
      - The original [**raw camera geometry**](../../concepts/camera-geometry-and-projections/camera-geometry.md)
      - [**Computed parameters**](../../concepts/camera-geometry-and-projections/learning-about-map-projections.md)
      - The target body is defined in the system defaults which can be
        found in $ISISDATA/base/templates/targets/.


### When to Generate A Custom Defined Map Template 

  - The viewing geometry of an image(s) are important details to
    consider when defining an output map projection.
      - There are a number of applications that report relevant
        [**camera geometry**](../../concepts/camera-geometry-and-projections/camera-geometry.md) information for a given
        image or a list of images.
      - Does your input cover the north or south pole of the body?
      - Do you want your output map to be centered at a specific
        latitude/longitude?
      - Do you plan on mosaicking your images together?
      - An output mosaic (digital image map-DIM) is a major
        consideration before projecting multiple images. Refer to
        [**Making Mosaics**](../../concepts/camera-geometry-and-projections/learning-about-map-projections.md).


#### The Custom Map Template 

In order to project an image to a specific map projection, you'll need
to set up a list of parameters based on the projection you wish to use.
Use the
[**maptemplate**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/maptemplate/maptemplate.html)
application program (or your favorite text editor) to set up a **map
template** file defining the mapping parameters for the projection. The
following is a an example of a map template file for defining the
projection of an image of Mars to the sinusoidal projection:

``` 
 Group = Mapping
  TargetName         = Mars
  EquatorialRadius   = 3396190.0 <meters>
  PolarRadius        = 3376200.0 <meters>
  LatitudeType       = Planetocentric
  LongitudeDirection = PositiveEast
  LongitudeDomain    = 360

  ProjectionName     = Sinusoidal
  CenterLongitude    = 227.95679808356

  MinimumLatitude    = 10.766902750622
  MaximumLatitude    = 34.44419678224
  MinimumLongitude   = 219.7240455337
  MaximumLongitude   = 236.18955063342

  PixelResolution    = 426.87763879023 <meters/pixel>
 End_Group
```

!!! Note "A separate map or map-projected image can be used as a map template file in cam2map. These files are required to have the ISIS Mapping Group keyword labels."


## Camera Distortion Correction 

-----

Within ISIS, the map projection software includes correcting modeled
camera distortions for each supported instrument. When map projecting an
image, the camera distortion correction and geometric transformation are
performed simultaneously so that resampling is performed only once and
pixel resolution loss is minimal.


## Projecting the Image 

-----

The
[**cam2map**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
application converts a camera (instrument) image to a map projected
image. cam2map will automatically compute defaults for most of the
mapping parameters, so you only need to define a subset of the
parameters in your map template (e.g. ProjectionName).

  - If you are projecting several images with the same projection
    parameters, **you can apply the same map template** for all of your
    images simply by removing the latitude longitude range parameters
    (MinimumLatitude, MaximumLatitude, MinimumLongitude, and
    MaximumLongitude) from your map template.
  - **cam2map will automatically calculate parameter values for you** --
    all you *really* need is the projection name in your map template.
  - If you are planning on mosaicking your projected images, make sure
    the **PixelResolution** , **CenterLongitude** and **CenterLatitude**
    is the **same** for all images.


## Related ISIS Applications 

-----

See the following ISIS documentation for information about the
applications you will need to use to perform this procedure:

  - [**maptemplate**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/maptemplate/maptemplate.html)
    : set up a map projection parameter template for map projecting
    cubes
  - [**cam2map**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
    : project a cube to a map projection


