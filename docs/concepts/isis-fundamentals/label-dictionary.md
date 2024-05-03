# ISIS Label Dictionary

## Introduction

This document is a reference to the various objects and groups, which can be found in ISIS labels. The definition of each object/group, the parameter meanings, and an example will be given.

## IsisCube Object

The IsisCube Object is simply a container. It is used to house the various elements (groups and objects) that make up an ISIS cube. The IsisCube object is comprised of the Core object, which defines the cube size and pixel attributes and many optional groups that are described elsewhere in this document including Archive, BandBin, Instrument, Kernels, and Mapping Groups. While we present a whole IsisCube object we will save of the individual elements in their own sections.

```
Object = IsisCube
  Object = Core
    ^Core       = filename.dat
    StartByte   = 65537
    Format      = Tile
    TileSamples = 128
    TileLines   = 128

    Group = Dimensions
      Samples = 320
      Lines   = 5392
      Bands   = 1
    EndGroup

    Group = Pixels
      Type       = Real
      ByteOrder  = Lsb
      Base       = 0.0
      Multiplier = 1.0
    EndGroup
  EndObject

  Group = BandBin
    OriginalBand = 10
    Center       = 14.88 <microns>
    Width        = 0.87 <microns>
    FilterNumber = 10
  EndGroup
EndObject
```

## Core Object

The core object is used to house the groups (Dimensions and Pixels) that describe the size and pixel attributes of the cube, as well as the storage type of the data.

```
Object = Core
  ^Core       = filename.dat
  StartByte   = 65537
  Format      = Tile
  TileSamples = 128
  TileLines   = 128

  Group = Dimensions
    Samples = 320
    Lines   = 5392
    Bands   = 1
  EndGroup

  Group = Pixels
    Type       = Real
    ByteOrder  = Lsb
    Base       = 0.0
    Multiplier = 1.0
  EndGroup
EndObject
```

|Keyword|Type|Description|
|--- |--- |--- |
|^Core|String|This optional keyword is used to point to an extra binary file containing the cube data. The cube is designated detached (labels and cube data in separate files) if this keyword exists.  If the keyword does not exist it indicates the labels and cube data are attached (in the same file).|
|StartByte|Integer|This keyword points to the starting byte (one-based) of the cube data.  For detached cubes this value is often equal to one.  For attached cubes it often 65537 as there is typically 64k bytes reserved for label space.  On occasions it may be larger if the labels have grown beyond this boundary.|
|Format|String (Tile or BandSequential)|This keyword indicates how the cube data is arranged.  BandSequential indicates the pixels are stored first by sample, then by line, and finally by band.  Tile indicates the pixels are stored in tiles which is the preferred storage mechanism in  as it facilities the fastest “universal access”. The tiles are stored in row major format.  That is, all the tiles for band 1 ordered from left-to-right, then top-to-bottom, followed by all the tiles for band 2, etc.|
|TileSamples, TileLines|Integer|Optional keywords which must exist when Format=Tile in a cube. These define the size of the tiles in the cube and do not have to be the same.  They are typically 128 x 128 in size.|

## Dimensions Group

This group contains keywords which define the physical dimensions of the cube. The group is always found inside the Core object.

```
Group = Dimensions
  Samples = 320
  Lines   = 5392
  Bands   = 1
EndGroup
```

|Keyword|Type|Description|
|--- |--- |--- |
|Samples, Lines, Bands|Integer|These three keywords are in the Dimensions group and define the size of the cube.|


## Pixel Group

This group describes information about the pixels in a cube. The group is always found inside the Core object.

```
Group = Pixels
  Type       = Real
  ByteOrder  = Lsb
  Base       = 0.0
  Multiplier = 1.0
EndGroup
```

|Keyword|Type|Description|
|--- |--- |--- |
|Type|String (UnsignedByte, SignedWord, Real)|Currently there are three type of pixels in ISIS which represent unsigned 8-bit values (0 to 255), signed 16-bit values (-32768 to 32767) and 32-bit IEEE floating point pixel values.  [Future option] Support alternative pixel types.|
|ByteOrder|String (Lsb, Msb)|This defines the byte order or endianness of the pixels.  The order must either be least significant byte (Lsb) or most significant byte (Msb).|
|Base, Multiplier|Double|These values are used to scale UnsignedByte and SignedWord pixels so they appear to be Real (32-bit floating) pixels.  That is, realDn = diskDN * Multiplier + Base.  These values are always 0.0 and 1.0 when Type=Real.|

