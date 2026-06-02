# LROC Wide Angle Camera (WAC) Data

We will focus on the monochromatic images for this sensor.

## Downloading WAC Data

!!! info "Searching/Downloading from LODE"

    Visit the [Lunar Orbital Data Explorer (WUSTL)](https://ode.rsl.wustl.edu/moon/productsearch).

    **STEP 1: SELECT DATA SETS TO SEARCH**

    - Lunar Reconnaissance Orbiter
        - Raw Data
            - [x] PDS4 Experiment Data Record Wide Angle Camera - Mono (EDRWAM4)

    **STEP 2: SET ADDITIONAL FILTERING PARAMETERS**  
    Set a lat-lon window, 
    or pick a notable feature (like a named crater)
    to narrow the search.

Here are a couple of images with the Tycho crater:

    http://pds.lroc.asu.edu/data/LRO-L-LROC-2-EDR-V1.0/LROLRC_0002/DATA/MAP/2010035/WAC/M119923055ME.IMG
    http://pds.lroc.asu.edu/data/LRO-L-LROC-2-EDR-V1.0/LROLRC_0002/DATA/MAP/2010035/WAC/M119929852ME.IMG


## Importing and Processing LROC WAC Images in ISIS

### Importing

!!! example "Import image to ISIS cube with [`lrowac2isis`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lrowac2isis/lrowac2isis.html)"
    ```sh
    lrowac2isis from = image.IMG to = image.cub
    ```
    This will create *even* and *odd* datasets, with names like
    `image.vis.even.cub` and `image.vis.odd.cub`.

!!! example "Add SPICE data with [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html)"
    ```sh
    spiceinit from = image.vis.even.cub
    spiceinit from = image.vis.odd.cub
    ```

### Processing

!!! example "Radiometrically Calibrate the images with [`lrowaccal`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lrowaccal/lrowaccal.html)"
    ```sh
    lrowaccal from = image.vis.even.cub to = image.vis.even.cal.cub
    lrowaccal from = image.vis.odd.cub  to = image.vis.odd.cal.cub
    ```

### Map-Projecting and Fusing

If even and odd images are inspected with 
[`qview`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/qview/qview.html), 
it can be seen that instead of a single contiguous image, we have a set of narrow
horizontal bands, with some bands in the *even* and some in the *odd*
.cub file. The pixel rows in each band may also be recorded in reverse.

To fix these artifacts, map-project these images and fuse them.

!!! example "Map Project the images with [`cam2map`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cam2map/cam2map.html)"
    ```sh
    cam2map from = image.vis.even.cal.cub to = image.vis.even.cal.map.cub
    cam2map from = image.vis.odd.cal.cub  to = image.vis.odd.cal.map.cub  \
      map = image.vis.even.cal.map.cub matchmap = true
    ```

    Note how in the second ``cam2map`` call we used the ``map`` and
    ``matchmap`` arguments. This is to ensure that both of these output
    images have the same resolution and projection. In particular, if more
    datasets are present, it is suggested for all of them to use the same
    previously created .cub file as a map reference. That makes terrain
    creation with photogrammetry work more reliably. 

!!! example "Fuse the images with [`noseam`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/noseam/noseam.html)"

    *For the input of noseam, make a list of images.*

    ```sh
    ls image.vis.even.cal.map.cub image.vis.odd.cal.map.cub  > image.txt
    noseam fromlist = image.txt to = image.noseam.cub SAMPLES=73 LINES=73
    ```