# LROC Narrow Angle Camera (NAC) Data

## Download a pair of LROC NAC Images

LRO NAC consists of two cameras (`L` and `R`); both capture image data at the same time. 

!!! info "Getting Images from [LROC Image Search](http://wms.lroc.asu.edu/lroc/search)"

    Find images with the [LROC Image Search (ASU)](http://wms.lroc.asu.edu/lroc/search). Search for
    ```
    M104318871
    ```
    and filter for EDR images, then download the left and right EDR images to your working folder: `M104318871LE.img` and `M104318871RE.img`.
    *Only one image is needed for the following example.*

## Importing and processing LROC NAC images in ISIS

Convert each .img file to an ISIS .cub camera image, initialize the SPICE kernels, and perform radiometric calibration and echo correction.

!!! example

    1.  Import image to ISIS cube format with [`lrocnac2isis`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lronac2isis/lronac2isis.html).  
        ```sh
        lronac2isis from = M104318871LE.IMG     to = M104318871LE.cub
        ```

    1.  Add SPICE data to the cube with [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html).  
        ```sh
        spiceinit   from = M104318871LE.cub
        ```

    1.  Radiometrically calibrate the cube with [`lronaccal`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lronaccal/lronaccal.html).  
        ```sh
        lronaccal   from = M104318871LE.cub     to = M104318871LE.cal.cub
        ```

    1.  Echo Correction with [`lornacecho`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lronacecho/lronacecho.html).  
        ```sh
        lronacecho  from = M104318871LE.cal.cub to = M104318871LE.cal.echo.cub
        ```

The obtained images can be inspected with [`qview`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/qview/qview.html).

## Further NAC Processing Resources

<div class="grid cards" markdown>

-   ***Want to Keep Going?***

    -----

    Further processing, including photometric correction, map-projecting, and mosaicking.

    [NAC Processing Guide :octicons-arrow-right-24:](https://doi.org/10.5281/zenodo.15392665)

-   ***Where Is That Crater?*** 
    
    -----

    Best practices for obtaining accurate coordinates from LROC NAC data.

    [Obtaining Accurate Coordinates :octicons-arrow-right-24:](https://iopscience.iop.org/article/10.3847/PSJ/ad54c6)

</div>