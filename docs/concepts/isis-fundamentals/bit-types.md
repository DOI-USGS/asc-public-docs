# Bit-Type

## Bit-Type Basics
-----

Computers store values in base-2 or binary, ones and zeros.
Values are stored in chunks of 8, 16, or 32 binary digits, or bits.  The number 
of bits per pixel (8-bit, 16-bit, 32-bit) is called **Bit-Depth**.  A **Data Type** (Unsigned Byte, Signed Word, Real) is a unit of information.

In ISIS, each data type has a corresponding bit-depth, and together these are called the **Bit-Type**.  Bit-type is a term unique to ISIS.

The a cube's bit-type affects the file size, and determines the 
range and number of values that can be stored in each pixel of a cube.  Larger bit-types (those with higher bit-depths) allow each pixel to represent its data with greater precision.

There are three bit-types supported in ISIS:

<table>
    <thead>
        <tr>
            <th>Bit-Depth</th>
            <th>Data Type</th>
            <th>Bytes per Value</th>
            <th>Range</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>8-bit</td>
            <td>Unsigned Byte</td>
            <td>1</td>
            <td>0 to 255</td>
        </tr>
        <tr>
            <td>16-bit</td>
            <td>Signed Word</td>
            <td>2</td>
            <td>-32768 to 32767</td>
        </tr>
        <tr>
            <td>32-bit</td>
            <td>Real</td>
            <td>4</td>
            <td>-3.40282E+38 to 3.04282E+38</td>
        </tr>
    </tbody>
</table>

[![Bit-byte-word.jpg](../../assets/isis-fundamentals/Bit-byte-word.jpg)](../../assets/isis-fundamentals/Bit-byte-word.jpg "Dimensions of an ISIS3 Cube")

There are 8 bits in 1 byte, and 16 bits in 2 bytes, as shown above. A word in ISIS is a 16-bit value.

!!! note

    In ISIS, the data type and bit-depth will always correspond as follows: Unsigned Byte (8-bit), Signed Word (16-bit), and Real (32-bit).  Therefore, ISIS's Bit-Type can refer to Bit-Depth or Data Type.  (Outside of ISIS, it is possible for bytes, words and reals to be different bit-depths.  But within ISIS, you don't have to worry about that.)

There are 256 possible values (called digital numbers, or DNs) that can
be represented in an 8-bit pixel. If all the bits above are set to 1, the
output DN value would be 255. The values 0 to 255 are derived by setting
different bit positions to 0 or 1. The table below shows the binary
number stored by the computer, and the corresponding DN value the user
would see on a computer monitor.

<table>
    <thead>
        <tr>
            <th>Binary Number</th>
            <th>DN Value</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>00000000</td>
            <td>0</td>
        </tr>
        <tr>
            <td>00000001</td>
            <td>1</td>
        </tr>
        <tr>
            <td>00000010</td>
            <td>2</td>
        </tr>
        <tr>
            <td>...</td>
            <td>...</td>
        </tr>
        <tr>
            <td>11111110</td>
            <td>254</td>
        </tr>
        <tr>
            <td>11111111</td>
            <td>255</td>
        </tr>
    </tbody>
</table>

When the number of bits is increased to 16 or 32, the number of possible DN values
that can be represented also increases.

### Glossary & Review

