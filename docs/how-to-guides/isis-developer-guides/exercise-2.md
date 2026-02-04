# ISIS Programming Exercise 2: `diff`

*Learning slightly more advanced features of the ISIS API: Write an ISIS application that performs simple differences between adjacent pixels in the line or sample directions.*

!!! Info "This tutorial assumes that the user has completed [exercise 1](./exercise-1.md) and has access to the ISIS installation and data from that tutorial."

## Setup

It's advisable to start with the `mirror` directory from Exercise 1 and copy it to a new directory called `diff` in `base/apps`. The rest of the exercise will be use the `diff` directory as a work area.

1. Set up your environment to run the current public version of ISIS3.
2. Set your current working directory to the "diff" directory created above.

## Task 1 - Rename the `mirror` Application to `diff`

1. Run `make clean`.
2. Rename all files to match your new application's name: `diff`.
3. Edit the XML file to have only the `FROM` and `TO` parameters. Ensure they both have appropriate descriptions and add appropriate history documentation.
4. Type `make html` to check the validity of your XML file. Address any errors.

## Task 2 - Modify the IsisMain and Processing Functions

1. Modify the `IsisMain` and `Process` functions so they produce a new cube where each pixel is the subtraction of that pixel and its right neighbor. For example, if line 1, sample 1 has a value of 120 and line 1, sample 2 has a value of 153, the output pixel for line 1, sample 1 should be -33.

## Task 3 - Add the Ability to Subtract the Left Neighbor

1. Create a new "process" function to subtract each pixel from its left neighboring pixel.
2. Create radio buttons in your XML to allow the user to select between the two modes.
3. Set up an if statement so your software can differentiate between the two modes. 

!!! Tip "`UserInterface` can help you get the string value of the radio buttons. It may be useful to look at another application."

## Task 4 - Add the Ability to Subtract Lines

1. Create another process function that subtracts lines instead of samples.
2. Edit your XML file to accommodate this new feature.
   - Don't forget `make html` to test your changes.
   - Don't forget to append to the if statement to accommodate the new mode. 

## Task 5 - Account for Special Pixels

1. Account for special pixels in the image. If either of the input pixels you are dealing with are special, then the output pixel should be `Isis::Null`.
2. Ensure you account for special pixels in all modes of the application.

## Task 6 - Combine Process Functions

1. Combine all process functions into a single function. Note: This may also require some global variables. Hint: Look at `ProcessByLine` and other `ProcessByXxxxxx`.

## Task 7 - Verify Results

1. For each mode in `diff`, compare the output to the original `Peaks.cub` (available from [Exercises 1](./exercise-1.md)) using `qview`. Make sure your software is processing data correctly.
2. Check for special pixels.

## Task 8 - Eliminate Global Variables

1. Minimize the use of global variables. Rewrite the program so that it does not rely on global variables. Hint: Look at `Isis::ProcessByBrick`.

## Task 9 - Create Tests for Your New Software

Follow the [instructions](../isis-developer-guides/writing-isis-tests-with-ctest-and-gtest.md) to add tests for your changes.
