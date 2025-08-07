# Processing LRO MiniRF S-Zoom Data

## Data Ingestion

!!! example "Import image to ISIS cube with [`mrf2isis`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mrf2isis/mrf2isis.html)"
    ```sh
    mrf2isis from=LSZ_04485_1CD_XKU_87S205_V1.LBL to=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub
    ```

    For `mrf2isis` to succeed:

    - Both the .LBL and .IMG files must be in the same directory together  
    - The LBL and IMG extensions must be in upper or lower case consistent with each other (.LBL/.IMG or .lbl/.img).


!!! example "Add SPICE data with [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)"

    [`spiceinit`](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)
    will add the appropriate SPICE information to the ISIS cube.
    Successful spiceinit allows for further geometric processing of the
    data.

    ```sh
    spiceinit from=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub spksmithed=true
    ```

    Specify the "Smithed" SPK kernels for LRO (not a default in spiceinit).

    For the moon, ISIS currently defaults to the global LOLA for the local
    topographic shapemodel.
    

## Preparing the Image with Stoke Parameters

### Stoke Parameter Images

!!! example "Generate Stoke Parameter Images with [`fx`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/fx/fx.html)"

    #### S1

    ```sh
    fx f1=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub+1  f2=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub+2 \
       equation="f1 + f2" \
       to=LSZ_04485_1CD_XKU_87S205_V1_S1.cub
    ```

    #### S2

    ```sh
    fx f1=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub+1  f2=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub+2 \
       equation="f1 - f2" \
       to=LSZ_04485_1CD_XKU_87S205_V1_S2.cub
    ```

    #### S3

    ```sh
    fx f1=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub+3 \
       equation="f1 * 2.0" \
       to=LSZ_04485_1CD_XKU_87S205_V1_S3.cub
    ```

    #### S4

    ```sh
    fx f1=LSZ_04485_1CD_XKU_87S205_V1_lev1.cub+4 \
       equation="f1 * -2.0" \
       to=LSZ_04485_1CD_XKU_87S205_V1_S4.cub
    ```

### S1: Replace Invalid Pixels

!!! example "Replace Invalid S1 Pixels with [`mask`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/mask/mask.html)"

    Replace invalid pixels along the vertical edge beyond the lunar data for the S1 file.

    The output pixels will be replaced with NULL.

    ```sh
    mask from=LSZ_04485_1CD_XKU_87S205_V1_S1.cub to=LSZ_04485_1CD_XKU_87S205_V1_S1_NoZ.cub \
        min=-20.0 max=0.0 preserve=outside spixels=NULL
    ```

### Stack Masked S1_NoZ Output with S2, S3 and S4

!!! example "Stack Images with [`cubeit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cubeit/cubeit.html)"

    *`cubeit` uses a list as input, S1-S4 in this case.  The output is one cube with multiple bands.*

    ```sh
    ls LSZ_04485_1CD_XKU_87S205_V1_S1_NoZ.cub > stack.lis
    ls LSZ_04485_1CD_XKU_87S205_V1_S2.cub >> stack.lis
    ls LSZ_04485_1CD_XKU_87S205_V1_S3.cub >> stack.lis
    ls LSZ_04485_1CD_XKU_87S205_V1_S4.cub >> stack.lis
    
    cubeit fromlist=stack.lis to=LSZ_04485_1CD_XKU_87S205_V1_STACK.cub
    ```

### Stack: Replace Invalid Pixels

!!! example "Replace Invalid Pixels in All Bands with [`bandtrim`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/bandtrim/bandtrim.html)"

    Replace invalid pixels for stacked S2, S3 and S4.

    Any NULL pixels in any band will be nulled across all bands.  So, the NULL values in the S1_NoZ will applied to the remaining bands.

    ```sh
    bandtrim from=LSZ_04485_1CD_XKU_87S205_V1_STACK.cub to=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM.cub
    ```

### Scale Down the Cube

!!! example "Scale down with [`reduce`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/reduce/reduce.html)"

    Scale the 4-band stacked, cleaned cube down to ~15 meters/pixel (from the original 30).

    Reduce will average the input pixels (aka pixel binning). It is better to use `reduce`
    than to specify a smaller resolution in a map template for `cam2map`.

    ```sh
    reduce from=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM.cub \
        to=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM_15m.cub \
        lscale=2 sscale=2
    ```

## Map-Projecting

The above examples produce a 4-band cube with 4 Stoke Parameter Images, binned to 2x2 and cleaned.  This cube is ready to be map-projected.

<div class="grid cards" markdown>

- [Map Projection Overview :octicons-arrow-right-24:](../../../how-to-guides/image-processing/map-projecting-images.md)

- [Map Projection in ISIS :octicons-arrow-right-24:](../../../concepts/camera-geometry-and-projections/learning-about-map-projections.md)

</div>

### Create a maptemplate

Create a maptemplate to map-project the cube.

!!! quote "Example map template for MiniRF (for a polar image):"

    ```
    Group = Mapping  
      ProjectionName = POLARSTEREOGRAPHIC  
      CenterLongitude = 0.0  
      TargetName = MOON  
      EquatorialRadius = 1737400.0  
      PolarRadius = 1737400.0  
      LatitudeType = Planetocentric  
      LongitudeDirection = PositiveEast  
      LongitudeDomain = 360  
      PixelResolution = 14.806323449292  
      Scale = 2048.0  
      CenterLatitude = -90.0  
    End_Group
    ```

### Map-Project the Cube

!!! example "Map-Project the Cube with [`cam2map`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)"

    For resolution, specify the scale in meters/pixel in cam2map.

    ```sh
    cam2map from=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM_15m.cub \
            to=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM_15m_map.cub \
            pixres=camera resolution=2048 warpalgorithm=forwardpatch patchsize=5 map=predefined.map
    ```
For a mosaic, remember to make sure all images are projected 
to the same projection, clat, clon and map scale/resolution. 
See [Map Projections Power Tip: Making Mosaics](../../../concepts/camera-geometry-and-projections/learning-about-map-projections.md#power-tip-making-mosaics).

### Circular Polarization Ration (CPR)

!!! example "Create a CPR Cube with [`fx`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/fx/fx.html)"

    Create an 8-bit CPR cube from the Stokes-1 and Stokes-4 bands of the
    stacked cube or the multi-band mosaic:

    ```sh
    fx f1=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM_15m_map.cub+1 \
       f2=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM_15m_map.cub+4 \
       to=LSZ_04485_1CD_XKU_87S205_V1_STACK-TRIM_15m_map_CPR.cub+UnsignedByte+0.0:2.53 \
       equation="(f1-f2)/f1+f2)" mode=cubes
    ```