## AlphaCube Group

This group is used to map pixel locations in a child cube (beta) back to its parent cube (alpha). It is necessary in order to determine which detector a pixel represents in ISIS camera models. The group is created by ISIS ingestion programs (e.g., thm2isis, moc2isis, ciss2isis, etc) and automatically updated by programs such as crop, pad, reduce, or enlarge. The keywords found in this group can occur in one of two places. Either inside of the AlphaCube group or inside of the Instrument group and therefore they can occur twice. Once if a crop occurred in Instrument (level 1) space and again if a crop occurred in Mapping (level 2) space.

```
Group = AlphaCube
    AlphaSamples          = 320
    AlphaLines            = 5392
    AlphaStartingSample   = 0.5
    AlphaStartingLine     = 0.5
    AlphaEndingSample     = 320.5
    AlphaEndingLine       = 5392.5
    BetaSamples           = 320
    BetaLines             = 5392
EndGroup
```

|Keyword|Type|Description|
|--- |--- |--- |
|AlphaSamples, AlphaLines|Integer|The number of lines and samples in the original parent/alpha cube.|
|AlphaStartingSample, AlphaStartingLine|Double|The starting sample and line in the alpha cube which maps to (0.5,0.5) in the beta cube.|
|AlphaEndingSample, AlphaEndingLine|Double|The ending sample and line in the alpha cube which maps to (BetaSamples+0.5,BetaLines+0.5) in the beta cube.|

## Archive Group

This group is used to store keywords that identify archival information. That is, information which uniquely identifies the data. There is not a “required” set of keywords for this group. Generally, the keywords found in this group represent PDS specific information as indicated in the example given below.

```
Group = Archive
  ImageNumber         = "7102002401"
  ProductId           = “AB-1-024/01”
  DataSetId           = "MGS-M-MOC-NA/WA-2-DSDP-L0-V1.0"
  ProducerId          = "MGS_MOC_TEAM"
  ProductCreationTime = "1999-01-15T20:40:59.000Z"
  UploadId            = "moc_p024_v1.sasf"
  ImageKeyId          = "5618102401"
  RationalDescription = “OLYMPUS MONS SPECIAL RED WA"
EndGroup
```

## BandBin Group

This group is used to stored information regarding each band in the cube. This implies that every keyword in the group be an array with a dimension equal to the number of bands in the cube. This group is not required nor if it exists are any particular keywords required. That is, the names of keywords are irrelevant although some instrument- specific programs may expect certain keywords to be available (e.g., OriginalBand). The keywords in this group will be automatically pruned if any program uses the input cube attribute option (e.g., from=input.cub+1,3-4).

```
Group = BandBin
  OriginalBand = (1, 2, 3, 4, 5)
  Center       = (6.78, 6.78, 7.93, 8.56, 9.35) <microns>
  Width        = (1.01, 1.01, 1.09, 1.16, 1.20) <microns>
  FilterNumber = (1, 2, 3, 4, 5)
EndGroup
```

|Keyword|Type|Description|
|--- |--- |--- |
|OriginalBand|Integer|This keyword indicates the original band number at the current band location.  Hence, extracting bands 2 and 5 from a cube via the input cube attribute option would yield OriginalBand = (2,5)|
|Center, Width|Double|Often these keywords are used to describe the center wavelength and width of each band.|

## ImportLabel Object
```
Object = ImportLabel
  Lblsize  = 536
  Format   = HALF
  Type     = IMAGE
  Bufsiz   = 24576
  Dim      = 3
  Eol      = 1
  Recsize  = 536
  Org      = BSQ
  Nl       = 256
  Ns       = 256
  Nb       = 1
  N1       = 256
  N2       = 256
  N3       = 1
  N4       = 0
  Nbb      = 24
  Nlb      = 1
  Host     = SUN-SOLR
  Intfmt   = HIGH
EndObject
```

## Instrument Group 

This group stores specific information regarding the mission and instrument. This information is typically used to perform radiometric calibration as well as in camera models in order to accurately compute ground positions in a raw camera cube. Obviously, the keywords in the group will vary from instrument to instrument. However, there are three required keywords (Name, Spacecraft, and Target). Definitions for Instrument specific keywords can be found in the appropriate documentation for that instrument.

