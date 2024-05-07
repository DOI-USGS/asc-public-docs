# Bundle Adjustment in ISIS

!!! Info "While a conceptual understanding of bundle adjustment is not necessary to follow this walkthrough, it is recommended that the user understands the basic concepts associated with the bundle adjustment process.  More information related to the bundle adjustment process can be found [here](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/jigsaw/jigsaw.html)."

This tutorial is intended to walk a user through the process of bundle adjustment.  By following this tutorial, the user will be gain exposure to the following topics:

- Downloading and ingesting image data
- Creating a .lis file includes all images to be used in the bundle adjustment process
- Adding orientation information to the images
- Finding the geospatial extents of the images
- Finding overlapping portions of images
- Creating a basic control network
- Performing bundle adjustment
- Evaluating and understanding the results of bundle adjustment


## Step 0: Prerequisites and Setup
### ISIS Setup and Configuration
This tutorial assumes that the user has access to ISIS command line utilities and an ISISDATA area.  If you have not yet configured ISIS, follow the instructions to set up your environment [here](../environment-setup-and-maintenance/installing-isis-via-anaconda.md).

### Data Download
This tutorial uses a set of three overlapping images captured by the MRO CTX instrument.  To download the dataset used in this tutorial, the user can run the following curl commands:

```console
curl https://asc-pds-mars-reconnaissance-orbiter.s3.us-west-2.amazonaws.com/CTX/mrox_0039/data/P03_002156_2041_XI_24N097W.IMG -o P03_002156_2041_XI_24N097W.IMG
curl https://asc-pds-mars-reconnaissance-orbiter.s3.us-west-2.amazonaws.com/CTX/mrox_0142/data/P08_004213_2042_XI_24N097W.IMG -o P08_004213_2042_XI_24N097W.IMG
curl https://asc-pds-mars-reconnaissance-orbiter.s3.us-west-2.amazonaws.com/CTX/mrox_0755/data/B06_011821_2045_XI_24N097W.IMG -o B06_011821_2045_XI_24N097W.IMG
```