*   **Binary** : A base-2 numeral system. [Binary Number on Wikipedia](http://en.wikipedia.org/wiki/Binary_number).
*   **Bit** : Short for binary digit, the smallest unit of digital storage. Bits are either "0" or "1".
*   **Byte** : Short for binary term. In ISIS (and in most places), a byte is a group of eight bits. These 8 bits together can represent an 8-digit binary number from 00000000 (0) to 11111111 (255).
*   **Bit-Type** : Refers to bit-depth or data type, representing how many bits there are per single pixel in a cube.
*   **DN** : An abbreviation of digital number. For images, particularly ISIS cubes, a DN is also referred to as a pixel.


## What's the bit-type of my image?

-----

The **Type** keyword in the Pixels group of an image label will be set
to `UnsignedByte` for 8-bit cubes, `SignedWord` for 16-bit cubes, or `Real`
for 32-bit cubes.

!!! abstract "Portion of ISIS Cube Label Showing the Data Type or Bit-Type"

    The **Type** keyword here is `UnsignedByte`, meaning this is an 8-bit cube.  Type is a keyword in the **Pixels** group.
    ``` 
    Object = IsisCube
      Object = Core
      ...
        Group = Pixels
          Type       = UnsignedByte
          ByteOrder  = Lsb
          Base       = -128.00395256917
          Multiplier = 1.00395256917
        End_Group
      End_Object
    End_Object
    ```

## How does the bit-type affect my file?

-----

The file size for the output file increases as the bit-type increases.
With larger bit-types, each pixel in the data portion of the file requires
a larger number of bytes to hold the value of that pixel, regardless
of what that value is. While the data portion of the cube usually takes the 
biggest share of the file size, the text portions of a cube (the labels and
history) can add to the file size as well. The minimum label size
is 64 kilobytes. The following sizes are for a file that is 100 samples
by 100 lines:
<table>
  <thead>
    <tr>
      <th>Bit-Type</th>
      <th>Data Size (bytes)</th>
      <th>Label &amp; History Size (bytes)</th>
      <th>File size (bytes)</th>
      <th>Possible Discrete DNs</th>
      <th>DN Range</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>8-bit.cub</td>
      <td>10,000</td>
      <td>72,348</td>
      <td>82,348</td>
      <td>256</td>
      <td>0 to 255</td>
    </tr>
    <tr>
      <td>16-bit.cub</td>
      <td>20,000</td>
      <td>78,736</td>
      <td>98,736</td>
      <td>65,535</td>
      <td>-32768 to 32767</td>
    </tr>
    <tr>
      <td>32-bit.cub</td>
      <td>40,000</td>
      <td>91,507</td>
      <td>131,507</td>
      <td>about 4 billion</td>
      <td>-3.40282E+38 to 3.40282E+38</td>
    </tr>
  </tbody>
</table>

## How do I set the bit-type?

-----

Many of the ISIS3 programs allow the user to set the bit-type by setting
the bit-type attribute for an output file.

!!! example "Sample Cubes"

    Try converting the bit-types of these cubes with ISIS as described below.

    | Bytes per Value | Output Bit-Type | Sample Cube |
    | --------------- | --------------- | ----------- |
    | 1               | 8-bit           | [8-bit.cub](../../assets/isis-fundamentals/8-bit.cub) (80.4 KB) Ian Humphrey, 2016-06-01 10:41 AM   |
    | 2               | 16-bit          | [16-bit.cub](../../assets/isis-fundamentals/16-bit.cub) (96.4 KB) Ian Humphrey, 2016-06-01 10:41 AM |
    | 4               | 32-bit          | [32-bit.cub](../../assets/isis-fundamentals/32-bit.cub) (128 KB) Ian Humphrey, 2016-06-01 10:41 AM  |

### Increasing the Bit-Type of a Cube

Increasing the bit-type of a cube is a fairly straightforward matter
because the range of data in a smaller bit-type cube fits easily in the
increased range offered by the larger bit-type.  Increasing the bit-type 
of a cube will not increase the accuracy of the data in the cube, but
could allow the results of future operations to be recorded with more precision.

Example - create a 16-bit (signed word) cube from an 8-bit (unsigned byte) cube using
[cubeatt](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cubeatt/cubeatt.html)
by appending the attributes you wish to change to the file name:

``` 
 cubeatt from=8bit.cub to=16bit.cub+SignedWord
                         OR
 cubeatt from=8bit.cub to=16bit.cub+16-bit
```

In the
[cubeatt](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/cubeatt/cubeatt.html)
graphical user interface (GUI), simply hit the ATT (attributes) button
next to the output file selection box and select the desired bit-type in
the Attributes dialog. Notice when you change the attributes through the
ATT dialog, the attributes are appended to the output filename in the
main application window in the same fashion as the command line. Most
ISIS3 applications allow you to change key cube attributes through the
Attributes dialog.

!!! tip

    Increasing the Bit-Type of a cube will increase the file size.

### Decreasing the Bit-Type of a Cube

Decreasing the bit-type of a cube is a bit trickier because the range of
data in a larger bit-type cube probably does not fit easily in the
decreased range of the smaller bit-type. In this case, you must supply
the minimum and maximum values of the input file to convert to valid DNs
in the output file. The values will then be stretched (scaled) as
necessary to fit into the reduced data range. To perform this operation,
you must know the range of the input data and provide that information
to the application that is used to reduce the bit-type.

1.  Get statistics for your image: Run **stats** to get the data range:

    ``` 
    stats from=32bit.cub
    ```

    stats produces:

    ``` 
    Group = Results
      From              = 32bit.cub
      Average           = 3386367.6610505
      StandardDeviation = 7446.038790893
      Variance          = 55443493.675484
      Median            = 3385719.8387097
      Mode              = 3382280.056696
      Skew              = 0.26100683557387
      Minimum           = 3372788.0
      Maximum           = 3417331.0
      TotalPixels       = 265420800
      ValidPixels       = 265420800
      NullPixels        = 0
      LisPixels         = 0
      LrsPixels         = 0
      HisPixels         = 0
      HrsPixels         = 0
      End_Group
    ```

1.  **Change the bit-type attribute of your image** : Run **cubeatt** ,
    using the minimum and maximum values from stats (refer to the output
    from stats above) for the data range attribute. Append the attribute
    **3372788.0:3417331.0** to the output filename create the 16-bit
    cube:

    ``` 
    cubeatt from=32bit.cub to=16bit.cub+UnsignedWord+3372788.0:3417331.0
                            OR
    cubeatt from=32bit.cub to=16bit.cub+16-bit+3372788.0:3417331.0
    ```

1.  **Voila\!** The resulting output cube will have the values from
    3372788.0 to 3417331.0 from the original cube scaled to the range of
    -32752 to 32767. Note the use of -32752 instead of -32768. This is
    because the values below -32752 to -32768 are reserved for special
    pixels in ISIS3


!!! tip

    When reducing the bit-type, the original values may be stretched
    (scaled) to fit in the range of the target bit-type. This may not
    only shift the DN values to the new range, but may actually merge
    ranges of DNs into a single value if the number of distinct values
    in the original file is greater than the range of the output bit-type.
