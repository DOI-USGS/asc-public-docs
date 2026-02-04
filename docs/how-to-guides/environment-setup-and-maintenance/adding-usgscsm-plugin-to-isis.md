# Adding the USGSCSM Plugin to ISIS ≤ 8.1

!!! warning "Only needed for ISIS 8.1 and earlier" 
      ISIS versions 8.2 and later include the USGSCSM library and do __not__ require a separate installation of the plugin.

      ISIS versions 8.0LTS, 8.1, and earlier _require_ a separate installation of the USGSCSM plugin as shown below.

## For users
You can install the latest [USGSCSM](https://github.com/DOI-USGS/usgscsm) library via conda:

```sh
conda install conda-forge::usgscsm
```

## For developers

???+ info "Plugin Install Location"
    For USGSCSM versions 2.0 and above, the plugin is installed in `$CONDA_PREFIX/lib/csmplugins/` in a conda environment.

### Plugin setup
If you are testing a new plugin or using older versions of USGSCSM/ISIS, you will need to update your `IsisPreferences` file located under the `ISIS3/isis` directory with the appropriate plugin path change. 

For example, if your `CONDA_PREFIX` path is not the same are your `ISISROOT` path, you can add `"$CONDA_PREFIX/lib/csmplugins/"` to your `IsisPreferences` file under `Group = Plugins`:

  ```
  Group = Plugins
    CSMDirectory = ("$CONDA_PREFIX/lib/csmplugins/", -
                    "$ISISROOT/lib/csmplugins/", -
                    "$ISISROOT/lib/isis/csm3.0.3/", -
                    "$ISISROOT/csmlibs/3.0.3/", -
                    "$HOME/.Isis/csm3.0.3/")
  EndGroup
  ```

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
