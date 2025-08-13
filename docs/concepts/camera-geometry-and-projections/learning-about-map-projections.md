# Learning About Map Projections


## What is a Map? 

-----

A map is a two dimensional representation of a three dimensional object
such as a sphere, ellipsoid (egg-shape), or an irregular shaped body.
For planetary maps, these 3-D objects are the planets, their moons, and
irregular bodies such as asteroids. Maps allow scientists and
researchers to analyze and measure characteristics of features on the
body such as area, distance, and direction. See [Map
(Wikipedia)](http://en.wikipedia.org/wiki/Map) for a detailed
description of maps.

<figure markdown>
  ![MOLA](../../assets/map_projections/Mola_of_sheet2a_thumb.jpeg "Example of a map made using data from the Mars Orbiter Laser Altimeter (MOLA)"){ width="100%" }
</figure>


## What is a Map Projection? 

-----

A projection is an algorithm or equation for mapping a three dimensional
body onto a two dimensional surface such as paper, a computer screen, or
in our case, a digital image. There are many different types of
projections.

<figure markdown>
  ![Mercator Projection: The classic Mercator projection places a cylinder (rolled piece of paper) tangent to the equator.](../../assets/map_projections/Mercator.gif){width="100%"}
  <figcaption> Mercator Projection: The classic Mercator projection places a cylinder (rolled piece of paper) tangent to the equator. </figcaption>
</figure>


For additional information on types and properties of map projections
see the [USGS Map Projection Poster](https://pubs.usgs.gov/gip/70047422/report.pdf).


## ISIS3 Supported Projections 

-----

**ISIS3 currently supports the following projections:**

  - Equirectangular
  - Lambert Azimuthal Equal Area
  - Lambert Conformal
  - Lunar Azimuthal Equal Area
  - Mercator
  - Mollweide
  - Oblique Cylindrical
  - Orthographic
  - Planar
  - Point Perspective
  - Polar Stereographic
  - Ring Cylindrical
  - Robinson
  - Simple Cylindrical
  - Sinusoidal
  - Transverse Mercator
  - Upturned Ellipsoid Transverse Azimuthal

**Related Resources**

  - [USGS: Map
    Projections](http://egsc.usgs.gov/isb//pubs/MapProjections/projections.html)
    - descriptions and comparisons of several map projections


## What is a Planetary Image Map? 

-----

A primary capability of ISIS3 is to create map projected images of raw
instrument data. This allows researchers to make fundamental
measurements on and observations about the images.

The following is an example of a single Mars Global Surveyor (MGS) Mars
Orbital Camera (MOC) instrument image that has been transformed to a
planetary image map using the Sinusoidal projection.

| ![MOC image before transformation](../../assets/map_projections/MOC1.jpeg){: style="width:300px;height:300px"} | ![MOC image after sinusoidal transformation](../../assets/map_projections/SinuMOC1.jpeg){: style="width:300px;height:300px"} |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| MOC image before transformation                                       | MOC image after sinusoidal transformation                                           |


## What is a Planetary Image Mosaic? 

-----

Equally as important, ISIS3 allows a collection of raw instrument images
to be projected and stitched together (mosaicked) into large regional or
global maps..



<figure markdown>
  ![Sample\_mosaic\_themis.jpeg](../../assets/map_projections/Sample_mosaic_themis.jpeg "Five Mars Odyssey THEMIS instrument images that have been projected and mosaicked to generate a regional planetary image map using the Sinusoidal projection"){: style="width:100%"}
  <figcaption> Five Mars Odyssey THEMIS instrument images that have been projected and mosaicked to generate\n a regional planetary image map using the Sinusoidal projection </figcaption>
</figure>
 


## Defining a Map in ISIS3 

-----

In order to project an image, characteristics of the map must be
established. They include the latitude/longitude coverage or ground
range, the pixel resolution, the target body radii, latitude and
longitude definitions, and the projection. In ISIS3 we record all of
this information in a Parameter Value Language (PVL) formatted map file.
For example this MGS MOC image was projected using the following:

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
<figure markdown>
  ![SinuMOC1](../../assets/map_projections/SinuMOC1.jpeg){: style="width:100%"}
  <figcaption> Image projected using the above mapfile </figcaption>
</figure>
 

## Target Shape Definition 

-----

The target shape must be defined in order to project an image. The shape
is characterized by the equatorial and polar radii of the body.
Depending on the projection, one or both of these values will be used.
The chart below shows which projections are for a sphere only (use only
the equatorial radius) and which work for ellipsoids:

Marked below are the PVL keywords used to define the target radii, which
must be given in units of meters.

``` 
 Group = Mapping
  TargetName         = Mars
  **EquatorialRadius   = 3396190.0 <meters>**
  **PolarRadius        = 3376200.0 <meters>**
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

| Projection          | Sphere | Ellipsoid |
| ------------------- | ------ | --------- |
| Sinusoidal          | X      |           |
| Simple Cylindrical  | X      |           |
| Equirectangular     | X      |           |
| Polar Stereographic | X      | X         |
| Orthographic        | X      |           |
| Mercator            | X      | X         |
| Transverse Mercator | X      | X         |
| Lambert Conformal   | X      | X         |


### Interactive Planetary Radii Demonstration 


## Latitude Type 

-----

Latitudes can be represented either in **planetocentric** or
**planetographic** form. The planetocentric latitude is the angle
between the equatorial plane and a line from the center of the body. The
**planetographic latitude** is the angle between the equatorial plane
and a line that is normal to the body. In a quick summary, both
latitudes are equivalent on a sphere (i.e., equatorial radius equal to
polar radius); however, they differ on an ellipsoid (e.g., Mars, Earth).

``` 
 Group = Mapping
  TargetName         = Mars
  EquatorialRadius   = 3396190.0 <meters>
  PolarRadius        = 3376200.0 <meters>
  **LatitudeType       = Planetocentric**
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


### Quick Tips 

  - The latitude type will affect how other PVL keywords such as
    MinimumLatitude, CenterLatitude are interpreted.
  - Projections such as Sinusoidal, Simple Cylindrical, and
    Equirectangular will place pixels differently in the image depending
    on the latitude type. Pixel placement for other projections is not
    affected. The LatitudeType keyword must be either **Planetocentric**
    or **Planetographic** .


### Interactive Planetocentric and Planetographic Demonstration 

**PLACE INTERACTIVE DEMO HERE**


## Longitude Direction and Domain 

-----

Two keywords indicate how longitude is defined on the target body and
must be specified. The LongitudeDirection keyword indicates whether
longitude increases to the east or west, that is, positive to the east
or positive to the west. The LongitudeDomain keyword specifies how
longitudes should be interpreted 0° to 360° or -180° to 180°. In both
cases, these specifications affect other keywords and the interpretation
of other keywords, such as MinimumLongitude and CenterLongitude.

The LongitudeDirection keyword must be either PositiveEast or
PositiveWest, while the LongitudeDomain keyword must be 180 or 360.
These keywords are marked in the example below.

``` 
 Group = Mapping
  TargetName         = Mars
  EquatorialRadius   = 3396190.0 <meters>
  PolarRadius        = 3376200.0 <meters>
  LatitudeType       = Planetocentric
  **LongitudeDirection = PositiveEast**
  **LongitudeDomain    = 360**

  ProjectionName     = Sinusoidal
  CenterLongitude    = 227.95679808356

  MinimumLatitude    = 10.766902750622
  MaximumLatitude    = 34.44419678224
  MinimumLongitude   = 219.7240455337
  MaximumLongitude   = 236.18955063342

  PixelResolution    = 426.87763879023 <meters/pixel>
 End_Group
```


### Interactive Longitude Direction of Domain Demonstration 

**PLACE INTERACTIVE DEMO HERE**


## Ground Range 

-----

The ground range defines the extent of the map. That is, the minimum and
maximum latitude/longitude values. Recall that these are in terms of the
latitude system, longitude direction, and longitude domain. In the
keywords below, the keywords marked define the ground range of the map.

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

  **MinimumLatitude    = 10.766902750622**
  **MaximumLatitude    = 34.44419678224**
  **MinimumLongitude   = 219.7240455337**
  **MaximumLongitude   = 236.18955063342**

  PixelResolution    = 426.87763879023 <meters/pixel>
 End_Group
```


### Interactive Ground range demonstration 

**PLACE INTERACTIVE DEMO HERE**


## Pixel Resolution

-----

The pixel resolution defines the size of pixels in a map projected image
in either meters per pixel, or pixels per degree. In the example below
is the marked keyword used to define the pixel resolution in meters per
pixel.

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

  **PixelResolution    = 426.87763879023 <meters/pixel>**
 End_Group
```

Alternatively, the resolution can be defined as pixels per degree. For
example

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

  **Scale              = 138.85641255722 <pixels/degree>**
 End_Group
```


### Interactive Exle of pixel resolutions 

**PLACE INTERACTIVE DEMONSTRATION HERE**


## Projection and Parameters 

-----

The final information required in the map file is the projection for
mapping the body to a two dimensional surface. In addition to the
projection name, projection-specific parameters must be provided. For
example, Sinusoidal requires the CenterLongitude. The following table
outlines the keywords required for each projection:

| ProjectionName                       | CenterLongitude | CenterLatitude | FirstStandardParallel | SecondStandardParallel | ScaleFactor | CenterAzimuth | Distance | CenterRadius |
| ------------------------------------ | --------------- | -------------- | --------------------- | ---------------------- | ----------- | ------------- | -------- | ------------ |
| Equirectangular                      | X               | X              |                       |                        |             |               |          |              |
| LambertAzimuthalEqualArea            | X               | X              |                       |                        |             |               |          |              |
| LambertConformal                     | X               | X              | X                     | X                      |             |               |          |              |
| LunarAzimuthalEqualArea              |                 |                |                       |                        |             |               |          |              |
| Mercator                             | X               | X              |                       |                        |             |               |          |              |
| Mollweide                            | X               |                |                       |                        |             |               |          |              |
| ObliqueCylindrical                   | X               |                |                       |                        |             |               |          |              |
| Orthographic                         | X               | X              |                       |                        |             |               |          |              |
| Planar                               |                 |                |                       |                        |             | X             |          |              |
| PointPerspective                     | X               | X              |                       |                        |             |               | X        |              |
| PolarStereographic                   | X               | X              |                       |                        |             |               |          |              |
| RingCylindrical                      |                 |                |                       |                        |             | X             |          | X            |
| Robinson                             | X               |                |                       |                        |             |               |          |              |
| SimpleCylindrical                    | X               |                |                       |                        |             |               |          |              |
| Sinusoidal                           | X               |                |                       |                        |             |               |          |              |
| TransverseMercator                   | X               | X              |                       |                        | X           |               |          |              |
| UpturnedEllipsoidTransverseAzimuthal | X               |                |                       |                        |             |               |          |              |


## Projecting a Camera Cube 

-----

To project a raw instrument (camera) cube to a map projected image you
must use the ISIS3 program
[**cam2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
. The program allows you to enter a map file to specify the projection,
ground range, resolution, and target definition. If a map file is not
supplied the program will provide the following defaults:

| Parameters                                                                     | Default Value                                                     |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| MinimumLatitude, MaximumLatitude, MinimumLongitude, MaximumLongitude           | Automatically computed using information from the camera model    |
| PixelResolution                                                                | Automatically computed using information from the camera model    |
| EquatorialRadius, PolarRadius, LatitudeSystem, LongitudeRange, LongitudeDomain | Automatically computed using the TargetName from the cube labels. |
| CenterLatitude, CenterLongitude, and other projection specific parameters      | Automatically computed using the middle of the ground range       |


<figure markdown>
  ![Cam2map\_screenshot.jpeg](../../assets/map_projections/Cam2map_screenshot.jpeg "Screenshot of the cam2map application"){: style="width:400px"}
  <figcaption>A screenshot of the cam2map application</figcaption>
</figure>


### Quick Tips 

  - [**cam2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
    requires the input to be a camera cube and therefore ISIS3 must
    support the camera model in order for this program to be successful.
  - [**spiceinit**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
    must be run on the input cube as well.


## Problems at the Longitude Seams 

-----

Problems can occur when working on images that cross the longitude seam.
For example, choosing a map file with:

``` 
 LongitudeDomain = 360
```

A map file combined with an image that was viewed over the 0°/360° seam
will visually look like the following example.

When a camera acquires image data it is stored in a certain domain:

<figure markdown>
  ![Mars\_sphere\_illustration.png](../../assets/map_projections/Mars_sphere_illustration.png "Thumbnail"){: style="width:400px"}
  <figcaption>An illustration of the martian sphere at the 0-360 boundary</figcaption>
</figure>


When an image is created from the acquired data using the same domain,
the correct image is generated:

<figure markdown>
  ![180\_domain\_correct.png](../../assets/map_projections/180_domain_correct.png "Thumbnail"){: style="width:400px"}
  <figcaption>An image acquisition at the boundary using the same domain </figcaption>
</figure>


When an image is created in a different longitude domain, the resulting
image is incorrect (below, this image was scaled down to fit on the
screen):  

<figure markdown>
  ![360\_domain\_incorrect.png](../../assets/map_projections/360_domain_incorrect.png "Thumbnail"){: style="width:400px"}
  <figcaption>An image acquisition at the boundary using a different domain </figcaption>
</figure>


These illustrate the problems that can arise when working with images
that cross the longitude seam.

The
[**cam2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
program has an option which automatically changes the longitude domain
if it detects the image crossing the seam. If you turn this option off,
be aware you can generate large images with mostly NULL data. Note that
a similar problem occurs at the -180°/180° longitude boundary if
LongitudeDomain = 180.


## Power Tip: Reprojecting an Image Map 

-----

Occasionally the need arises to reproject an image map. For example,
converting from a Simple Cylindrical to Sinusoidal projection:


![SimpleCylindrical.png](../../assets/map_projections/SimpleCylindrical.jpeg "Thumbnail"){: style="width:40%"}
![Blue\_right\_arrow.gif](../../assets/map_projections/Blue_right_arrow.gif "Thumbnail"){: style="width:10%"}
![SinusodialProjection.jpeg](../../assets/map_projections/SinusodialProjection.jpeg "Thumbnail"){: style="width:40%"}


Another purpose for reprojecting an image map is to get all the images
with the same projection, parameters, resolution, latitude system, etc
in order to mosaic. For example,

<figure class="inline" markdown>
  ![Simple\_135-110.png](../../assets/map_projections/Simple_135-110.jpeg "Simple Cylindrical"){: style="width:250px;height:150px"}
  <figcaption>Simple Cylindrical</figcaption>
</figure>

<figure class="inline" markdown>
  ![Sinusodial\_135-110.png](../../assets/map_projections/Sinusodial_135-110.jpeg "Sinusoidal"){: style="width:250px;height:150px"}
  <figcaption>Sinusoidal</figcaption>
</figure>


<figure markdown>
  ![Mosaic\_sinus.png](../../assets/map_projections/Mosaic_sinus.jpeg "Sinusoidal Mosaic from Mars"){: style="width:250px;height:150px"}
  <figcaption>Sinusoidal Martian Mosaic</figcaption>
</figure>

-----


The program for reprojecting an image map is
[**map2map**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/map2map/map2map.html)
.


## Power Tip: Making Mosaics 

-----

In order to mosaic a set of cubes they must all be projected in
[**cam2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
or
[**map2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/map2map/map2map.html)
using the SAME pixel resolution, target definition, and projection and
parameters (e.g., center longitude, etc). Note the ground range does not
need to be the same. This is fairly straight-forward as you can project
all the images with the same map file, just leave out the
MinimumLatitude, MinimumLongitude, MaximumLatitude, MaximumLongitude
parameters.

In the example below, we see the mapping file used to project the five
images in the THEMIS mosaic below

``` 
 Group = Mapping
  LatitudeType       = Planetocentric
  LongitudeDirection = PositiveEast
  LongitudeDomain    = 360

  ProjectionName     = Sinusoidal
  CenterLongitude    = 354.0

  PixelResolution    = 100.0 <meters/pixel>
 End_Group
 End
```

<figure markdown>
  ![Mosaic after](../../assets/map_projections/Mosaic_after.jpeg){: style="width:250px"}
  <figcaption>THEMIS Mosaic</figcaption>
</figure>


## Creating a mosaic 

-----

  - The most convenient way to mosaic a number of map projected images
    is to use the
    [**automos**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/automos/automos.html)
    application. Automos reads a list of input images, computes the
    latitude and longitude coverage of all the images and creates the
    output mosaic.

  - The
    [**mapmos**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mapmos/mapmos.html)
    application mosaics one image at a time. Remember to set create=true
    the first time mapmos is run with the first image in order to create
    the output mosaic file.

  - It is possible to mosaic images together by specifying the output
    pixel coordinate placement using the
    [**handmos**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/handmos/handmos.html)
    application. This would be for any ISIS3 image cubes that do not
    have a camera model or cartographic mapping information that is
    required by mapmos and automos.


## Other Hints and Tips 

-----

  - In lieu of using a standard text editor, the programs
    [**maptemplate**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/maptemplate/maptemplate.html)
    or
    [**mosrange**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mosrange/mosrange.html)
    can be used to assist in the building of map files.

  - A map projected image can be used as a map file. For example, a
    Viking and MOC image taken of the same area can be projected by
    running
    [**cam2map**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)
    on the Viking image using the defaults and then the MOC image
    projected using the Viking image as the map file. The MOC image will
    have the same projection, target definition, resolution, and ground
    range so that the images can be easily compared.

  - In general, the pixel resolution of the image map is only accurate
    in certain portions of the image; however, this is entirely
    dependent upon the projection you select. The labels of the output
    cube will have a keyword called TrueScaleLatitude and/or
    TrueScaleLongitude and these represent where the resolution is
    accurate. The accuracy may be true along that meridian or parallel
    or point. Again this depends upon the projection.

  - The output map image size will vary depending on ground range and
    pixel resolution. Care should be taken to ensure your output image
    is not too large. You can check the size of image that will produced
    with a fully-defined map file by using the
    [**mapsize**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mapsize/mapsize.html)
    program.

</div>



