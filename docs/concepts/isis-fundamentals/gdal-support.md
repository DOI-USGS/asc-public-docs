# GDAL Support

GDAL (Geospatial Data Abstraction Library) has a broad range of data formats. To improve interoperability, ISIS added support for GeoTIFF (Geospatial Tag Image File Format) in [RFC 13](https://github.com/DOI-USGS/ISIS3/discussions/5698).

## Processing With GeoTIFFs

Use `+GTiff` as an [output attribute](../../concepts/isis-fundamentals/command-line-usage.md#storage-format) to save output as a GeoTIFF. This creates a `.tiff` and a `.tiff.msk` file.

The GeoTIFF can then be used as input like cubes to other applications.

???+ example "Using the +GTiff Output Attribute"

    ```sh
    mroctx2isis from=mroraw.img to=mrotiff.tiff+GTiff
    ```
    results in

    ```sh
    mrotiff.tiff
    mrotiff.tiff.msk
    ```

### Combining Attributes

Supported output attributes can be combined with the `+GTiff` attribute.

!!! failure inline end "Unsupported"

    #### [Pixel Storage Order](../../concepts/isis-fundamentals/command-line-usage.md#pixel-storage-order)

    *+lsb, +msp*

!!! success "Supported"

    #### [Pixel Type Attributes](../../concepts/isis-fundamentals/command-line-usage.md#pixel-type)

    *+UnsignedByte, +8-bit, +SignedWord, +16-bit, +Real, +32-bit*

    #### [Label Format Attributes](../../concepts/isis-fundamentals/command-line-usage.md#label-format)

    *+attached, +detached*

-----

### Compression

When using +GTiff in ISIS, the compression defaults to DEFLATE with PREDICTOR=2, which is lossless and supports all bit types. Overviews are not automatically created by ISIS, but they can be added to any TIFF using the GDAL routine `gdaladdo`.

### Projection

Technically, a fully realized GeoTIFF is only enabled when the data is map projected. For images that are not yet map projected, the underlying TIFF format will still be used, but there will be no geospatial map projection in the ISIS or TIFF label.

***[Open Geospatial Consortium GeoTIFF Specification :octicons-arrow-right-16:](https://www.ogc.org/publications/standard/geotiff/)***

-----

### Processing With Cloud Data (`vsicurl`)

GeoTIFFs (and therefore, ISIS as well) support online/cloud volume access.

You can access online volumes by adding `/vsicurl/` in front of the URL for your data. See [GDAL Virtual File Systems](https://gdal.org/en/stable/user/virtual_file_systems.html) for more info.

!!! example "Accessing Online Volumes"

    #### Viewing a Label in `catlab`  
    ```sh
    catlab from=/vsicurl/https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/T01_000881_1752_XI_04S223W__P22_009716_1773_XI_02S223W/T01_000881_1752_XI_04S223W__P22_009716_1773_XI_02S223W-DEM.tif
    ```

    #### Viewing a cube in `qview`  
    ```sh
    qview /vsicurl/https://astrogeo-ard.s3-us-west-2.amazonaws.com/mars/mro/ctx/controlled/usgs/T01_000881_1752_XI_04S223W__P22_009716_1773_XI_02S223W/T01_000881_1752_XI_04S223W__P22_009716_1773_XI_02S223W-DEM.tif
    ```

### Overviews - Stream Less Data

Many cloud volumes will have **overviews**, or **compressed versions** of the image that can be requested for display rather than the full resolution image.

Use of overviews for responsiveness over the web. If an online dataset has overviews, you can stream overview data rather than full resolution data. This decreases the amount of data needed to display the image. 

For example, if someone is displaying a 500 x 500 portion of a 1000 x 1000 image at .25 scale that has overviews, GDAL will extract the DNs from the overview with a downsampling of 8. So instead of having to transfer all 250000 DN values over the network then subsampled, only 15625 downsampled DNs will to be transferred.

??? abstract "GeoTIFF with and without Overview"

    If a GeoTIFF does not have overviews, it will be subsampled based on the scale as ISIS already does with cubes. When using overviews, the image will be sampled at the closest resolution to the requested one. The images will look slightly different in Qview. As shown in the gif below, the images look like they are changing but in reality, `B10_013341_1010_XN_79S172W_no_ovr.cal.tiff` is being subsampled while `B10_013341_1010_XN_79S172W.cal.tiff` is using overviews.

    ![Alt Text](../../assets/gdal_data/overview_blink.gif)

To create overviews, use GDAL's [`gdaladdo`](https://gdal.org/en/stable/programs/gdaladdo.html#gdaladdo).

### ISIS Specific GeoTIFF Data

All axiliary processing data used in ISIS will be stored in the GeoTIFF as JSON under the "USGS" Domain.

Each blob/table is stored as a string under a keyword that represents the blob as `OBJECT_NAME` (i.e, `Table_SunPosition`, `History_IsisCube`, or `Field_J2000X`).

GeoTIFFs can't store data in binary format like ISIS Cubes, so binary data is converted to hexadecimal and placed at the `Data` key in the GeoTIFF JSON.

???+ note "Metadata in GeoTIFF vs Cube Labels"

    === "GeoTIFF (Metadata + Data)"
    
        ```json
        {"Table_SunPosition": 
            '{
                "_container_name":"Table",
                "_type":"object",
                "Field_J2000X":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"J2000X",
                    "Type":"Double",
                    "Size":"1"
                },
                "Field_J2000Y":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"J2000Y",
                    "Type":"Double",
                    "Size":"1"
                },
                "Field_J2000Z":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"J2000Z",
                    "Type":"Double",
                    "Size":"1"
                },
                "Field_J2000XV":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"J2000XV",
                    "Type":"Double",
                    "Size":"1"
                },
                "Field_J2000YV":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"J2000YV",
                    "Type":"Double",
                    "Size":"1"
                },
                "Field_J2000ZV":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"J2000ZV",
                    "Type":"Double",
                    "Size":"1"
                },
                "Field_ET":{
                    "_container_name":"Field",
                    "_type":"group",
                    "Name":"ET",
                    "Type":"Double",
                    "Size":"1"
                },
                "Name":"SunPosition",
                "StartByte":"1",
                "Bytes":"112",
                "Records":"2",
                "ByteOrder":"Lsb",
                "CacheType":"Linear",
                "SpkTableStartTime":"297088762.24158",
                "SpkTableEndTime":"297088808.37074",
                "SpkTableOriginalSize":"2.0",
                "Description":"Created by spiceinit",
                "Kernels":[
                    "$base/kernels/spk/de430.bsp",
                    "$base/kernels/spk/mar097.bsp"
                ],
                "Data":"4cffffffd401ffffffe62effffffd3ffffffa8ffffffc11d03ffffffffffffff8525495dffffffc157fffffffb03ffffff89ffffff800c404114ffffffd1ffffffa7ffffffb6ffffffecffffffe7ffffffcaffffffbfffffffc6fffffffa48ffffffd7ffffffe1ffffffe637ffffffc0246fffffff93ffffffae39ffffffea25ffffffc074ffffffd83dfffffffa36ffffffb5ffffffb141fffffff6ffffffc264fffffff92effffffd3ffffffa8ffffffc1503cffffffb32a394a5dffffffc1fffffff5fffffff746ffffffceffffff830b4041ffffffc6066d1b4fffffffe3ffffffcaffffffbf6c4f1dffffff80ffffffe1ffffffe637ffffffc03fffffffb246ffffffde39ffffffea25ffffffc0ffffff8fffffffe85e2837ffffffb5ffffffb141"
            }'
        }
        ```

    === "Cube (Metadata)"

        ```
        Object = Table
          Name                 = SunPosition
          StartByte            = 493963254
          Bytes                = 112
          Records              = 2
          ByteOrder            = Lsb
          CacheType            = Linear
          SpkTableStartTime    = 297088762.24158
          SpkTableEndTime      = 297088808.37074
          SpkTableOriginalSize = 2.0
          Description          = "Created by spiceinit"
          Kernels              = ($base/kernels/spk/de430.bsp,
                                  $base/kernels/spk/mar097.bsp)

          Group = Field
            Name = J2000X
            Type = Double
            Size = 1
          End_Group

          Group = Field
            Name = J2000Y
            Type = Double
            Size = 1
          End_Group

          Group = Field
            Name = J2000Z
            Type = Double
            Size = 1
          End_Group

          Group = Field
            Name = J2000XV
            Type = Double
            Size = 1
          End_Group

          Group = Field
            Name = J2000YV
            Type = Double
            Size = 1
          End_Group

          Group = Field
            Name = J2000ZV
            Type = Double
            Size = 1
          End_Group

          Group = Field
            Name = ET
            Type = Double
            Size = 1
          End_Group
        End_Object
        ```

### Working with GDAL Products Outside of ISIS

GDAL provides a [suite of applications](https://gdal.org/en/stable/programs/index.html) that support both GeoTIFFs and ISIS Cubes.

While there are plans to update the GeoTiff Driver in GDAL to support and maintain this ISIS JSON metadata, if an external application is used, the ISIS metadata within the GeoTIFF will likely not be recognized or lost during conversion. For example, during a conversion of an ISIS-created GeoTIFF using `gdal_translate`, the output file will not contain the JSON metadata.

Some notable applications are `gdalinfo`, `gdal_translate`, and `gdaladdo`.

- [`gdalinfo`](https://gdal.org/en/stable/programs/gdalinfo.html#gdalinfo) provides information on supported GDAL formats
- [`gdal_translate`](https://gdal.org/en/stable/programs/gdal_translate.html#gdal-translate) can convert one supported GDAL image format into another.
- [`gdaladdo`](https://gdal.org/en/stable/programs/gdaladdo.html#gdaladdo) builds image overviews. This is largely useful in a cloud computing environment when viewing images, as overviews will transfer less data when requesting DNs over the net.