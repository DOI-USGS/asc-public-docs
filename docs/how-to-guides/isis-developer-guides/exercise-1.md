# Exercises 1

The purpose behind these exercises is to help programmers become familiar with the ISIS3 environment, the ISIS3 API, and ISIS3 standards.

## Prerequisites

### Test Data

Download a test image, [Peaks.cub.gz](../../assets/exercises/Peaks.cub.gz) (you must uncompress this image). This image is 1024x1024 with 7 bands and it has 19 [LRS](LRS) special pixels.

### ISIS Installation and Setup
These exercises require the use, modification, and recompilation of ISIS programs. Follow the instructions for [developing ISIS with CMake](../isis-developer-guides/developing-isis3-with-cmake.md). To verify that ISIS was correctly installed, run `qview` on the demo .cub:

```Console
    qview Peaks.cub
```


## Task 1 - Get Familiar with ISIS3

1. Browse the [ISIS Website](https://isis.astrogeology.usgs.gov/):
    - Explore the [user documentation](https://isis.astrogeology.usgs.gov/UserDocs/index.html).
    - Explore the [programmer documentation](https://isis.astrogeology.usgs.gov/TechnicalInfo/index.html) (Technical documents).

2. Explore the ISIS3 directory structure:
    - $ISISROOT/src.
    - $ISISROOT/src/base.
    - $ISISROOT/src/base/apps.
    - $ISISROOT/src/base/objs.
    - $ISISROOT/src/mgs.
    - $ISISROOT/bin.

### Questions:

- What is a "Cube Attribute"?
- What are the two pixel storage orders ISIS3 supports?
- Name one reserved ISIS3 command line parameter.
- What is the general indenting scheme for ISIS3?
- What is the naming convention for local variables?
- What is an include guard?
- What are the names of the three dimensions of an ISIS3 cube?

## Task 2 - Examine and Modify the ISIS3 `mirror` Application

1. Create the directory structure under your home area: `isis3/isis/src/base/apps/mirror`.
2. Copy the `mirror` application (`mirror.cpp`, `mirror.xml`, `Makefile`) from **$ISISROOT/src/base/apps/mirror** into the new directory.
3. Build the program by typing `make`.
4. Run `mirror` using the input file Peaks.cub downloaded earlier (ensure the image is uncompressed).
5. Examine the results with `qview`.
6. Modify the `mirror` program so that every other sample in the image is set to zero, preserving the original code as a comment.
7. Verify the results with `qview`.

## Task 3 - Modify the `mirror` Application

1. Modify your copy of the `mirror` program so that every other line is set to zero, preserving the previous code as a comment.
2. Verify the results with `qview`.

## Task 4 - Enhance the `mirror` Application

1. Add a parameter to the `mirror` application to allow the user to choose either zero or Isis::Null as the output DN for the blank lines and/or samples. Modify the xml file to achieve this.
2. Verify the results with `qview`.

!!! Tip "Refer to other ISIS3 applications for examples or consult the [ISIS XML documentation](http://isis.astrogeology.usgs.gov/Schemas/Application/documentation/index.html)"

## Task 5 - Allow User to Customize Line or Sample Settings

1. Modify the `mirror` application to enable the user to choose whether the program changes every other line or every other sample and whether the value should be changed to 0 or Isis::NULL.
2. Update the xml file accordingly.

!!! Tip "You may need to use C++ polymorphism and class inheritance. If you are unfamiliar with these concepts, now is a great time to learn!"

## Task 6 - Provide Statistical Information to the User

1. Calculate the average and standard deviation of the output image in the `mirror` program. Initially, display the values using the C++ cout stream.
2. Then, include the average and standard deviation in a PvlGroup and write it to the log file (print.prt).

!!! Tip "Refer to the documentation for [Application](https://isis.astrogeology.usgs.gov/Object/Developer/class_isis_1_1_application.html) and [Statistics](https://isis.astrogeology.usgs.gov/Object/Developer/class_isis_1_1_statistics.html) classes"

## Task 7 - Modify the Cube Labels

1. Use the `less` utility to inspect the labels at the beginning of the cube.
2. Modify the program to add the average and standard deviation to the labels.

!!! Tip "Refer to the [Process](https://isis.astrogeology.usgs.gov/Object/Developer/class_isis_1_1_process.html) and [Cube](https://isis.astrogeology.usgs.gov/Object/Developer/class_isis_1_1_cube.html) classes"

## Task 8 - Document the Application

1. Some xml tags in `mirror.xml` may look like comments (`<brief>`, `<description>`, `<example>`) to aid programmers in understanding or editing source code and generate documentation. To view your application's documentation, go to the application's directory and type `make html` to build the documentation. Open the generated `.html` file in a web browser to view it.
2. Review other applications in ISIS3 for documentation examples and read the [ISIS Application Examples How-to](http://isis.astrogeology.usgs.gov/documents/HowToApplicationExamples/index.html).
3. Modify the xml for your application and use `make html` to verify the results.