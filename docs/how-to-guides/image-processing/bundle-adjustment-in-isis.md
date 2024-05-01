# Bundle Adjustment in ISIS

!!! Note "While a conceptual understanding of bundle adjustment is not necessary to follow this walkthrough, it is recommended that the user understands the basic concepts associated with the bundle adjustment process.  More information related to the bundle adjustment process can be found [here](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/jigsaw/jigsaw.html)."

This tutorial assumes that the user has access to ISIS command line utilities and an ISISDATA area.

## Step 1: Creating an Image List
Bundle adjustment inherently requires multiple observations, and ISIS expects these observations to be in the form of a line-separated text file (.lis) in which each line contains the name of a .cub file.  Assuming that all .cub files are present in the current directory, one convenient means of scraping the full paths of the .cub files into a .lis file is with:

```console
ls -d -1 "$PWD/"*.cub > image_list.lis
```

## Step 2: Adding SPICE Information to Images with spiceinit

SPICE information allows the instrument that captured an observation to be localized, and it includes information related to the interior and exterior orientation of the instrument as well as the orientation of celestial bodies.  In order to perform bundle adjustment, each observation that is included in the adjustment process must have SPICE data attached. SPICE data can be attached using ISIS's `spiceinit` program.

While it is possible to `spiceinit` each image individually, ISIS includes a reserved `batchlist` parameter that allows the user to take advantage of the .lis file that was previously created.  In order to batch `spiceinit` each of the files in the input list, the user can issue the following command:

```console
spiceinit -batchlist=image_list.lis from=\$1
```

## Step 3: Finding the Geospatial Extents of Images with footprintinit

The geospatial extent of the image refers to the lat/lon bounding box of the image, i.e. the image's "footprint." The lat/lon polygon of the image's extent can be attached to an image using ISIS's `footprintinit` program.  Similarly to the process of `spiceinit`ing a list of images, `footprintinit`ing a list of images is best used in conjunction with the `batchlist` parameter as follows:

```console
footprintinit -batchlist=image_list.lis from=\$1
```

## Step 4: Creating an Overlap List using findimageoverlaps

An image overlap list contains a list of polygons that represent the overlapping portions of the input images.  Image overlap information plays a critical role in the initial placement of control points.  ISIS provides the `findimageoverlaps` program to aid in the production of overlap lists, which can be used as follows:

```console
findimageoverlaps fromlist=image_list.lis overlaplist=overlap_list.lis
```

## Step 5: Creating a Control Network with autoseed
In order to perform bundle adjustment, it is necessary to identify a set of locations per image (control points) that correspond to a set of ground locations (control measures).  Together, these points and measures are combined into a "control network." While there are multiple methods for generating a control network, this tutorial uses the `autoseed` utility to automatically generate a simple, grid-based control network.

### Configuring the algorithm with the definition file
`autoseed` requires a "definition file," which is responsible for configuring the algorithm that generates the control points.  To follow along with the tutorial, save the following snippet as `seeder.def`.

```
Group = PolygonSeederAlgorithm
  Name             = Grid
  MinimumThickness = 0.3
  MinimumArea      = 100000000
  XSpacing         = 10000
  YSpacing         = 10000
End_Group

```

### Generating a Control Network
After creating the definition file, the user can create a control network with the following `autoseed` command:

```console
autoseed fromlist=image_list.lis overlaplist=overlap_list.lis deffile=seeder.def onet=control_network.net networkid=test_net pointid=test_point_??? description="a test network used in the bundle adjustment tutorial"
```

An explanation of the configuration options passed to autoseed is as follows:

- fromlist: the list of input images
- overlaplist: the image overlap information derived from findimageoverlaps
- deffile: the algorithm definition file
- onet: the output network
- networkid: a name that defines the output network
- pointid: a string containing wildcard "???" characters used to define points.  In this example, points will be named test_point_001 (or similar)
- description: a description of the output network

## Step 6: Performing Bundle Adjustment with Jigsaw

Finally, with all the prerequisite information generated and attached, it is possible to perform bundle adjustment.  Within ISIS, this is performed using the `jigsaw` utility. `jigsaw` is highly configurable, and it has many options that can be viewed [here](https://isis.astrogeology.usgs.gov/8.1.0/Application/presentation/Tabbed/jigsaw/jigsaw.html).  For the purposes of this tutorial, configuration is left to a minimum.

```console
jigsaw fromlist=image_list.lis cnet=control_network.net onet=control_network_jig.net update=no file_prefix=jig maxits=10 camsolve=angles camera_angles_sigma=.25
```

An explanation of the configuration options passed to jigsaw is as follows:

- fromlist: the list of .cubs to be bundle adjusted
- cnet: the control network containing the control information used to bundle adjust the network
- onet: the output control network
- update: whether or not the camera geometries of the input cubes will be adjusted
- file_prefix: the filename prefix of the output files
- maxits: the maximum number of iterations
- camsolve: the camera parameters included in the solution
- camera_angles_sigma: global uncertainty for camera angles
