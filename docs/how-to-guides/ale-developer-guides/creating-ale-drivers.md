# Step by Step ALE Driver Creation

This guide provides step-by-step instructions for creating an ALE driver for an instrument that is already implemented in ISIS.

## Prerequisites 
1. Clone and build [ISIS](https://github.com/USGS-Astrogeology/ISIS3/wiki/Developing-ISIS3-with-cmake) locally.
1. Download base and mission kernels related to the driver you plan to implement.  One means of downloading this kernels is through ISIS's [downloadIsisData script](https://github.com/DOI-USGS/ISIS3/blob/dev/README.md#partial-download-of-isis-base-data).
1. Fork [the ALE repository](https://github.com/USGS-Astrogeology/ale)
1. Clone from your fork (with the recursive flag to clone submodules as well):
    ```sh
    git clone --recurse-submodules -j8 git@github.com:[username]/ale.git
    ```
1. Add ALE to your ISIS environment
    - In a terminal, navigate to the base directory of your cloned ALE repo
    - Activate your ISIS environment and update with ALE
        ```sh
        conda activate <isis> # <isis> should replaced with the name of your isis environment
        conda env update -n <isis> -f environment.yml
        ```
    - Set variables and add ISIS binaries to PATH:
        ```sh
        export ISISROOT=[isisRepoLocation]/ISIS3
        export PATH=$PATH:[isisRepoLocation]/ISIS3/bin
        ```
    - Uninstall any preexisting versions of ALE and link in the development version:
        ```sh
        pip uninstall ale #run 2 or 3x to ensure that all ALE versions are removed
        python setup.py develop
        ```

## Data Setup and Initialization

1. Copy a .cub to a local data area for testing.  See [Data Sources](#data-sources) for a list of data archives.
1. In your local testing area, create 2 copies of the .cub for testing -- one with ALE and one with ISIS
        ```sh
        [cubename].ale.cub
        [cubename].isis.cub
        ```
1. Initialize the ISIS .cub with spiceinit
        ```sh
        spiceinit from= [cubename].isis.cub
        ```
!!! NOTE "Spiceinit driver order"
    `spiceinit` uses the first driver that works, and begins by looking for an ALE driver.  If no suitable ALE driver is found, then spiceinit will default to the ISIS implementation.  This design decision encourages a 'fail fast' approach by first checking that basic elements of the image match those in the driver (such as the instrument id).  If you need to initialize a cube with an ISIS driver after creating an ALE driver, it is possible to force a failure in the ALE driver by introducing a syntax error into one of the driver's methods.

## Creating the ALE driver
### Creating and Naming the Class
1. If it doesn't exist, create a python file in `ale/base/drivers` for the spacecraft name followed by `_drivers` (e.g. `hayabusa_drivers.py`)
1. Create a class
    - See [Class Signature](#class-signature) for naming conventions
    - Add these common functions (and others as needed):
        - `instrument_id`
            - map the sensor name to the spacecraft name as shown in the [NAIF Toolkit Docs](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/FORTRAN/req/naif_ids.html)
            ```py
            @property
            def instrument_id(self):
                id_lookup = {
                    'CaSSIS': 'TGO_CASSIS',
                }
                return id_lookup[super().instrument_id]
            ```
        - `sensor_model_version`
            - Should almost always return 1.
            ```py
            @property
            def sensor_model_version(self):
                return 1
            ```
!!! TIP "Borrow from existing drivers"
    ALE drivers largely follow the same format.  If you feel stuck, borrow the structure of another driver and customize it to fit your instrument!

### Creating Methods to Customize the Driver
ALE drivers largely follow the same structure, but individual methods differ among instruments. The mixins with which your class are built (e.g. "LineScanner") provide a best effort to supply default functionality, but it is unlikely that all of your class's methods will use the default values.  The process of adding methods is largely a matter of trial and error in 1. Getting spiceinit to fully initialize the image using the ALE driver and 2. getting the ALE driver's output to match ISIS's output.

1. Perform an initial best-attempt at filling in the necessary methods (see the common functions above)
1. Run spiceinit on the ALE cube (`spiceinit from= [cubename].ale.cub`)
1. Look for errors from the ale driver (`[spacecraftname]_driver.py`).  This should let you see what methods haven't been covered by mixins. You will need to write these methods yourself in the driver.
1. Based on the errors you receive, add necessary methods, test, and repeat until spiceinit succeeds with the ale driver and outputs a cube from `source = ale` (and not `source = isis`).
    - To set your ISIS conda environment to use your local ALE instance:
    ```
    # Activate your ISIS conda environment
    $ conda activate isis3

    # Check which ALE dependency ISIS is using
    $ conda list ale

    # Remove only ALE and not its dependencies
    $ conda remove --force ale

    # Install dev build to ISIS's conda dir
    $ cd <path-to-ale-repo>/ale/build
    $ rm -rf CMakeCache.txt
    $ cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX/
    $ make
    $ make install
    $ cd ..
    $ python setup.py develop

    # Rebuild ISIS to point to dev build
    $ cd ../ISIS3/build
    $ rm -rf CMakeCache.txt
    $ cmake -DJP2KFLAG=ON -Gninja <path-to-isis-repo>/ISIS3/isis
    $ ninja -j24

    # Verify ALE dependency is dev build
    $ conda list ale
    ```
1. Compare ALE .cub to ISIS .cub
    - Generate Labels for the ISIS and ALE Cubes
        ```sh
        catlab from= [cubename].isis.cub to= [cubename]_isis.lbl
        catlab from= [cubename].ale.cub to= [cubename]_ale.lbl
        ```
    - Compare ALE Label to the ISIS Label to check the accuracy (using the ISIS label as truth data).
        ```sh
        vimdiff [cubename].isis.lbl [cubename].ale.lbl
        ```
1. Adjust the functions as necessary until the ALE init'd .cub matches the ISIS init'd .cub

## Preparing Test Data
1. Create a data directory within `ale/tests/pytests/data/` based on your .cub name
1. Slice the Kernels with ALE's kernel slicing notebook (ale/notebooks/KernelSlice.py)
    - This will require some customization based on your instrument, specifically to PVL structure
    - Requires the separate installation of [ckslicer](https://naif.jpl.nasa.gov/naif/utilities.html) (select your operating system -> CKSlicer).
1. Copy transfer kernels into the test data directory that you created above
    - See [Test Data](#test-data) for what data you will need to copy.
1. Generate an isd using ALE's `isd_generate` utility and copy it into `ale/tests/pytests/data/isds/`
1. Copy Test Data
    - In `tests/pytests/data`, make a directory named after your test cube.
    - Copy an ISD into `tests/pytests/data/isds` 
1. Test with PyTest
    - In `ale/pytests/` make a python file called `test_[spacecraftname]_drivers.py`
    - To start out, you may want to look at the structure of another test.
    - Make a `kernels` test function and a load test function.
    - Make a class with a test for each method you added to your driver. They should assert the value that was set in that function.
        - if your driver function calls other functions (like scs2e or gdpool), the value should be patched.
    - Run your test, fix mismatched asserts, and fix failing tests.
        ```sh
        pytest tests/pytests/test_[spacecraft]_drivers.py
        ```
***
## References and Supplementary Instructions

### Data Sources

#### Kernels
- A combination of Documentation and Metadata
- `isisDataArea/isis_data/[spacecraftname]/kernels/ik`
- `iak` (instead of ik) for addendum kernels

#### PDS Image Atlas
- https://pds-imaging.jpl.nasa.gov/search/

#### Lunar Orbital Data Explorer
- https://ode.rsl.wustl.edu/moon/productsearch

#### ISIS test Cubes
- Cubes contain metadata and an image from a spacecraft.
- `isisDataArea/isis_testData/isis/src/[spacecraftname]/unitTestData`

#### Generating Cubes
- If the cube you want is absent, generate it with an [ISIS program, documented here](https://isis.astrogeology.usgs.gov/Application/index.html).  
(look for an `[instrument]2isis` program under the appropriate mission.)
- Test Data can often be found here:
    ```
    /isis_testData/isis/src/[spacecraft]/apps/[sensor]2isis/tsts/[varies]/input`
    ```
#### Camera CPPs implemented in ISIS
- `myRepoLocation/ISIS3/isis/src/[spacecraftname]/objs/[sensorname]/[sensorname].cpp`

#### Labels and Fields
For more info on what a specific label or field might mean, check these sources:
- [ISIS Label Dictionary](https://isis.astrogeology.usgs.gov/documents/LabelDictionary/LabelDictionary.html)
- [NAIF Required Readings for SPICE](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/C/req/index.html) (You may have to do a bit of digging here.)

#### Internet
- [NAIF PDS Toolkit Docs](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/)
- Web search

### Class Signature
The class signature for your driver should follow this format.  See each letter below for guidance on how to name the class/what mixins to use.
```py
# e.g, class HayabusaAmicaIsisLabelNaifSpiceDriver(Framer, IsisLabel, NaifSpice, RadialDistortion, Driver):
class [A][B][C][D]Driver ([E], [C], [D], [F], Driver):    
```

#### A - Spacecraft Name
The name of the spacecraft and/or mission (e.g. Messenger, Hayabusa, Galileo, Odyssey).

#### B - Instrument Name
The name of the specific sensor on the spacecraft (e.g. AmicaCamera, NarrowAngleCamera, ThemisIr).  Often shortened to an acronym or abbreviation (TO DO: When is it shortened and how do I find the short name?).

#### C - Label Type: IsisLabel or PDS3Label
- Most common: IsisLabel
- PDS3Label is rare
- If dealing with an ISIS converted cube .lbl -> ISIS Label.
- If you haven't done a x_to_isis conversion -> PDS3 

#### D - Auxiliary Data Type: IsisSpice or NaifSpice
- Most common: NaifSpice
- IsisSpice is rare
- If the spice data is already attached, IsisSpice can use the data already attached

#### E - Camera Type: Framer, LineScan, or (rare) PushFrame
Can be found in ISIS Implementation.

Possibly from the instrument Kernel: see if the CENTER is in the middle of the square (framer) or the first line (line scan).  Or the kernel documentation may say directly.

#### F - Distortion Type
- RadialDistortion and then NoDistortion are the most common
- Usually can find in the IK or IAK in isis_data
- Look in Kernel or IAK for ODK, ODTK, Distortion, Optical
- TRANSX and TRANSY are distortion coefficients

#### G - Last Mixin is always Driver


### Test Data

1. In the last cell of the `KernelSlice.ipynb` Jupyter Notebook, is the `kernels` command.  As the last step of the Kernel Slicing, run this command to generate a list of the necessary Kernels.
1. For any Binary Kernels ending in `.bsp` or `.bc`, the `.xsp` and `.xc`, Transfer Kernels generated in the Kernel Slicing output directory should take their place in the ALE test data for your instrument.
1. For the rest of the Kernels listed (not ending in `.bsp` or `.bc`), copy them into the the ALE test data for your instrument.
1. Check if your test data folder is missing kernels (like `fk` and `sclk`) and copy those kernels from the `isis_data` area into your test data folder.
1. Copy/paste the `naif0012.tls` kernel from another ALE test data area.
1. Finally, the isis label (that we made with catlab, ending in `_isis.lbl`) is needed as truth data.  Copy it into the ALE test data directory

For more info on these kernels and what each is for, see the [Intro to Kernels](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/Tutorials/pdf/individual_docs/12_intro_to_kernels.pdf) or read more about specific Kernels in the [NAIF Toolkit Docs](https://naif.jpl.nasa.gov/pub/naif/toolkit_docs/Tutorials/pdf/individual_docs/).

