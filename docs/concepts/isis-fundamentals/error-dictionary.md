# Error Dictionary

## Introduction

ISIS categorizes errors into four different types to indicate their sources. 

## Unknown Error

This error category encompasses errors that fall outside the scope of User, Programmer, or I/O Errors as listed below. It's typically the most common error and is displayed as a generic error.

Example:
```
**ERROR** Unable to find PVL group [SearchChip].
```

## User Error

This error occurs when users select invalid values for input parameters. Examples include entering a negative integer for a parameter that only allows positive integers, mistyping parameters, or inputting a value not in a required list (such as 8-bit, 16-bit, or 32-bit). Typically, this error is associated with user input provided either in the ISIS graphical user interface (GUI) or via the command line.

Example:
```
**USER ERROR** Unknown parameter [to].
```

## Programmer Error

This particular error is uncommon, arising when the programmer provides invalid information to a C++ class and/or method. Typically, these errors are detected by the programmer during the software development phase. They might occur in exceptional situations like array out-of-bounds or memory leaks. Users encountering these errors should open an issue in the [ISIS Repository](https://github.com/DOI-USGS/ISIS3/issues).

Example:
```
**PROGRAMMER ERROR** Cannot compare a invalid angles with the < operator.
```

## I/O Error

File I/O errors encompass operations such as opening, closing, reading, or writing files. These errors may involve: 1) attempting to access a non-existent file upon opening or allocation, often due to misspellings or incorrect directory paths, 2) encountering read and/or write permission issues stemming from user or group ownership, and 3) facing inadequate disk space for allocating an output file.
However, these errors do not pertain to cases where a file lacks the expected values inside it, such as reading a corrupted PVL.

Example:
```
**I/O ERROR** Unable to open [test.cub].
```