# ISIS Test Data

### GTests and Legacy Makefile-based Tests

ISIS has of two types of tests: custom **Makefile** based tests, and **GTests**. The GTests use data from the ISIS repo along with the source, so no special data is required to run those, aside from the ISIS data area.

The Makefile tests depend on a separate source of input and truth data data.  The `$ISISTESTDATA` environmental variable is used to locate that data.  The size of this test data decreases as we convert more Makefile tests to GTests.

### Test Types

  - **Unit Tests** - tests for nearly every C++ class or struct in the ISIS library
    - Examples: `Histogram`, `ProcessByLine`, or `VoyagerCamera`
  - **Application Tests** - regression tests for individual applications
    - Examples: `fx`, `lowpass`, or `cam2map`
  - **Module Tests** - regression tests for chains of multiple applications
    - Example: `vims2isis` → `spiceinit` → `cam2map`

### Data Locations

#### GTests

Test data for **GTests** is usually embedded in the test source code under `$ISISROOT/isis/tests`.

#### Makefile-based Tests

Input data for the make-based tests is embedded in the `unittest.cpp` in the source code directory for the class, or an external file in the `ISISDATA` or `ISISTESTDATA` areas. Output test data for the **make**-based tests is always in the source code directory for the class.

Regression tests have both input and truth data stored in the `ISISTESTDATA` area. Input and truth data files can be ISIS cubes, control networks, plain text, Parameter Value Language (PVL), Planetary Data System images (PDS3, PDS4), or comma-separated value (CSV) files.

## Setting Up Tests

### ISIS Development Environment

To run and develop tests, you need a [full ISIS development environment](../../how-to-guides/isis-developer-guides/developing-isis3-with-cmake.md). The public releases don't include the test source code or data.

### Environmental variables
The environmental variable `ISISTESTDATA` needs to point to the path where you want to store the ISIS Test Data.


=== "conda"

    ```sh
    # Activate your environment
    conda activate isis

    # Set the variable
    conda env config vars set ISISTESTDATA=/path/to/your/isis_test_data/

    # Reactivate your environment
    conda deactivate
    conda activate isis
    ```

=== "shell"

    ```sh
    export ISISTESTDATA=/path/to/your/isis_test_data
    ```

=== "csh/tcsh"

    ```sh
    setenv ISISTESTDATA=/path/to/your/isis_test_data
    ```

### Downloading Test Data

ISIS *unit* and *regression* tests require the data and test data directories to be available, and need their respective environment variables (`ISISDATA`, `ISISTESTDATA`) to be set. This allows the tests to read files from these areas and compare results to known truth data.

??? info "Prerequisite: `rclone`"

    Test data is hosted in Amazon S3. We recommend using the `downloadIsisData` script (which depends on rclone), or [rclone](https://rclone.org) itself, to download the data. You can install rclone with homebrew or conda:

    === "homebrew"

        ```sh
        brew install rclone
        ```

    === "conda"

        ```sh
        conda install –c conda-forge rclone
        ```

#### To download the ISIS Test Data:

=== "downloadIsisData script (easy)"

    ```sh
    downloadIsisData isistestdata $ISISTESTDATA
    ```

=== "rclone (advanced)"

    ```sh
    rclone -P --config isis/config/rclone.conf sync isistestdata: $ISISTESTDATA
    ```

    ??? quote "Test data rclone command breakdown"

        - `$ISISTESTDATA` is an environmental variable pointing to the test data location
        - `-P` shows the progress during the download
        - `--config .../rclone.conf` points to ISIS's rclone.conf
        - `asc_s3:` is the name of S3 configuration in ISIS's rclone.conf
        - `asc-isisdata/isis_testData/` is the name of the S3 bucket you’re downloading from

    ??? warning "rclone copy/sync can overwrite data!"

        Note the difference between rclone `sync` and `copy`:

        -  `copy` will overwrite all data in the destination with data from source.
        - `sync` replaces only changed data.
        
        Syncing or copying in either direction (local → remote; remote → local) results in any changed data being overwritten without warning.

    After running the `rclone` command, `$ISISTESTDATA` should contain a full clone of the ISIS test data for running Makefile-based tests.

-----

#### Downloading specific files

Download specific files is possible by specifying their path.  Test data is generally organized by mission under `isistestdata:isis/src/[mission]`.

To download only the `base` folder from the isis_testData bucket:

=== "downloadIsisData script"

    ```sh
    downloadIsisData isistestdata $ISISTESTDATA --include="{isis/src/base/**}"
    ```

=== "rclone"

    ```sh
    rclone -P --config isis/config/rclone.conf sync isistestdata:isis/src/base $ISISTESTDATA/isis/src/base
    ```

-----

## Contributing New Tests and Tests Fixtures

Source code for *unit* and *regression* GTests is in the ISIS GitHub repo.  Data used by legacy Makefile tests is hosted on AWS S3. 

Testing is required for changes to ISIS classes and apps. This may entail changes or additions to the test data. Tests and test data should be created as part of GitHub PRs.  Any contributions of test data/fixtures should follow our [testing guidelines](../isis-developer-guides/writing-isis-tests-with-ctest-and-gtest.md).

!!! failure "No new Makefile-based tests or data"

    Because all tests are now written in gtest, no changes to the S3-hosted ISISTESTDATA area are currently accepted.