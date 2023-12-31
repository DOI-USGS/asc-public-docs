# SPICE 

## Introduction 

-----

Once an image has been correctly ingested into ISIS3 (meaning that the
ISIS3 cube label contains all required mission-specific keywords ),
additional navigational and ancillary information (SPICE) is required
in order to calibrate and geometrically/photometrically process the data.
ISIS3 utilizes software supplied by the Navigation and Ancillary Information Facility 
(NAIF).

SPICE ( **S** pacecraft & **P** lanetary ephemerides, **I** nstrument
**C** -matrix and **E** vent kernels) refers to all the information that
is required and computed in order for ISIS3 to map each image onto a
surface with reference to spacecraft position, sun position, instrument
and mission activities.


## SPICEINIT 

-----

The ISIS3 application
[**spiceinit**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
adds the necessary SPICE information to an image cube. It is important
to note that if spiceinit is unsuccessful then further cartographic
processing will not be possible.


### Required Mission Keywords 

At a minimum 'spiceinit' requires SpacecraftName, InstrumentId,
TargetName, StartTime and StopTime. These keywords are loaded at the
ingestion step ([Importing Mission Data](../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md)).

See also: [**Mission Specific
Programs**](http://isis.astrogeology.usgs.gov/Application/index.html)


### ISIS3 SPICE Labels 

  - The information supplied by spiceinit is placed in the
    **Group=Kernels** and **Group=Instrument** label portion of the
    ISIS3 image cube.  
  - Information on the quality of the kernels is added to keywords
    within the Kernels Group "InstrumentPointingQuality" and "InstrumentPositionQuality"
  - SPICE computation results can also be attached to the **blob**
    portion of the ISIS3 image cube (i.e., parameter **ATTACH=TRUE** -
    the current spiceinit default).
  - See also in the ISIS3 Documentation: [**Label
    Dictionary**](http://isis.astrogeology.usgs.gov/documents/LabelDictionary/LabelDictionary.html)


## Camera Pointing 

-----

Spiceinit will load the location and filename of the camera pointing
kernel (CK) in the ISIS3 keyword **InstrumentPointing** .

Which file that is loaded depends on a couple of things:

First, the StartTime of the image must be found within any CK kernel

Secondly, The user can specify what type of CK kernel

  - CKSMITHED - This is considered camera pointing that has been through
    a bundle-adjustment and most likely the most accurate; this level of
    pointing is not often available and might not include the entire
    collection of mission image data.
  - CKRECON - The default ck kernel for spiceinit. This kernel is the
    mission actual and is often improved on by NAIF or the mission
    navigation team.
  - CKPREDICTED - The least desired, but "better than nothing" kernel
    that is most available during real-time on newly acquired mission
    data.
  - CKNADIR - Nadir pointing is computed if no CK kernels exist
    (''Requirements...under construction'')

!!! Tip "Tips:"
    - All parameters above can be set to **=TRUE** and spiceinit will
      search and load in a hierarchical order from c-smithed first to
      predicted last. Be aware if processing multiple files and allowing
      inconsistencies in different ck sources.
    - The **InstrumentPointingQuality** keyword will be added to the
      Kernels Group with a value indicating what quality of camera
      pointing was found and loaded for the input image
      (InstrumentPointingQuality = Reconstructed or Predicted).


## Spacecraft Position 

-----

Spiceinit will load the location and filename of the spacecraft pointing
kernel (SPK) in the ISIS3 keyword **InstrumentPosition** .

Which file that is loaded depends on a couple of things:

First, the StartTime of the image must be found within any SPK kernel

Secondly, The user can specify what type of SPK kernel

  - SPKSMITHED - This is considered camera pointing that has been
    through a bundle-adjustment and most likely the most accurate; this
    level of pointing is not often available and might not include the
    entire collection of mission image data.
  - SPKRECON - The default spk kernel for spiceinit. This kernel is the
    mission actual and is often improved on by NAIF or the mission
    navigation team.
  - SPKPREDICTED - The least desired, but "better than nothing" kernel
    that is most available during real-time on newly acquired mission
    data.

!!! Tip "Tips:"
    - All parameters above can be set to **=TRUE** and spiceinit will
      search and load in a hierarchical order from c-smithed first to
      predicted last. Be aware if processing multiple files and allowing
      inconsistencies in different spk sources.
    - The **InstrumentPositionQuality** keyword will be added to the
      Kernels Group with a value indicating what quality of camera
      pointing was found and loaded for the input image
      (InstrumentPositionQuality = Reconstructed or Predicted).


## Shape Model 

-----

Shape Models are what ISIS intersects imaging rays with. When mapping a pixel from an image to a ground point, ISIS generates a look vector using the camera model and then intersects that ray with the surface to generate a ground point.

The ISIS data area and spiceinit are set up to automatically select an appropriate shape model for most data sets. If want more control over which shape model you use or are working with a new data set, here's the different options available in ISIS.

The most basic type of shape model is an ellipsoid shape model. When using an ellipsoid shape model, ISIS intersects imaging rays with a tri-axial ellipsoid. The ellipsoid radii are defined in the PCK. To use an ellipsoid shape model, set `SHAPE=ELLIPSOID` when running spiceinit.

ISIS also supports Digital Elevation Models (DEMs) as shape models. A DEM is a raster image that defines the local radius at each pixel in the image. DEMs can cover a local region or the entirety of a body. When working with a DEM, make sure that it covers the entire ground range of your data set. Some applications use DEMs that define the height or elevation above a reference ellipsoid, but ISIS only supports DEMs that define the radius so that there is no inconsistency between reference ellipsoids. Before using a DEM, it must first be ingested into an ISIS cube file and then run through the demprep application. Once that is complete, set `SHAPE=USER MODEL=<path to your DEM cube>` when running spiceinit.

Some data sets observe irregular surfaces that cannot be represented by a DEM. Surfaces in these situations are now being represented by Digital Shape Kernels (DSKs). You can select a DSK shape model in spiceinit the same way you can select a DEM, set `SHAPE=USER MODEL=<path to your DSK file>`. ISIS supports shape models for DSKs in three different ways: CSPICE, Embree, and Bullet.

By default, ISIS will use the low-level CSPICE routines to intersect imaging rays with the DSK. The CSPICE routines do not load the surface shape into memory, so they use less memory but are limited by your I/O speeds. We recommend having the DSK file on a local, high-speed SSD when using the CSPICE routines.

Both Embree and Bullet load the surface shape from the DSK file into memory and then use ray casting algorithms to intersect imaging rays with the surface. As such, they require more memory, but are significantly faster than the CSPICE routines. Embree performs floating point intersection operations which have between 6 and 9 significant digits of precision. Bullet performs double precision intersection operations  which have between 15 and 18 significant digits of precision. For rapid analysis and to check processing, some users prefer Embree, but for final products and precision analysis we recommend using Bullet. To select the Embree or Bullet shape model you will need to modify the ShapeModel section of your IsisPreference file.

```
Group = ShapeModel
  RayTraceEngine = Embree
  OnError = Continue
EndGroup
```

or 

```
Group = ShapeModel
  RayTraceEngine = Bullet
  OnError = Continue
EndGroup
```

If you run spiceinit with a DSK shape model and a RayTraceEngine specified in your IsisPreference file, then that will be added to the output cube's label. The cube will use the selected shape model from that point on. This can be overwritten by your current IsisPreference file contents. See the table below for more details:

|IsisPreference at spiceinit | IsisPreference now      | shape model used |
| -------------------------- | ----------------------- | ---------------- |
| No ShapeModel Group        | No ShapeModel Group     | CSPICE           |
| No ShapeModel Group        | RayTraceEngine = Bullet | Bullet           |
| No ShapeModel Group        | RayTraceEngine = Embree | Embree           |
| RayTraceEngine = Embree    | No ShapeModel Group     | Embree           |
| RayTraceEngine = Embree    | RayTraceEngine = CSPICE | CSPICE           |
| RayTraceEngine = Embree    | RayTraceEngine = Embree | Embree           |
| RayTraceEngine = Embree    | RayTraceEngine = Bullet | Bullet           |
| RayTraceEngine = Bullet    | No ShapeModel Group     | Bullet           |
| RayTraceEngine = Bullet    | RayTraceEngine = CSPICE | CSPICE           |
| RayTraceEngine = Bullet    | RayTraceEngine = Embree | Embree           |
| RayTraceEngine = Bullet    | RayTraceEngine = Bullet | Bullet           |


## References & Related Resources

-----

1.  About [NAIF](http://naif.jpl.nasa.gov/naif/index.html)
2.  About [NAIF SPICE](http://naif.jpl.nasa.gov/naif/aboutspice.html)
3.  [NAIF Software Toolkit](http://naif.jpl.nasa.gov/naif/toolkit.html)
