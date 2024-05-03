# Bundle Adjustment in ISIS

!!! Note "While a conceptual understanding of bundle adjustment is not necessary to follow this walkthrough, it is recommended that the user understands the basic concepts associated with the bundle adjustment process.  More information related to the bundle adjustment process can be found [here](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/jigsaw/jigsaw.html)."

This tutorial assumes that the user has access to ISIS command line utilities and an ISISDATA area.

## Step 1: Creating an Image List
Bundle adjustment inherently requires multiple observations, and ISIS expects these observations to be in the form of a line-separated text file (.lis) in which each line contains the name of a .cub file.  Assuming that all .cub files are present in the current directory, one convenient means of scraping the full paths of the .cub files into a .lis file is with:

```console
ls -d -1 "$PWD/"*.cub > image_list.lis
```

## Step 2: Adding Orientation Information to Cubes

This tutorial provides two methods of attaching orientation information to cubes -- `spiceinit` and `csminit`.

### Option 1: Attaching SPICE Information with spiceinit

[SPICE information](../../concepts/spice/spice-overview.md) allows the instrument that captured an observation to be localized, and it includes information related to the interior and exterior orientation of the instrument as well as the orientation of celestial bodies.  In order to perform bundle adjustment, each observation that is included in the adjustment process must have SPICE data attached. SPICE data can be attached using ISIS's `spiceinit` program.

While it is possible to `spiceinit` each image individually, ISIS includes a reserved `batchlist` parameter that allows the user to take advantage of the .lis file that was previously created.  In order to batch `spiceinit` each of the files in the input list, the user can issue the following command:

```console
spiceinit -batchlist=image_list.lis from=\$1
```

### Option 2: Attaching a CSM State String with csminit

Similarly to SPICE data, a CSM state string contains all the necessary information to localize an instrument over the duration of its observation.  CSM state strings differ in the sense that they capture the model's state as a mutable object that can be iteratively modified, captured, and transferred.  The `csminit` utility allows CSM states to be generated and attached to ISIS cubes.

The `csminit` utility requires users to pass an ISD alongside the images.  Instructions for ISD generation can be found [here](../../getting-started/csm-stack/image-to-ground-tutorial.ipynb/#2-generate-an-isd-from-a-cube).

This tutorial assumes that ISDs are named by simply appending a .json extension to the full path of the .cub, i.e. the ISD for `my_cube.cub` is stored in `my_cube.cub.json`.  If this requirement is satisfied, then the user can quickly and easily `csminit` a series of images with the batchlist parameter as follows:

```console
csminit -batchlist=image_list.lis from=\$1 isd=\$1.json
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

Finally, with all the prerequisite information generated and attached, it is possible to perform bundle adjustment.  Within ISIS, this is performed using the `jigsaw` utility. `jigsaw` is highly configurable, and it has many options that can be viewed [here](https://isis.astrogeology.usgs.gov/8.1.0/Application/presentation/Tabbed/jigsaw/jigsaw.html). 

### Command Line Usage

#### Option 1: For images without a CSM State String
If you chose option 1 (spiceinit) for step 2, then you should choose this option for jigsaw.  A basic command line invocation for jigsaw is as follows:

```console
jigsaw fromlist=image_list.lis cnet=control_network.net onet=control_network_jig.net update=no file_prefix=jig maxits=10 camsolve=angles camera_angles_sigma=.25
```

#### Option 2: For images with a CSM State String
If you chose option 2 (csminit) for step 2, then you must also choose this option for jigsaw. When using jigsaw to bundle adjust a `csminit`-ed image, the user must pass CSM-specific parameter names via the `csmsolvelist` parameter.  Allowable values and their descriptions are as follows.

| Parameter | Description |
|---|---|
| IT Pos. Bias     |  "In Track Position Bias" - a constant shift in the spacecraft's position parallel to the flight path |
| CT Pos. Bias    |  "Cross Track Position Bias" - a constant shift in the spacecraft's position perpendicular to the flight path |
| Rad Pos. Bias   |  "Radial Position Bias" - a constant shift in the spacecraft's "vertical positioning," i.e. distance from the target |
| IT Vel. Bias    |  "In Track Velocity Bias" - a time-dependent linear shift in the spacecraft's position parallel to the flight path |
| CT Vel. Bias    |  "Cross Track Velocity Bias" - a time-dependent linear shift in the spacecraft's position perpendicular to the flight path |
| Rad Vel. Bias   |  "Radial Velocity Bias" - a time-dependent linear shift in the spacecraft's "vertical positioning," i.e. distance from the target |
| Omega Bias      |  The initial omega angle (analogous to "roll") |
| Phi Bias        |  The initial phi angle (analogous to "pitch") |
| Kappa Bias      |  The initial kappa angle (analogous to "yaw") |
| Omega Rate      |  An angular rate that allows the omega angle to vary linearly with time |
| Phi Rate        |  An angular rate that allows the phi angle to vary linearly with time |
| Kappa Rate      |  An angular rate that allows the kappa angle to vary linearly with time |
| Omega Accl      |  An angular acceleration that allows the omega angle to vary quadratically with respect to time |
| Phi Accl        |  An angular acceleration that allows the phi angle to vary quadratically with respect to time |
| Kappa Accl      |  An angular acceleration that allows the kappa angle to vary quadratically with respect to time |
| Focal Bias      |  Estimated error of the camera's focal length |

An example of a jigsaw run using `csminit`-ed images is as follows:

```console
jigsaw fromlis=cubes.lis cnet=input.net onet=output.net radius=yes csmsolvelist="(Omega Bias, Phi Bias, Kappa Bias)" control_point_coordinate_type_bundle=rectangular control_point_coordinate_type_reports=rectangular point_x_sigma=50 point_y_sigma=50 point_z_sigma=50
```

### Jigsaw Graphical User Interface

Due to the complexity of jigsaw, some users may find that the graphical user interface is a more convenient starting point than the command line. In order to open the jigsaw GUI, the user can simply run:

```console
jigsaw
```

Documentation for each of jigsaw's parameters can be found [here](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/jigsaw/jigsaw.html)