```
Group = Instrument
  SpacecraftName  = "Galileo Orbiter"
  InstrumentId    = "Solid State Imaging System"
  TargetName      = Io
  StartTime       = "1996-06-25T17:36:56.858"
  FrameModeId     = Full
EndGroup
```

|Keyword|Type|Description|
|--- |--- |--- |
|SpacecraftName|String|Name of the mission/spacecraft|
|InstrumentId|String|The name of the instrument|
|TargetName|String|The name of target/body which the instrument is viewing|

## Kernels Group

See [The ISIS Attached Spice Format](../isis-fundamentals/spice-format.md#the-kernels-group).

## Mapping Group

The Mapping Group is used to define map projections. Recommending reading includes [Map projections: A working manual, Snyder, J.P., U.S. Geological Survey, Professional Paper 1395](https://pubs.usgs.gov/publication/pp1395).

```
Group = Mapping
  ProjectionName         = Sinusoidal
  TargetName             = MARS
  EquatorialRadius       = 3396190.0 <meters>
  PolarRadius            = 3376200.0 <meters>
  LatitudeType           = Planetocentric
  LongitudeDirection     = PositiveEast
  LongitudeDomain        = 360
  MinimumLatitude        = -5.5707102
  MaximumLatitude        = 13.8285999
  MinimumLongitude       = 351.4547729
  MaximumLongitude       = 355.6184082
  PixelResolution        = 100.0 <meters/pixel>
  Scale                  = 592.74697523306 <pixels/degree>
  TrueScaleLatitude      = 0.0
  CenterLongitude        = 354.0
  LineProjectionOffset   = -8196.5
  SampleProjectionOffset = -1508.5
  UpperLeftCornerX       = -150900.0 <meters>
  UpperLeftCornerY       = 819700.0 <meters>
EndGroup
```

|Keyword|Type|Description|
|--- |--- |--- |
|ProjectionName|String|This indicates the name of the map projection (Sinusoidal, SimpleCylindrical, PolarStereographic, etc)|
|EquatorialRadius, PolarRadius|Double|The distance in meters from the center of the body to any point on the equator or to either pole, respectively.|
|LongitudeDirection|String|The direction of positive longitude, PositiveEast or PostiveWest.  The term PositiveEast implies that longitudes increase to the right on a map.|
|LatitudeType|String|Indicates the coordinate type for the latitude values, Planetocentric or Planetographic|
|LongitudeDomain|String|Indicates the preferred representation, 180 or 360 domain, of longitudes when reporting values or constructing new map. The value 360 implies 0 to 360 while 180 implies -180 to 180.|
|MinimumLatitude, MaximumLatitude, MinimumLongitude, MaximumLongitude|Double|The values indicate the ground range of the projection (in coordinates of LatitudeType and LongitudeDirection).  Because cubes/images are discrete by nature (integral number of pixels), the latitude and longitude boundaries will rarely if every match perfectly.  Therefore these values are used only when a map-projected cube is constructed and should only be used as reference from that point forward.  For example, do not use these values to import data into another image processing package; instead use UpperLeftCornerX and UpperLeftCornerY.|
|PixelResolution|Double|This indicates size of each pixel in meters relative to the map projection.  Beware that this does not imply each pixel has true scale.  That is completely dependent upon the type of map projection utilized (Sinusoidal, Mercator, etc).   The resolution often only holds at the latitude of true scale.|
|Scale|Double|This indicates the number of pixels per degree relative to the map projection.  Beware that this does not imply each pixel has true scale.  That is completely dependent upon the type of map projection utilized (Sinusoidal, Mercator, etc).   The scale often only holds at the latitude of true scale.|
|TrueScaleLatitude|Double|This indicates the latitude at which the Scale or PixelResolution holds true.|
|UpperLeftCornerX, UpperLeftCornerY|Double|These values indicate the projection X/Y in meters at sample 0.5, line 0.5.  This base X/Y along with the PixelResolution can be used to compute the projection X/Y at any pixel location in the cube.  For example, X = (Sample – 0.5) * PixelResolution + UpperLeftCornerX and Y = UpperLeftCornerY – (Line – 0.5) * PixelResolution.   With the proper equations for the projection the computed X/Y could be converted to a latitude/longitude.|
|LineProjectionOffset, SampleProjectionOffset|Double|These values are listed solely for compatibility with PDS labels and are equivalent to the UpperLeftCorner values in pixel units.|

