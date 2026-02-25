# Developing ISIS with cmake

## Getting Started With GitHub

1. **Make your own fork of ISIS:**  
   Go to the [main ISIS3 repo](https://github.com/DOI-USGS/ISIS3) and click on "Fork" at the top of the page.

1. **Get a cloning link:**  
   On your ISIS fork (url should be `github.com/<username>/ISIS3`), click on the green `Clone or Download` button on the right and copy the link.  

1. **Clone ISIS:**  
   Open a terminal, go to the directory you want to make a clone in, and run:  
   `git clone --recurse-submodules <your link>`  

Now that the files are on your computer, you can edit them, build ISIS, and contribute.

???+ note "Cloning Submodules later"

    If you have an old clone, or you forgot to add `--recurse-submodules` when you initially cloned ISIS, run this in the `ISIS3` directory to clone the `gtest` submodule:
    
    ```sh
    git submodule update --init --recursive
    ```

## Build Environment & Dependencies

### Getting Conda

Building ISIS requires conda.  If you need conda, install it through [miniforge](https://github.com/conda-forge/miniforge):
```sh
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```

### Activating an Environment

Conda manages dependencies and 3rd-party libraries to create a build environment (conda env) for ISIS. The cmake build system expects an active [conda env](https://conda.io/docs/user-guide/tasks/manage-environments.html#activating-an-environment) containing these dependencies, which are listed in the [environment.yml](https://github.com/DOI-USGS/ISIS3/blob/dev/environment.yml).

To create and activate a conda env, run these commands in the ISIS3 directory.

```sh
# Create
conda env create -n isis-dev-env -f environment.yml

# Activate
conda activate isis-dev-env
```

!!! quote ""

    *We chose the env name, "isis-dev-env", but you can name your env something else if you want.*

    *Your terminal prompt should look now be preceded by `(isis-dev-env)`. 
    This indicates that you are in an active conda env, 
    which you will need to build ISIS.*

## Building ISIS3 

### 1. Create a `build` directory

```sh
# From inside the ISIS3 directory:
mkdir build
```

*There should now be a "build" subdirectory alongside the "isis" subdirectory.*

### 2. Set Env Variables

Set `ISISROOT` to point to your build directory.  
See [the ISIS Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md) 
to set up ISISDATA and ISISTESTDATA so you can import mission data and run tests.  

```sh
export ISISROOT=/yourCodeDirectory/ISIS3/build

export ISISDATA=/yourDataDirectory/isisdata
export ISISTESTDATA=/yourDataDirectory/isistestdata

# You may want to add these to your .bashrc or .zshrc, 
# so you don't have to set them every time.
```

### 3. `make` ISIS

```sh
cd build               # Enter the build directory (or wherever cmake was run)
cmake -GNinja ../isis  # run cmake on the ISIS3/isis directory
```
*If you run `cmake` from a different directory, change `../isis` to point to the `isis` subfolder under `ISIS3`.*

### 4. Build ISIS

```sh
# From inside your build directory
ninja install

# This may take a while, around 20 min to an hour.
```


??? Tip "Build Flags and Tips"

    Use these flags in the `cmake` command to configure your build.

    `-GNinja`  
    Makes a [Ninja](https://ninja-build.org/manual.html) Makefile (alternative to GNU `make`). To use `make`, omit this flag and replace the `ninja` commands with their `make` counterparts.

    `-DJP2KFLAG=ON`  
    Enables JP2000 support. (Not available on ARM builds.)

    `-Dpybindings=OFF`  
    Disables the bundle adjust python bindings.

    `-DCMAKE_BUILD_TYPE=Debug`  
    Build with debug flags.

    ***More Build Options:***  
    Look for `# Configuration options` in [isis/CMakeLists.txt](https://github.com/DOI-USGS/ISIS3/blob/dev/isis/CMakeLists.txt#L63). 
    Use `-D` flags to turn these options on or off.  
    For example, to build ISIS with no tests and no docs:
    ```sh
    cmake -DbuildDocs=OFF -DbuildTests=OFF -GNinja ../isis
    ```

    ***Executables Location:***  
    Executables are placed in `build/bin` (and linked in `$CONDA_PREFIX/bin`).  
    For Example, to use ddt (with `$ISISROOT` set to the build directory):  
    ```sh
    ddt $ISISROOT/bin/<application_name>
    ```
 
## Environmental Variables and Common Directories

***$ISISROOT points to either:***  

- (For Dev) The CMake build directory  
  `ISISROOT=/codedirectory/ISIS3/build`  

- (For Production) The install directory for running a deployed copy of ISIS. 
  `ISISROOT=$CONDA_PREFIX`

***$ISISDATA***  
Points to the NAIF SPICE Kernels, which contain spacecraft geometric and timing information that ISIS needs to process and align spacecraft images.
This data must be downloaded, unless you are using the [SpiceQL web service](../../how-to-guides/SPICE/using-web-spice-in-isis-and-ale.md). See [ISIS Data Area](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md) for more info on how to download and set up `ISISDATA`.

***$ISISTESTDATA***  
Points to data for legacy ISIS Makefile tests.  This data must be downloaded.  See [ISIS Test Data](../../how-to-guides/isis-developer-guides/obtaining-maintaining-submitting-test-data.md).

***Source Directory*** (`ISIS3/isis`):  
Where the ISIS source code lives, the lowercase `isis` subdirectory of `ISIS3`. If you are in build, this would be `../isis` as a relative path.

***Build Directory*** (`ISIS3/build`):  
Where generated project files live (Makefiles, Ninja files, Xcode project, etc).  Holds the `bin` directory where binaries are built to.

***Custom Data and Test Data***:  
The addition of test data files should be limited. Contributions to $ISISTESTDATA are no longer accepted. 
If a [test fixture](../../how-to-guides/isis-developer-guides/writing-isis-tests-with-ctest-and-gtest.md#test-fixtures) requires extra data, that data should be placed in `ISIS3/isis/tests/data`.

## Cleaning Builds

**Using the Ninja Build System:**

Removes all built objects except for those built by the build generator:  
  `ninja -t clean` 

Remove all built files specified in rules.ninja:  
  `ninja -t clean -r rules` 

Remove all built objects for a specific target:  
  `ninja -t clean <target_name>` 

Get a list of Ninja's targets:  
  `ninja -t targets`

**Manual Cleans**

Cleaning all of ISIS:  
 `rm -rf build`

Cleaning an individual app:  
 `cd build && rm bin/<app_name>`

Cleaning an individual object:  
 ``cd build && rm `find -name ObjectName.cpp.o` ``

## Building Individual ISIS3 Applications/Objects

### Applications 

The command (from the build directory) is:  
`make install <appname>`

To build fx:  `make install fx`

### Objects

`make install isis3 -j7`: If you make a change to one class in the ISIS3 API, 
it compiles and builds everything.  This can take awhile.

If you are using Ninja the command is:

`ninja install libisis3.so`

The nice thing about Ninja is that it re-compiles whatever class you modified,
and then re-links all the applications/objects/unit tests which have dependencies
on that object.  In the case of a heavily used class like Pixel, this equates to 865 objects.
It's still a lot faster then using cmake generated Makefiles.

## CMake Behavior When Adding/Removing/Modifying an Object

The cmake configure command needs to be executed when adding/removing a new object so that the system sees and compiles it.  

## Building ISIS3 Documentation

At present under the current system there is no way to build documentation for individual applications/objects.  To build all documentation using the ninja build system, CD into the build directory and enter the following command:

=== "ninja build system"

    ```sh
    ninja docs -j7
    ```

=== "classic make"

    ```sh
    make docs -j7
    ```

The documentation is placed in `install/docs` (after being copied over from `build/docs`).

## Building in Debug Mode
1. reconfigure cmake with flag (`-DCMAKE_BUILD_TYPE=DEBUG`)
2. rebuild

## Tests

### ISIS Test Data

See [ISIS Test Data](../../how-to-guides/isis-developer-guides/obtaining-maintaining-submitting-test-data.md) for info on downloading and setting up the data used in legacy makefile-based tests.

### Identifying Tests
The test names are as follows:   

* unit test : `<modulename>_unit_test_<objectname>`
* app test : `<appname>_app_test_<testname>`
* cat test :  `<modulename>_module_test_<testname>`

All cat tests under base, database, control, qisis, and system are listed under the isis3 module.

### Running Tests

ISIS tests now work through [ctest](https://cmake.org/cmake/help/v3.9/manual/ctest.1.html). Unit tests are by default put into the `build/unitTest` directory. The most simple way to run test of a certain type is using the `-R <regex>` option, which only runs tests which match the regex.

It is important to note the many of the tests rely on an `ISISROOT` environment variable to be set to the build directory. If it is not set you will see almost all tests fail.
App test must have the bin in the build directory appended to the environment path.
Using the `setisis` script on your build directory should fix these environment issues for you.

```
# inside your build directory

ctest               # run all tests
ctest -R _unit_     # run unit tests
ctest -R _app_      # run app tests
ctest -R _module_   # run module (cat) tests
ctest -R jigsaw     # run jigsaw's app tests
ctest -R lro        # run all lro tests
ctest -E tgo        # Run everything but tgo tests
```
### Building New Tests

The workflow for creating a new tests will be the same as the old ISIS make system besides adding test data. See [Make Truth Replacement](#make-truth-replacement) below for how this set in the process changes.


### App Tests and Category Tests

App/Category tests still leverage the old make system, they work using the standard ISIS app/category test workflow for now.
App/Category tests can be developed in the ISIS src tree similar to the old make system. As long as the path is pointing to the binaries in the build directory (`build/bin`); `make output`, `make test`, `make compare`, `make truthdata`, and `make ostruthdata` all work. You cannot run all tests from the root of the ISIS source tree. To accomplish this use ctest in the build directory, see above. If there is testdata in the ISIS source tree ctest will test with that data.

### Unit Tests

Unit test no longer rely on the old ISIS make system. The unitTest.cpp of each object are compiled and an executable is made and saved in the unitTest sub-directory of the build directory. A symbolic link of the unit test executable is created in the object's directory. This allows the unit test to get files that it needs inside the object's directory, i.e. unitTest.xml. If a unit test passes, then the symbolic link is removed. If you want to run a passing unit test in debug mode, you will have to create a symbolic link of the unit test in the object's directory yourself. If you are inside the object's directory:

`ln -s $ISISROOT/unitTest/<unit_test_name> unitTest`

Steps To Create A New UnitTest:

1. Create unitTest.cpp under new object directory in ISIS src tree
2. re-configure cmake
3. rebuild
4. Use makeOutput.py (see below) to create new truth data

??? example "Example Ctest Output"

    ```
    98% tests passed, 7 tests failed out of 394

    Total Test time (real) = 171.11 sec

    The following tests FAILED:
        11 - isis3_unit_test_Application (Failed)
        97 - isis3_unit_test_IException (Failed)
        174 - isis3_unit_test_Pipeline (Failed)
        201 - isis3_unit_test_ProcessExportPds4 (Failed)
        211 - isis3_unit_test_ProgramLauncher (Failed)
        303 - isis3_unit_test_UserInterface (Failed)
        338 - isis3_unit_test_MosaicSceneWidget (Failed)
    Errors while running CTest
    ```

<div class="grid cards" markdown>

- To learn more about **Ctest**, check out the 
  [Ctest Docs :octicons-arrow-right-24:](https://cmake.org/cmake/help/v3.9/manual/ctest.1.html)

</div>

### Make Truth Replacement

The MakeTruth functionality that exists in the Makefiles of the old make system now exists in a script (makeOutput.py) located in `ISIS3/isis/scripts/makeOutput.py`.
A developer will want output of a test before setting it as truth data. This is currently done with the following command in the form of:

    python3 makeOutput.py test

where test is the cmake name for the unit or app test. It is important to note that this command must be ran from the the src directory, i.e., the object's directory that output is being made for.
For unit tests, this will output a file in the form of <objectname>.truth in the directory `build/testOutputDir`.
For app tests, this will output a directory (truth) in the directory `build/testOutputDir` that contains the truth data for the app test.

To check in truth data the command should be in the form of:

    python3 makeOutput.py -t test

Example makeOutput.py for object Apollo:
```shell
command:    python3 $ISISROOT/../isis/scripts/makeOutput.py apollo_unit_test_Apollo
output:     Unit Test Output In /scratch/cmake/isis3_cmake/build/testOutputDir/ As Apollo.truth
```

```shell
command:    python3 $ISISROOT/../isis/scripts/makeOutput.py apollo_unit_test_Apollo -t
output:     Checked In Truth Data To /scratch/cmake/isis3_cmake/isis/src/apollo/objs/Apollo/Apollo.truth
```
When making OS specific truth data, do not add the "-t" flag. Instead, you will need to rename the output and copy it to the directory of the object or app you are making truth data for.

* For unit tests, you will need to rename the output put in build/testOutputDir as `<objectname>_<OStype>_x86_64_<OSname>.truth`. If we wanted to make Mac truth data for ProgramLauncher: "ProgramLauncher_Darwin_x86_64_MacOSX10_13.truth".

* For app tests, you will need to rename the truth directory put in build/testOutputDir as
`truth.<OStype>.x86_64.<OSname>`. If we wanted to make Mac truth data: "truth.Darwin.x86_64.MacOSX10_13".

### Checking Test Coverage 

ISIS uses `gcovr` to track test coverage. PRs will not be approved if they drop coverage by more than 2%, though exceptions can be made for large feature adds. This step happens after tests have run, as coverage is detected based on the last ctest run. 

```bash
ninja test_coverage_ascii # generate ascii table to stdout 
ninja test_coverage_html  # generate interactive webpage 
                          # open HTML at $ISIS_BUILD_DIR/test_coverage_html/index.html
```

The remote CI coverage checks (on the PR) generate an ASCII table.  Locally, generating HTML reports is recommended, as they contain interactive access to line hits and misses. 

When reading CI coverage on [ISIS CI builds](https://us-west-2.codebuild.aws.amazon.com/project/eyJlbmNyeXB0ZWREYXRhIjoiNDJNZ2MxbHFKTkwxV1RyQUxJekdJY3FIanNqU29rMHB4Nk1YUzk4REIrZUZDeEtEaW9HQlZ1dTZOSHpML2VUTGVDekYydmVFcU9sUHJKN20wQzd1Q0UzSzJscnB0MElDb1M3Ti9GTlJYR1RuMWJTV3V1SkJTa3NoYmc9PSIsIml2UGFyYW1ldGVyU3BlYyI6IjF3U2NTSGlDcEtCc29YVnEiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D), test coverage will be at the bottom of the logs once CI is complete.  The CI first **builds**, then **tests**, then checks **test coverage**.  You may have to scroll quite a bit to reach the desired section.

??? example "Test Results and Coverage Report in ISIS CI Build Log"

    ```bash
    100% tests passed, 0 tests failed out of 2705

    Total Test time (real) = 2145.30 sec

    The following tests did not run:
        1258 - TempTestingFiles.FunctionalTestJitterfitDefault (Disabled)
        1302 - TempTestingFiles.UnitTestImageImporterTestJpeg (Disabled)
        1553 - DefaultCube.FunctionalTestNoprojExpand (Disabled)
        1900 - MroCtxCube.FunctionalTestCtxcalDefault (Disabled)
        1903 - MroCtxCube.FunctionalTestCtxcalIofFalse (Disabled)
    [1/1] Generating gcovr ASCII coverage report.
    (INFO) Reading coverage data...
    (INFO) Writing coverage report...
    ------------------------------------------------------------------------------
                            GCC Code Coverage Report
    Directory: .
    ------------------------------------------------------------------------------
    File                                       Lines    Exec  Cover   Missing
    ------------------------------------------------------------------------------
    src/apollo/apps/apollo2isis/main.cpp         242       0     0%   50-54,56,58-59,61,63,66-68,71-72,74,77-78,80,82-84,87,89-100,102-105,112-116,119-124,126,131-145,147-150,152-155,158-160,163-164,167-176,178-179,181-182,185-188,193-195,198,200-205,207-209,213-216,219,223,228,230-232,234-236,238-244,246-250,252-253,255-257,260-263,265-266,269,272-273,275,278-283,286-288,290-292,295-298,300,302-307,310-315,318-328,331-333,336-338,341-343,347-350,355-357,359-361,363-365,369-371,374-384,386-387,389-393,395,398-401,403,406-408
    src/apollo/apps/apollocal/apollocal.cpp       38      33    86%   26-29,74
    src/apollo/apps/apollocal/main.cpp             4       0     0%   16-19
    .
    . Snip, many such files
    .
    src/voyager/apps/voycal/main.cpp             173     140    80%   69-72,82-85,90-93,118-123,155-160,247,312-314,334,343,345,347,349
    src/voyager/apps/voyramp/main.cpp             85      71    83%   75-78,82-84,95-99,197-198
    src/voyager/objs/VoyagerCamera/VoyagerCamera.cpp
                                                78      67    85%   87-90,111-114,133-135
    ------------------------------------------------------------------------------
    TOTAL                                     130854  102073    78%
    ------------------------------------------------------------------------------
    lines: 78.0% (102073 out of 130854)
    functions: 86.4% (7023 out of 8131)
    branches: 42.6% (121959 out of 286413)
    ```

You should check your results to the last dev build to see if your coverage increased or decreased.

### Static Code Checking

ISIS uses [`cppcheck`](https://cppcheck.sourceforge.io) for static code checking, to catch security vulnerabilities and undefined behavior that other methods may miss.  In [ISIS CI](https://us-west-2.codebuild.aws.amazon.com/project/eyJlbmNyeXB0ZWREYXRhIjoiNDJNZ2MxbHFKTkwxV1RyQUxJekdJY3FIanNqU29rMHB4Nk1YUzk4REIrZUZDeEtEaW9HQlZ1dTZOSHpML2VUTGVDekYydmVFcU9sUHJKN20wQzd1Q0UzSzJscnB0MElDb1M3Ti9GTlJYR1RuMWJTV3V1SkJTa3NoYmc9PSIsIml2UGFyYW1ldGVyU3BlYyI6IjF3U2NTSGlDcEtCc29YVnEiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D), this is checked after running tests, close to the end of the log.

```bash
cppcheck your-new-contribution.cpp --enable=all --suppress=missingInclude --suppress=missingIncludeSystem --suppress=unmatchedSuppression
```

## Troubleshooting

**If you get the following error message when trying to set up your environment**:

```
conda env create -n cmake -f environment.yml
Using Anaconda Cloud api site https://api.anaconda.org
Error: invalid package specification: ninja==1.7.2=0
```

Update your conda installation using `conda update` and then try again. 


**If you get the following error message while testing on a Mac**:
```
bash: line 10: /usr/local/bin/grep: No such file or directory
bash: line 11: /usr/local/bin/grep: No such file or directory
bash: /usr/local/bin/grep: No such file or directory
```

Check to see if grep is installed in `/usr/local/bin`. If grep is not installed, install grep with Homebrew:

`brew install grep -with-default-names`

This will install GNU grep under the name "grep". If you do not add the flag at the end, GNU grep will be installed under "ggrep" instead. 

If ggrep is installed, run the following commands:
```
brew uninstall grep
brew install grep -with-default-names
```

