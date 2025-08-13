# Working with Mars Reconnaissance Orbiter CTX Data

<div class="grid cards" markdown>

- [:octicons-arrow-left-24: The MRO Mission](index.md)

</div>

!!! quote inline end ""

    ![](assets/200px-P01_001472_1747_XI_05S146W_small.png)

    CTX Observation (Orbit 1472)

CTX collects data simultaneously with the HiRISE camera and CRISM
spectrometer. As the name suggests, CTX provides the wider context for
the data collected by the other two instruments. Scientists use images
from the other instruments to examine the details of Mars, but CTX
allows a better understanding of the terrain that encompasses these
details.

From an altitude of approximately 300 kilometers above Mars, CTX returns
surface images that are 30 kilometers across, with pixels representing 6
meters of the Martian surface.

??? abstract "CTX Instrument Technical Details"

    - Color: Grayscale
    - Typical Dimensions: 30km * 160km
    - Pixel Dimensions: 5064px wide, varying lengths
    - Focal Length: 350mm
    - FOV: 6 degrees
    - Image Sensor: 5064 pixels-wide charge coupled device (CCD) line array
    - Bands: 500-800nm

    The team lead and supplier of CTX is Mike Malin from
    [MSSS](https://www.msss.com/all_projects/mro-ctx.php).

??? abstract "Reference & Related Resources"

    - [CTX Camera - Malin Space Science Systems](https://www.msss.com/all_projects/mro-ctx.php)

    - [MRO Mission - PDS Cartography and Imaging Node](https://pds-imaging.jpl.nasa.gov/portal/mro_mission.html)

    - [MRO - NASA Science](https://science.nasa.gov/mission/mars-reconnaissance-orbiter/)

        - [MRO Science Instruments - NASA Science](https://science.nasa.gov/mission/mars-reconnaissance-orbiter/science-instruments/)

    - [Calibration and Performance of the MRO CTX Camera - Mars Journal](http://marsjournal.org/contents/2013/0001/)

    - [The Mars Global CTX Mosaic: A Product of Information-Preserving Image Data Processing - AGU](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2024EA003555)


## Processing CTX Data 

CTX has one CCD, so processing its data is similar to other instruments. 
Making an uncontrolled CTX observation mosaic includes:

- **Level 0 - Data Ingestion**
- **Level 1 – Radiometric Calibration and Noise Removal**
- **Level 2 - Map Projection**


## Level 0 Processing - Data Acquisition & Ingestion 

The steps of level 0 processing are:

1.  **Obtaining Images** - Finding and downloading CTX image data.
2.  **Ingestion** - Converting an EDR image to the ISIS cube format.
3.  **Adding SPICE Data** - Helps compute geometric properties.

### Obtaining Images

??? info "CTX File Naming Conventions"

    Deciphering the filename can be helpful both when searching for data and
    also when managing files on your system. The PDS naming convention for
    EDRs is.

        # A typical CTX image filename
        P01_001472_1747_XI_05S146W.IMG

        # We will break it down as follows...
        PAA_BBBBBB_CCCC_XD_EEFGGGW.IMG

    Where:

    - **PAA**: Mission phase.  `P01`
    - **BBBBBB**: Orbit number.  `001472`
    - **CCCC**: Represests the center latitude in units of 0.1
        degree. 0 degrees is the descending equator crossing; 90 is the south
        pole; 180 is ascending equator crossing; and 270 is the north pole.  `1747`
    - **XD**: Command mode, ***XI*** for ITL or ***XN*** for NIFL.  `XI`
    - **EE**: Planned center latitude.  `05`
    - **H**: Latitude, ***N*** for north or ***S*** for south.  `S`
    - **BBBW** Planned center longitude in positive west. `146W`



??? info "Searching the PDS Image Atlas"

    The [PDS Image Atlas IV](https://pds-imaging.jpl.nasa.gov/beta/search?gather.common.mission=mro&gather.common.instrument=CTX&gather.common.target=MARS) 
    can search for CTX images.

    To find CTX images of Mars, filter by:

    - Instrument: `CTX`
    - Target: `Mars`

    You may also want to add other filters, like *Orbit Number*, 
    or use the map panel to draw a bounding box around an area of interest.

    If you find an image you want, but have trouble downloading it, 
    take note of the filename/product ID and try finding it manually on a data volume.


??? info "Browsing by Volume"

    Online Data Volumes offers manual access to the image data archive.

    - [MRO Data Volumes - PDS](https://pds-imaging.jpl.nasa.gov/volumes/mro.html)
    - [MRO CTX PDS Archive - USGS](https://pdsimage2.wr.usgs.gov/Mars_Reconnaissance_Orbiter/CTX/)


### Ingesting CTX Data 

#### Importing CTX EDR images into ISIS

??? info "About EDR IMG and ISIS cube formats"

    In order to work with CTX data in ISIS, the CTX EDR file must be
    converted to an ISIS cube file so ISIS programs can read and process
    the data.

    EDR files should always have a file extension of .IMG. These files
    contain the image data as well as text describing the image data and the
    state of the instrument at the time the image was taken. The text is in
    the form of a standard PDS label located at the beginning of the file.
    Only the info needed by other ISIS programs is transferred from the PDS
    label to the ISIS cube label.  See examples of each below.

    ??? quote "Example PDS Label"

            FILE_NAME = "P01_001472_1747_XI_05S146W.IMG"
            RECORD_TYPE = FIXED_LENGTH
            RECORD_BYTES = 5056
            FILE_RECORDS = 7169
            LABEL_RECORDS = 1
            ^IMAGE = 2
            SPACECRAFT_NAME = MARS_RECONNAISSANCE_ORBITER
            INSTRUMENT_NAME = "CONTEXT CAMERA"
            INSTRUMENT_HOST_NAME = "MARS RECONNAISSANCE ORBITER"
            MISSION_PHASE_NAME = "PSP"
            TARGET_NAME = MARS
            INSTRUMENT_ID = CTX
            PRODUCER_ID = MRO_CTX_TEAM
            DATA_SET_ID = "MRO-M-CTX-2-EDR-L0-V1.0"
            PRODUCT_CREATION_TIME = 2007-05-18T22:41:04
            SOFTWARE_NAME = "makepds05 $Revision: 1.7 $"
            UPLOAD_ID = "UNK"
            ORIGINAL_PRODUCT_ID = "4A_04_100500DD00"
            PRODUCT_ID = "P01_001472_1747_XI_05S146W"
            START_TIME = 2006-11-19T04:01:27.976
            STOP_TIME = 2006-11-19T04:01:41.429
            SPACECRAFT_CLOCK_START_COUNT = "0848376106:209"
            SPACECRAFT_CLOCK_STOP_COUNT = "N/A"
            FOCAL_PLANE_TEMPERATURE = 291.8 <K>
            SAMPLE_BIT_MODE_ID = "SQROOT"
            OFFSET_MODE_ID = "196/187/185"
            LINE_EXPOSURE_DURATION = 1.877 <MSEC>
            SAMPLING_FACTOR = 1
            SAMPLE_FIRST_PIXEL = 0
            RATIONALE_DESC = "Escarpment with slope streaks"
            DATA_QUALITY_DESC = "OK"
            ORBIT_NUMBER = 1472
            OBJECT = IMAGE
            LINES = 7168
            LINE_SAMPLES = 5056
            LINE_PREFIX_BYTES = 0
            LINE_SUFFIX_BYTES = 0
            SAMPLE_TYPE = UNSIGNED_INTEGER
            SAMPLE_BITS = 8
            SAMPLE_BIT_MASK = 2#11111111#
            CHECKSUM = 16#D3B47773#
            END_OBJECT = IMAGE
            END

    ??? quote "Example ISIS Cube Label"

            Object = IsisCube
              Object = Core
                StartByte   = 65537
                Format      = Tile
                TileSamples = 128
                TileLines   = 128
            
                Group = Dimensions
                  Samples = 5000
                  Lines   = 7168
                  Bands   = 1
                End_Group
            
                Group = Pixels
                  Type       = SignedWord
                  ByteOrder  = Lsb
                  Base       = 0.0
                  Multiplier = 1.0
                End_Group
              End_Object
            
              Group = Instrument
                SpacecraftName        = Mars_Reconnaissance_Orbiter
                InstrumentId          = CTX
                TargetName            = Mars
                MissionPhaseName      = PSP
                StartTime             = 2006-11-19T04:01:27.976
                SpacecraftClockCount  = 0848376106:209
                OffsetModeId          = 196/187/185
                LineExposureDuration  = 1.877 <MSEC>
                FocalPlaneTemperature = 291.8 <K>
                SampleBitModeId       = SQROOT
                SpatialSumming        = 1
                SampleFirstPixel      = 0
              End_Group
            
              Group = Archive
                DataSetId           = MRO-M-CTX-2-EDR-L0-V1.0
                ProductId           = P01_001472_1747_XI_05S146W
                ProducerId          = MRO_CTX_TEAM
                ProductCreationTime = 2007-05-18T22:41:04
                OrbitNumber         = 1472
              End_Group
            
              Group = BandBin
                FilterName = BroadBand
                Center     = 0.65 <micrometers>
                Width      = 0.15 <micrometers>
              End_Group
            
              Group = Kernels
                NaifFrameCode       = -74021
                LeapSecond          = $base/kernels/lsk/naif0008.tls
                TargetAttitudeShape = $base/kernels/pck/pck00008.tpc
                TargetPosition      = Table
                InstrumentPointing  = Table
                Instrument          = Null
                SpacecraftClock     = $mro/kernels/sclk/MRO_SCLKSCET.00022.65536.tsc
                InstrumentPosition  = Table
                InstrumentAddendum  = $mro/kernels/iak/mroctxAddendum001.ti
                ShapeModel          = $base/dems/molaMarsPlanetaryRadius0002.cub
              End_Group
            End_Object



!!! example "Converting a CTX EDR image to an ISIS cube with [`mroctx2isis`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mroctx2isis/mroctx2isis.html)"
    
    ```sh
    mroctx2isis from=P01_001472_1747_XI_05S146W.IMG to=P01_001472_1747_XI_05S146W.cub
    ```

    The **mroctx2isis** program also converts the image header, prefix and suffix data to ISIS Binary Large OBject (BLOBs). 
    See the [`mroctx2isis` ISIS app docs](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mroctx2isis/mroctx2isis.html) 
    for other related parameters.

#### Adding SPICE Data

??? info "About SPICE"

    An important capability of ISIS is the ability to *geometrically* and
    *photometrically* characterize pixels in raw planetary instrument
    images. Information such as latitude, longitude, phase angle, incidence
    angle, emission angle, local solar time, sun azimuth, and a many other
    pixel characteristics can be computed.

    To compute this information, the SPICE (**S**pacecraft and **P**lanetary ephemeredes, **I**nstrument **C**-matrix and **E**vent
    kernel) kernels must first be determined for the image. These kernels maintain the spacecraft position and
    orientation over time as well as the target position and instrument specific operating modes.

    For more info, see [Spice Overview :octicons-arrow-right-24:](../../../concepts/spice/spice-overview.md)

!!! example "Adding SPICE info with [`spiceinit`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)"

    ```sh
    spiceinit FROM=P01_001472_1747_XI_05S146W.cub
    ```

    To add SPICE information to your cube, run 
    [`spiceinit`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
    on the image so that camera/instrument-specific applications
    (e.g., `cam2map` , `campt` , `qview` ) will have the information
    they need to work properly. Generally, you can simply run `spiceinit`
    with your input filename and no other parameters.


## Level 1 Processing - Radiometric Calibration and Noise Removal

Creating a level 1 image involves:

  - **Radiometric calibration** of the data so we have an image
    representative of an ideal image acquired by a camera system with
    perfect radiometric properties. Values in the resulting image
    represent the reflectance of the surface (I/F).
  - **Removal of systematic noise** from the image. For CTX, this noise
    appears as vertical striping, referred to as furrows, which occur
    under certain observing conditions, and tonal mismatches among the
    data sets collected by adjacent channels in a CCD.



### Radiometric Calibration 

??? info "About Radiometric Calibration of CTX Data"

    The CTX detector has a total of 5000 pixels, divided among an A channel
    and a B channel. The pixels alternate between the two channels: ABABABAB, etc. 
    Images from CTX may or may not include all pixels in the acquired image.

    There are special summing modes that are utilized
    on-board the spacecraft to average detector pixels to combine them into
    a single output pixel value. The value of the ISIS label keyword,
    SpatialSumming, indicated the number of samples that were summed and
    averaged to result in the pixel values stored in the file. 

    Dark current pixels are taken for each line and stored in the ISIS cube as a table,
    named "CTX Prefix Dark Pixels". During the calibration process, a dark
    current value is subtracted from the pixels in the image. The exact dark
    current value that is applied is dependent on the summing mode. You can
    also select the IOF parameter and output the pixel values as relative
    reflectance.

    See Also: [General Overview of Radiometric Calibration :octicons-arrow-right-24:](../../../concepts/image-processing/overview-of-radiometric-calibration.md)


!!! example "Radiometrically calibrating an image with [`ctxcal`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/ctxcal/ctxcal.html)"
    
    ```sh
    ctxcal from=P01_001472_1747_XI_05S146W.cub to=P01_001472_1747_XI_05S146W.cal.cub
    ```

### Noise And Artifacts 

#### Removing Vertical Striping Due to Even/Odd Detector Readout 

!!! warning ""

    If the image has a **Summing Mode** of `2`, then do not run `ctxevenodd`.

!!! example "Removing Vertical Striping with [`ctxevenodd`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/ctxevenodd/ctxevenodd.html)"

    ```sh
    ctxevenodd from=P01_001472_1747_XI_05S146W.cal.cub to=P01_001472_1747_XI_05S146W.destripe.cub
    ```

<div class="grid cards" markdown>

- See Also: [General Overview of Noise and Artifacts :octicons-arrow-right-24:](../../../concepts/image-processing/overview-of-noise-and-artifacts.md)

</div>


## Map Projecting Images 

### Map Templates

To project an image to a map projection, 
set up a list of parameters based on the projection you wish to use.
Use [`maptemplate`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/maptemplate/maptemplate.html) 
(or a text editor) to set up a **map template** defining the mapping parameters for the projection.

??? quote "Example Map Template" 

    The following is an example of a map template for defining the projection
    of an image of Mars to the sinusoidal projection.

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

### Projecting an Image 

[`cam2map`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html) 
converts a camera (instrument) image to a map projected
image. `cam2map` will automatically compute defaults for most of the
mapping parameters, so you only need to define a subset of the
parameters in your map template (e.g. ProjectionName).

!!! example "Projecting an image with `cam2map`"

    *With the cube so far as `*.lev1.cub` and a* **map template** *(like above) saved to `sinu.map`.*

    ```sh
    cam2map from=P01_001472_1747_XI_05S146W.lev1.cub map=sinu.map to=P01_001472_1747_XI_05S146W.sinu.cub
    ```
    
!!! note "Notes on `cam2map`"

    - Your cube must be data from an ISIS-supported mission.

    - The same map template **can be reused** for multiple images 
      by **removing** the lat/lon range parameters from your map template:
        - MinimumLatitude
        - MaximumLatitude
        - MinimumLongitude
        - MaximumLongitude

    - `cam2map` will **automatically calculate** parameter values,
      as long as the **projection name** is in the map template.

    - If planning to mosaick the projected images, make sure
        the **PixelResolution** is the same for all images. Some projections
        also require the **CenterLongitude** and **CenterLatitude** to be
        the same for a mosaic.

## Further Resources

<div class="grid cards" markdown>

- [CTX Data in AMES Stereo Pipeline :octicons-arrow-right-24:](https://stereopipeline.readthedocs.io/en/latest/examples/ctx.html)

- [Empirical Brightness Control & Equalization :octicons-arrow-right-24:](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2019EA001053)

</div>

