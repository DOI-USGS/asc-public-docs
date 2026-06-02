# Level0 HiRISE

## Acquiring Data

### Data Products

??? note "EDR and RDR - Use EDR for ISIS."

    The HiRISE team produces two types of [PDS](http://pds.nasa.gov/) data products:

    - **Experiment Data Record** (EDR).  
        HiRISE EDRs contain the data collected by 1 channel (of 28) on the
        instrument and transmitted back to earth.  For one HiRISE observation, 
        there are up to 28 EDR files to download for processing.

    - **Reduced Data Record** (RDR).  
        HiRISE RDRs contain a radiometrically
        calibrated, map projected, mosaic of multiple channels from a single
        observation. These products are stored in [JPEG 2000](http://en.wikipedia.org/wiki/JPEG_2000) format.

???+ warning "One HiRISE EDR Observation contains up to 28 images"

    To make full use of a HiRISE Observation, 
    the processing steps must be run on each of the images in the observation: 
    RED0-9, IR10-11, BG (Blue-Green) 12-13, each with its own channel 0 and 1.

    [![Focalplaneassembly.png](assets/Focalplaneassembly.png)](assets/Focalplaneassembly.png "Focalplaneassembly.png")

    Those interested in a particular wavelength of light might examine a subset of filters. 
    Their wavelengths are **RED**: `570-830nm`, **BG**: `<580nm`, **IR**: `>790nm`

### Search Tools

**Search for HiRISE images** on [PDS Image Atlas III](http://pds-imaging.jpl.nasa.gov/search/mro/hirise)
or [PDS Image Atlas IV (Beta)](https://pds-imaging.jpl.nasa.gov/beta/search?gather.common.instrument=HIRISE).  
*Data products from other instruments and spacecraft are also available here.* 

??? quote "Helpful Search Filters"

    These filters may help narrow your search on the PDS Image Atlas:

    - Instrument (HiRISE)
    - Target (Mars)
    - Product Type (EDR, if processing in ISIS)
    - Filter (Red, IR, or BG)
    - Latitude/Longitude
    - Orbit Number
    - Mission Phase

### Maps

The [HiRISE Browse Map (UofA)](https://www.uahirise.org/hiwish/browse) 
can be used to **find images visually**, or by proximity to named geologic features. 
To show HiRISE images only, check `HiRISE Observations` and uncheck everything else under `Show` below the map. 
The `Find` search box under the map is for named geologic features (like 'Alba Mons'), not filenames of images. 
The map must be zoomed in to show HiRISE observation footprints.

The [PDS Image Atlas IV (Beta)](https://pds-imaging.jpl.nasa.gov/beta/search?gather.common.instrument=HIRISE) 
has a map which can be searched by drawing a box around an area of interest.

### Data Volumes

**Browse for images manually** on the [HiRISE Online Data Volume (UofA)](https://hirise-pds.lpl.arizona.edu/PDS/).

??? info "HiRISE File Naming Conventions"

    Understanding the filename can be helpful when searching for data and
    managing files. The PDS naming convention for channel EDRs is

        AAA_BBBBBB_CCCC_DDD_E.IMG

    Where:

    - **AAA**: mission phase
        - **AEB** Aerobraking
        - **TRA** Transition
        - **PSP** Primary Science Phase
        - **REL** Relay
        - **Exx** Extended missions (if needed)
    - **BBBBBB**: Orbit Number
    - **CCCC**: Target Code 
        -   The latitudinal
            position of the center of the planned observation relative to the
            start of the orbit. The first three digits are whole degrees, the
            fourth digit the fractional degrees rounded to 0.5 degrees. (example
            Mars target codes on a descending orbit: 0900 for 90.0° or
            south-pole, 1800 for 180.0° or equator, 2700 for 270.0° or
            north-pole)
    - **DDD**: Filter/CCD Identifier (RED0-RED9, IR10, IR11, BG12, BG13)
    - **E** - Channel Number (0 or 1)

    For example, *PSP_002733_1880_RED5_0.IMG* is an image centered at
    188.0° latitudinal degrees from the start of the orbit around Mars,
    collected by channel 0 of CCD 5, red filter, during orbit 2733 of the
    primary science phase. See the [Software Interface Specification for
    HiRISE Experiment Data Record
    Products](http://hirise.lpl.arizona.edu/pdf/HiRISE_EDR_RDR_Vol_SIS_2007_05_22.pdf)
    (PDF) for additional details.

    Similarly, the PDS naming convention for RDR mosaicked observation
    products is

        AAA_BBBBBB_CCCC.IMG

??? info "Browsing by Volume - File Structure"

    #### [PDS](http://hirise-pds.lpl.arizona.edu/PDS/)

    The PDS folder has subfolders by product type.  For processing in ISIS, look in the `EDR` Directory.

    #### > [EDR](http://hirise-pds.lpl.arizona.edu/PDS/EDR) - Product Type

    The EDR folder has subfolders by mission phase.  For processing in ISIS, the most useful are `PSP` (Primary Science Phase) and `ESP` (Extended Science Phase).

    #### > > [PSP](http://hirise-pds.lpl.arizona.edu/PDS/EDR/PSP) - Mission Phase

    The PSP folder has subfolders containing 100 orbits each, named as `ORB_[start orbit #]_[end orbit #]`.  Lower orbit numbers are earlier in the mission, and higher orbit numbers are later.

    #### > > > [ORB_002700_002799](http://hirise-pds.lpl.arizona.edu/PDS/EDR/PSP/ORB_002700_002799) - Orbit

    Each Orbit folder has a subfolder for each observation, labeled **Mission_Orbit_TargetCode** (`PSP_002733_1880`).  See above naming conventions for an explanation of the target code.

    #### > > > > [PSP_002733_1880](http://hirise-pds.lpl.arizona.edu/PDS/EDR/PSP/ORB_002700_002799/PSP_002733_1880) - Observation

    Each Observation folder has a file for each sub-image in the observation, suffixed by filter and channel (`RED4_0`).

    #### > > > > > [PSP_002733_1880_RED4_0.IMG](https://hirise-pds.lpl.arizona.edu/PDS/EDR/PSP/ORB_002700_002799/PSP_002733_1880/PSP_002733_1880_RED4_0.IMG) - .IMG File

    -----

        PDS
        ↳ EDR .......................................... (Product Type)
            ↳ PSP ...................................... (Mission Phase)
                ↳ ORB_002700_002799 .................... (Orbit Number)
                    ↳ PSP_002733_1880 .................. (Observation)
                        ↳ PSP_002733_1880_RED4_0.IMG ... (File)

## Ingestion

### EDR Format and Labels

!!! info inline end ""

    [![HiRISE_Fullres_Sample.png](assets/HiRISE_Fullres_Sample.png){width=50 align=right}](assets/HiRISE_Fullres_Sample.png "HiRISE_Fullres_Sample.png")

    ***HiRISE Data***

    First 4000 lines of an 80000 line EDR.

    Orbit 2733.

To work with HiRISE data in ISIS, the HiRISE EDR file must be
converted to an *ISIS cube* so ISIS programs can read and process
the data.

EDR files have the `.IMG` file extension. They
have image data and text describing the image data/the
state of the instrument at the time the image was taken. The text is in
the PDS Standard format at the beginning of the file.
Only the information needed by other Isis programs is transferred from
the PDS label to the ISIS cube label.

??? quote "Sample PDS Label from PSP_002733_1880_RED4_0.IMG"

    [View Full PDS Label](assets/hirise-pds-label.txt)

        PDS_VERSION_ID                 = PDS3
        
        /* File structure:                                                       */
        /* This file contains an unstructured byte stream.                       */
        /* The UNDEFINED RECORD_TYPE is used to meet PDS standards requirements. */
        /* A label "record" is actually a single byte.                           */
        RECORD_TYPE                    = UNDEFINED
        
        /* Locations of Data Objects in the file.                */
        /* >>> CAUTION <<< The first byte is location 1 (not 0)! */
        LABEL_RECORDS                  = 32768 <BYTES>
        ^SCIENCE_CHANNEL_TABLE         = 32769 <BYTES>
        ^LOOKUP_TABLE                  = 33569 <BYTES>
        ^CPMM_ENGINEERING_TABLE        = 49953 <BYTES>
        ^CALIBRATION_LINE_PREFIX_TABLE = 50013 <BYTES>
        ^CALIBRATION_LINE_SUFFIX_TABLE = 50013 <BYTES>
        ^CALIBRATION_IMAGE             = 50013 <BYTES>
        ^LINE_PREFIX_TABLE             = 227757 <BYTES>
        ^LINE_SUFFIX_TABLE             = 227757 <BYTES>
        ^IMAGE                         = 227757 <BYTES>
        ^GAP_TABLE                     = 84867757 <BYTES>
        
        /* Identification information. */
        DATA_SET_ID                    = MRO-M-HIRISE-2-EDR-V1.0
        DATA_SET_NAME                  = "MRO MARS HIGH RESOLUTION IMAGING SCIENCE
                                          EXPERIMENT EDR V1.0"
        PRODUCER_INSTITUTION_NAME      = "UNIVERSITY OF ARIZONA"
        PRODUCER_ID                    = UA
        PRODUCER_FULL_NAME             = "ALFRED MCEWEN"
        OBSERVATION_ID                 = PSP_002733_1880
        MRO:COMMANDED_ID               = PSP_002733_1880
        PRODUCT_ID                     = PSP_002733_1880_RED4_0
        PRODUCT_VERSION_ID             = 2
        SOURCE_FILE_NAME               = 4A_01_482AB57800_05_0_01.DAT
        INSTRUMENT_HOST_NAME           = "MARS RECONNAISSANCE ORBITER"
        INSTRUMENT_HOST_ID             = MRO
        INSTRUMENT_NAME                = "HIGH RESOLUTION IMAGING SCIENCE EXPERIMENT"
        INSTRUMENT_ID                  = HIRISE
        TARGET_NAME                    = MARS
        MISSION_PHASE_NAME             = "PRIMARY SCIENCE PHASE"
        ORBIT_NUMBER                   = 2733
        RATIONALE_DESC                 = "Faulted layers in Danielson Crater"
        SOFTWARE_NAME                  = "HiRISE_Observation v2.10.6 (2.47 2009/06/01
                                          05:08:10)"
        FLIGHT_SOFTWARE_VERSION_ID     = IE_FSW_V4
        
        /* Science Channel Header Observation Data Component description. */
        Object = SCIENCE_CHANNEL_TABLE
          INTERCHANGE_FORMAT = BINARY
          ROWS               = 1
          COLUMNS            = 184
          ROW_BYTES          = 800
          DESCRIPTION        = "The Science Channel Table contains engineering fields
                                describing the operating state and commanding of the
                                HiRISE observation. For detailed information about the
                                contents and organization of this observation data
                                component, refer to the SCIENCE_CHANNEL_TABLE.FMT
                                file."
          ^STRUCTURE         = SCIENCE_CHANNEL_TABLE.FMT
        End_Object
        
        /* Lookup Table Observation Data Component description. */
        Object = LOOKUP_TABLE
          INTERCHANGE_FORMAT = BINARY
          ROWS               = 16384
          COLUMNS            = 1
          ROW_BYTES          = 1
          DESCRIPTION        = "The Lookup Table (LUT) defines the translation of
                                14-bit input pixels to 8-bit output pixels. The table
                                has one column and 16384 rows, one for each input DN
                                value. The first entry of the table refers to the 8-bit
                                output value for the input pixel value 0."
        
          Object = COLUMN
            NAME        = "Output Data Value"
            DATA_TYPE   = MSB_UNSIGNED_INTEGER
            START_BYTE  = 1
            BYTES       = 1
            DESCRIPTION = "The rows represent the 8-bit output pixel value for each
                           14-bit input pixel. The first row contains the 8-bit pixel
                           value corresponding to the input DN value of 0. Each
                           subsequent row corresponds to the 8-bit output pixel of the
                           next input DN value."
          End_Object
        End_Object
        
        ...

### Converting to ISIS Cube

!!! example "Converting a HiRISE Image to an ISIS Cube with [`hi2isis`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/hi2isis/hi2isis.html)"
    
    ```sh
    hi2isis from=PSP_002733_1880_RED4_0.IMG to=PSP_002733_1880_RED4_0.cub
    ```

    [`hi2isis`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/hi2isis/hi2isis.html) 
    also converts the image header, prefix and suffix data to Isis
    Binary Large OBject (BLOBs) and has other parameters.

### SPICE

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
    spiceinit from=PSP_002733_1880_RED4_0.cub
    ```

    [`spiceinit`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
    will add SPICE information to the ISIS cube. 
    All HiRISE Channels image cubes require spiceinit. Generally, 
    [`spiceinit`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
    needs no other parameters than the filename (`from=`).


### Camera Geometry

Once an ISIS Cube has been initialized with SPICE info, 
it can be used for [camera geometry and photometry](../../../concepts/camera-geometry-and-projections/camera-geometry.md).

-----

<div class="grid cards" markdown>

- [:octicons-arrow-left-24: HiRISE Overview](hirise/index.md)

- [HiRISE Level 1 :octicons-arrow-right-24:](hirise-level-1.md)

</div>
