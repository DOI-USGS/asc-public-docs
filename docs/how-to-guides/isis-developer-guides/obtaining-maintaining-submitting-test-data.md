# Obtaining, Maintaining, and Submitting Test Data for ISIS

The testing environment for ISIS includes unit tests for nearly every C++ class or struct in the ISIS library, one or more regression tests for all non-interactive applications, and several regression tests for chains of multiple applications (module tests). Many of the tests require input and/or truth files. Due to the large size (nearly 20GB) of these test files, they are not included in the GitHub code repository.

Unit tests are designed to test a single class from the ISIS library (e.g., Histogram, ProcessByLine, VoyagerCamera). They use two frameworks: the newer `gtest` and the older, in-house `make`-based tests. Test data for gtest-based tests is usually embedded in the test source code file located in `$ISISROOT/isis/tests`. Input data for the make-based tests can be embedded in the `unittest.cpp` located in the source code directory for the class or an external file located in the ISIS3DATA or ISIS3TESTDATA areas. Output test data for the `make`-based tests is always located in the source code directory for the class.

Application and module tests are regression tests designed to test all the functionality of a single ISIS application (e.g., `fx`, `lowpass`, `cam2map`) or a series of ISIS applications (e.g., `vims2isis->spiceinit->cam2map`) respectively. Regression tests have both input and truth data stored in the ISIS3TESTSDATA area. Input and truth data files can be ISIS cubes, control networks, plain text, Parameter Value Language (PVL), Planetary Data System images (PDS3, PDS4), or comma-separated value (CSV) files.

### Setting Up an ISIS Development Environment

To run existing tests and develop new tests, a full development environment is required. The public releases do not contain the tests or test data or the source code for the tests. Follow these steps to get a working ISIS development environment with all the data:

1. Fork the ISIS source code [repository](https://github.com/DOI-USGS/ISIS3).
2. Get the ISIS source code on your local machine by cloning your fork.
3. [Build](../isis-developer-guides/developing-isis3-with-cmake.md) the ISIS library and applications.
4. [Download](https://github.com/DOI-USGS/ISIS3) the ISIS data files.

!!! Warning "Be careful where you put the ISISDATA area. It is several hundred GB and growing."

### Downloading Test Data

ISIS unit and regression tests require the data and test data directories to be available and their respective environment variables (`ISISDATA`, `ISIS3TESTDATA`) to be set. This allows the tests to read files from these areas and compare results to known truth data.

Test data is hosted using Amazon S3 storage buckets. We recommend using rclone to pull the data into a local directory. Follow these steps:

1. Download rclone using their instructions (see: [https://rclone.org/downloads/](https://rclone.org/downloads/)) or by using an Anaconda environment (see: [https://docs.anaconda.com/anaconda/install/](https://docs.anaconda.com/anaconda/install/)).
2. Install rclone with: `conda install –c conda-forge rclone` if using Anaconda.
3. Configure rclone using a default S3 configuration. See [https://rclone.org/s3/](https://rclone.org/s3/) for detailed information.
4. Run `rclone sync remote:asc-isisdata/isis_testData/ $ISISTESTDATA` to download the ISIS3 test data.

!!! Warning "Warnings"
    - Users should understand the difference between rclone’s ‘sync’ and ‘copy’ methods. ‘copy’ overwrites all data in the destination with data from source, while ‘sync’ replaces only changed data.
    - Syncing/copying in either direction (local -> remote or remote -> local) results in any changed data being overwritten. There is no warning message on overwrite.

``` Console 
rclone sync remote:asc-isisdata/isis_testData/ $ISISTESTDATA
```

Where:

    - $ISISTESTDATA is the environment variable defining the location of the ISISTESTDATA
    - remote: is the name of the configuration you created earlier. This can be whatever you want to name it, in this case it is named remote.
    - asc-isisdata/isis_testData/ is the name of the S3 bucket you’re downloading from

After running the `rclone` command, $ISISTESTDATA should contain a full clone of the ISIS test data for running Makefile based tests.

!!! Note "Notes"
    Users can download specific files from the bucket by adding path data or file information to the first argument, that is, to download only the ‘base’ folder from the isis_testData bucket, the user could call: rclone sync remote:asc-isisdata/isis_testData/base

### Set Up the ISIS environment variables
The environment variable "ISIS3TESTDATA" needs to be set to point to the "isis" directory created by the rsync command above. Note: Each of the examples below ends with an "isis" directory.

Bash and other sh based shells:
```
export ISIS3TESTDATA=/path/to/the/test/data/for/isis
```
tcsh or other csh based shells:
```
setenv ISIS3TESTDATA /path/to/the/test/data/for/isis
```

## Contributing New Tests and Tests Fixtures
The source code for the unit and regression tests is located with the ISIS source code repository on GitHub, but the data used by the tests is currently internal to USGS and is made available through AWS S3 servers. 

All changes to ISIS classes and applications are required to be well-tested, which may require modifications or additions to test data. Tests and test data should be created as part of the GitHub pull request.  Because all tests are now written in gtest, no modifications to the S3-hosted data are currently accepted, and all test data/fixtures should be created according to the guidelines in the [testing documentation](../isis-developer-guides/writing-isis-tests-with-ctest-and-gtest.md).