If you would prefer to use an alternate dataset but are unsure where to begin, consider using [PILOT](https://pilot.wr.usgs.gov/) to download a set of at least 3 images with overlapping portions.

### Exporting Data to ISIS Cubes
Finally, this tutorial requires that images are formatted as ISIS cubes.  ISIS includes ingestion programs that convert data from a variety of sources to ISIS cubes.  To convert the test dataset into ISIS cubes, the user can run the following command:

!!! Warning "The commands in this section are dataset-specfic.  If you choose to use an alternate dataset, you must use the ISIS ingestion program that corresponds to your data."

```console
mroctx2isis from=P03_002156_2041_XI_24N097W.IMG to=P03_002156_2041_XI_24N097W.cub
mroctx2isis from=P08_004213_2042_XI_24N097W.IMG to=P08_004213_2042_XI_24N097W.cub
mroctx2isis from=B06_011821_2045_XI_24N097W.IMG to=B06_011821_2045_XI_24N097W.cub
```
<details>
<summary>Output and Verification</summary>
Verify that the cubes were correctly exported by examining the attached label.  This can be accomplished with catlab.

```console
catlab from= P03_002156_2041_XI_24N097W.cub
```

If the cubes were created correctly, then catlab will print the following cube label to your terminal:

```text
Object = IsisCube
  Object = Core
    StartByte   = 65537
    Format      = Tile
    TileSamples = 1000
    TileLines   = 1024

    Group = Dimensions
      Samples = 5000
      Lines   = 30720
      Bands   = 1
    End_Group

    Group = Pixels
      Type       = SignedWord
      ByteOrder  = Lsb
      Base       = 0.0
      Multiplier = 1.0
    End_Group
  End_Object
  ...
```
</details>

## Step 1: Creating an Image List
Bundle adjustment inherently requires multiple observations, and ISIS expects these observations to be in the form of a line-separated text file (.lis) in which each line contains the name of a .cub file.  Assuming that all .cub files are present in the current directory, one convenient means of scraping the full paths of the .cub files into a .lis file is with:

```console
ls -d -1 "$PWD/"*.cub > image_list.lis
```

<details>
<summary>Output and Verification</summary>
The user can verify that the .lis file contains all the intended cubes by running:
```console
cat image_list.lis
```
The file should contain the full paths of each cube, which will differ per user, but should look similar to:
```text
/Users/your_username/bundle_tutorial/B06_011821_2045_XI_24N097W.cub
/Users/your_username/bundle_tutorial/P03_002156_2041_XI_24N097W.cub
/Users/your_username/bundle_tutorial/P08_004213_2042_XI_24N097W.cub
```
</details>

## Step 2: Adding Orientation Information to Cubes

This tutorial provides two methods of attaching orientation information to cubes -- `spiceinit` and `csminit`.

### Option 1: Attaching SPICE Information with spiceinit

[SPICE information](../../concepts/spice/spice-overview.md) allows the instrument that captured an observation to be localized, and it includes information related to the interior and exterior orientation of the instrument as well as the orientation of celestial bodies.  In order to perform bundle adjustment, each observation that is included in the adjustment process must have SPICE data attached. SPICE data can be attached using ISIS's `spiceinit` program.

While it is possible to `spiceinit` each image individually, ISIS includes a reserved `batchlist` parameter that allows the user to take advantage of the .lis file that was previously created.  In order to batch `spiceinit` each of the files in the input list, the user can issue the following command:

```console
spiceinit -batchlist=image_list.lis from=\$1
```
<details>
<summary>Output and Verification</summary>
The kernels group will be printed to the terminal after each image is spicinit-ed.  Additionally, the user can inspect the cube label with catlab:

```console
catlab from= P03_002156_2041_XI_24N097W.cub
```

If spiceinit was successful, then the user will find the following text in the cube label.

```text
  Group = Kernels
    NaifFrameCode             = -74021
    LeapSecond                = $base/kernels/lsk/naif0012.tls
    TargetAttitudeShape       = $mro/kernels/pck/pck00008.tpc
    TargetPosition            = (Table, $base/kernels/spk/de430.bsp,
                                 $base/kernels/spk/mar097.bsp)
    InstrumentPointing        = (Table,
                                 $mro/kernels/ck/mro_sc_psp_070109_070115.bc,
                                 $mro/kernels/fk/mro_v16.tf)
    Instrument                = Null
    SpacecraftClock           = $mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc
    InstrumentPosition        = (Table,
                                 $mro/kernels/spk/mro_psp2_ssd_mro110c.bsp)
    InstrumentAddendum        = $mro/kernels/iak/mroctxAddendum005.ti
    ShapeModel                = $base/dems/molaMarsPlanetaryRadius0005.cub
    InstrumentPositionQuality = Reconstructed
    InstrumentPointingQuality = Reconstructed
    CameraVersion             = 1
    Source                    = ale
  End_Group
```

</details>


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
<details>
<summary>Output and Verification</summary>
After running footprintinit, the user can once again check that the cube label was properly augmented with footprint information with
```console
catlab from= P03_002156_2041_XI_24N097W.cub
```

If the process ran correctly, the user will find the following information at the bottom of the cube label:

```text
Object = Polygon
  Name      = Footprint
  StartByte = 310243341
  Bytes     = 27198
End_Object
```
</details>


## Step 4: Creating an Overlap List using findimageoverlaps

An image overlap list contains a list of polygons that represent the overlapping portions of the input images.  Image overlap information plays a critical role in the initial placement of control points.  ISIS provides the `findimageoverlaps` program to aid in the production of overlap lists, which can be used as follows:

```console
findimageoverlaps fromlist=image_list.lis overlaplist=overlap_list.lis
```
<details>
<summary>Output and Verification</summary>
When the program completes, the following text will be displayed in the console:

```text
Group = Results
  ErrorCount = 0
End_Group
```

While it is possible to inspect the overlap list, it is a non human-readable format.  If you wish to inspect the file to ensure that it is not empty, you can use:
```console
less overlap_list.lis
```
</details>

## Step 5: Creating a Control Network with autoseed
In order to perform bundle adjustment, it is necessary to identify a set of locations per image (control points) that correspond to a set of ground locations (control measures).  Together, these points and measures are combined into a "control network." While there are multiple methods for generating a control network, this tutorial uses the `autoseed` utility to automatically generate a simple, grid-based control network.

### Configuring the algorithm with the definition file
`autoseed` requires a "definition file," which is responsible for configuring the algorithm that generates the control points.  To follow along with the tutorial, save the following snippet as `seeder.def`.

```text
Group = PolygonSeederAlgorithm
  Name             = Grid
  MinimumThickness = 0.01
  MinimumArea      = 10000
  XSpacing         = 10000
  YSpacing         = 10000
End_Group
```

### Generating a Control Network
After creating the definition file, the user can create a control network with the following `autoseed` command:

```console
autoseed fromlist=image_list.lis overlaplist=overlap_list.lis deffile=seeder.def onet=control_network.net networkid=test_net pointid="test_point_???" description="a test network used in the bundle adjustment tutorial"
```

<details>
<summary>Output and Verification</summary>
The user can check that the control network was created successfully using qnet.  Qnet is a GUI-only program, so the user should simply use:

```console
qnet
```

After opening qnet, the user should:

1. Select "file" from the menu bar, and "open control network and cube list."
1. Select image_list.lis for the image list
1. Select select control_network.net for the control network

This will populate the "Control Network Navigator" window with a list of cubes/control points.  The user should select all the control points (select the top point and shift+click the point at the bottom of the list), and select "view cubes." This will populate the main qnet window with the following cubes:

<img src="../../../assets/bundle_tutorial/qnet.png">

</details>

## Step 6: Performing Bundle Adjustment with Jigsaw

Finally, with all the prerequisite information generated and attached, it is possible to perform bundle adjustment.  Within ISIS, this is performed using the `jigsaw` utility. `jigsaw` is highly configurable, and it has many options that can be viewed [here](https://isis.astrogeology.usgs.gov/8.1.0/Application/presentation/Tabbed/jigsaw/jigsaw.html). 

### Command Line Usage

#### Option 1: For images without a CSM State String
If you chose option 1 (spiceinit) for step 2, then you should choose this option for jigsaw.  A basic command line invocation for jigsaw is as follows:

```console
jigsaw fromlist=image_list.lis cnet=control_network.net onet=control_network_jig.net update=no file_prefix=jig maxits=10 camsolve=angles camera_angles_sigma=.25
```

<details>
<summary>Output and Verification</summary>
</details>


#### Option 2: For images with a CSM State String
If you chose option 2 (csminit) for step 2, then you must also choose this option for jigsaw. When using jigsaw to bundle adjust a `csminit`-ed image, the user must pass CSM-specific parameter names via the `csmsolvelist` parameter.  Allowable values and their descriptions are as follows.

| Parameter | Description | Unit |
|---|---|---|
| IT Pos. Bias    |  "In Track Position Bias" - a constant shift in the spacecraft's position parallel to the flight path | |
| CT Pos. Bias    |  "Cross Track Position Bias" - a constant shift in the spacecraft's position perpendicular to the flight path | |
| Rad Pos. Bias   |  "Radial Position Bias" - a constant shift in the spacecraft's "vertical positioning," i.e. distance from the target | |
| IT Vel. Bias    |  "In Track Velocity Bias" - a time-dependent linear shift in the spacecraft's position parallel to the flight path | |
| CT Vel. Bias    |  "Cross Track Velocity Bias" - a time-dependent linear shift in the spacecraft's position perpendicular to the flight path | |
| Rad Vel. Bias   |  "Radial Velocity Bias" - a time-dependent linear shift in the spacecraft's "vertical positioning," i.e. distance from the target | |
| Omega Bias      |  The initial omega angle (analogous to "roll") | |
| Phi Bias        |  The initial phi angle (analogous to "pitch") | |
| Kappa Bias      |  The initial kappa angle (analogous to "yaw") | |
| Omega Rate      |  An angular rate that allows the omega angle to vary linearly with time | |
| Phi Rate        |  An angular rate that allows the phi angle to vary linearly with time | |
| Kappa Rate      |  An angular rate that allows the kappa angle to vary linearly with time | |
| Omega Accl      |  An angular acceleration that allows the omega angle to vary quadratically with respect to time | |
| Phi Accl        |  An angular acceleration that allows the phi angle to vary quadratically with respect to time | |
| Kappa Accl      |  An angular acceleration that allows the kappa angle to vary quadratically with respect to time | |
| Focal Bias      |  Estimated error of the camera's focal length | |

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