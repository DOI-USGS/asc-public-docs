# Adding USGSCSM Plugin to ISIS

## For users
You can install the latest [USGSCSM](https://github.com/DOI-USGS/usgscsm) library via conda:

```sh
conda install conda-forge::usgscsm
```
## For developers

### Plugin setup
Update `IsisPreferences` file under `Group = Plugins` and add `"$CONDA_PREFIX/lib/csmplugins/"`, for example:

  ```
  Group = Plugins
    CSMDirectory = ("$CONDA_PREFIX/lib/csmplugins/", -
                    "$ISISROOT/lib/csmplugins/", -
                    "$ISISROOT/lib/isis/csm3.0.3/", -
                    "$ISISROOT/csmlibs/3.0.3/", -
                    "$HOME/.Isis/csm3.0.3/")
  EndGroup
  ```

??? info
    If you want to find where the installation path is being defined, look [here](https://github.com/DOI-USGS/usgscsm/blob/main/CMakeLists.txt#L712).

### Using your local build
If you are working on USGSCSM, you can build a local conda package of USGSCSM and install that in your ISIS conda environment for testing. 

#### Step 1: Create your local build
First, activate your ISIS environment:
```sh
conda activate isis3
```

Second, go to your USGSCSM `/build` directory if it already exists and remove the CMakeCache.txt file:
```sh
cd <path-to-repos>/usgscsm/build
rm -rf CMakeCache.txt
```

Third, run `cmake` while specifying the installation to be located in your currently activated conda environment's directory:
```sh
cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX/
```

???+ note
    Verify that you are in an activated conda environment: `echo $CONDA_PREFIX`

Once the `cmake` command has finished running, build and install your local build:
```sh
make
make install
```

#### Step 2: Install your local build
First, make sure you are in the conda environment you installed the USGSCSM library to.

Second, check if the USGSCSM package is conda installed. If so, remove it from your environment:

```sh
conda list usgscsm
conda remove --force usgscsm
```

Third, remove the cmake cache from your ISIS build dir and [re-build ISIS](../isis-developer-guides/developing-isis3-with-cmake.md#building-isis3):

```sh
cd <path-to-repos>/ISIS3/build
rm -rf CMakeCache.txt
```

#### Step 3: Test your local build
Make sure your local build of USGSCSM is installed properly by running `csminit`:
```sh
which csminit
csminit -h
```
