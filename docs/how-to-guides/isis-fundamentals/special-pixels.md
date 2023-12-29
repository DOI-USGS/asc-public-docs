
# Special Pixels

## Introduction to Special Pixels
-------------------------------------------------------------------

### What are special pixels?

Special pixels are defined to distinguish valid pixels from non-valid pixels in ISIS. This is very important to scientists who evaluate the density values, and draw conclusions about the physical properties of a scene.

### How are special pixels set?

There are two ways that [Digital Number (DN)](https://astrogeology.usgs.gov/docs/concepts/glossary/#dn) values are set to special pixels in ISIS:

*   **Instrument Special Pixels** : These types of special pixels are set during the ingestion of the data into ISIS because the acquired measurement either exceeded the dynamic range of the sensor based on its inherent properties (such as sensitivity) and settings (such as gain) or the measurement wasn't collected due to an instrument or transmission error.
    *   _Low Instrument Saturation ( [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) )_ : The sensor registered a value too low to be measured accurately (i.e. undersaturated).
    *   _High Instrument Saturation ( [HIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) )_ : The sensor registered a value too high to be measured accurately (i.e. oversaturated).
    *   _No Data Collected ( [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) )_ : The instrument did not collect a measurement due to an sensor malfunction (such as a damaged CCD element) or an error in transmission prevented the value from being recorded.
*   **Representation Special Pixels** : These types of special pixels are set due to being processed by ISIS applications that cause the DNs to fall outside the data range of the file, either due to settings defined by the user or the effects of the algorithms within the application.
    *   _Low Representation Saturation ( [LRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs) )_ : The resulting DN calculated by the application fall below the possible range of values (i.e. undersaturated).
    *   _High Representation Saturation ( [HRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) )_ : The resulting DN calculated by the application are higher than the possible range of values (i.e. oversaturated).
    *   _Data Removed ( [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) )_ : NULL values are set by an application when it removes data, such as during masking or geometric warping.

## Special Pixels in ISIS
-----------------------------------------------------

### How many special pixel values exist in ISIS?

There are five special pixel values defined in the ISIS software system for 16-bit and 32-bit data type. Each of the five special pixels is denoted by a specific value that represents that specific type of invalid data. **Having one of these special value is the only way ISIS can tell that a given pixel is in fact a special pixel of a particular type.** The [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) special pixel identifies pixels where either the instrument failed to collect data, or data was removed or empty pixels created during processing. The [LRS (Low Representation Saturation)](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs) and [HRS (High Representation Saturation)](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) represent saturated pixels that fall outside the minimum and maximum valid range of the file respectively. The [LIS (Low Instrument Saturation)](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) values represent pixels that fall below the lowest value the instrument can accurately record. The [HIS (High Instrument Saturation)](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) values represent pixels that exceed the highest value the instrument can accurately record. The table to the right shows each of the 5 special pixel types and their corresponding numerical representations. Note that 8-bit data can only has two special pixel types, represented by values of 0 ( [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) , [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) , [LRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs) ) and 255 ( [HIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) and [HRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) ). Thus 8-bit data does not distinguish between [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) , [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) , and [LRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs) pixels nor between [HIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) and [HRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) pixels.

**Special Pixels in ISIS** Visual refers to the apparent color of a special pixel in an ISIS display application, such as **qview**.

<table>
    <thead>
        <tr>
            <th><strong>Special Pixel Name</strong></th>
            <th><strong>32-bit</strong>*</th>
            <th><strong>16-bit</strong></th>
            <th><strong>8-bit</strong></th>
            <th><strong>Visual</strong></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>NULL</td>
            <td>-3.40282e+38</td>
            <td>-32768</td>
            <td>0</td>
            <td>black</td>
        </tr>
        <tr>
            <td>Low Representation Saturation (LRS)</td>
            <td>-3.40282e+38</td>
            <td>-32767</td>
            <td>0</td>
            <td>black</td>
        </tr>
        <tr>
            <td>Low Instrument Saturation (LIS)</td>
            <td>-3.40282e+38</td>
            <td>-32766</td>
            <td>0</td>
            <td>black</td>
        </tr>
        <tr>
            <td>High Instrument Saturation (HIS)</td>
            <td>-3.40282e+38</td>
            <td>-32765</td>
            <td>255</td>
            <td>white</td>
        </tr>
        <tr>
            <td>High Representation Saturation (HRS)</td>
            <td>-3.40282e+38</td>
            <td>-32764</td>
            <td>255</td>
            <td>white</td>
        </tr>
    </tbody>
</table>

*   \* The 32-bit values representing different special pixels do differ just like those representing the 16-bit values. However, the variations are on the last digit, and thus are not visible in this display since it does not show all 38 digits.

### Are the special pixel values propagated between different bit types?

The special pixel values are converted without loss of information between 16-bit and 32-bit data. See the chart above to see what the values are set to after conversion from one bit type to the other. For example, if a pixel in 16-bit data with a DN of -32766 (thus representing an [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) pixel) is converted to 32-bit data, its DN value will be changed to that value representing an LIS pixel in 32-bit format. If the image is converted from 16-bit or 32-bit to an 8-bit data type, then all the [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) , [LRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs) , and [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) special pixel have their values set to 0, and all [HIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) and [HRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) special pixels have their values set to 255. Note that this conversion results in a loss of information, as it is no longer possible to distinguish between [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis) , [LRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs) , and [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) pixels since they all have the same pixel value of 0. Similarly, converting from 16-bit or 32-bit to 8-bit will make it impossible to distinguish between [HIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) and [HRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) pixels. Why?

### Is the NULL special pixel defined as 0 for all bit types?

No. The [DN](https://astrogeology.usgs.gov/docs/concepts/glossary/#dn) value 0 is defined as [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null) only in an 8-bit file. For the 16-bit and 32-bit data, 0 is a valid [DN](https://astrogeology.usgs.gov/docs/concepts/glossary/#dn)!

## [Interactive Special Pixel Demonstration](https://doi-usgs.github.io/ISIS3/Special_Pixels.html#Interactive-Special-Pixel-Demonstration)
-------------------------------------------------------------------------------------



## Working with Special Pixels
-------------------------------------------------------------



Q: _How do I find out if there are any special pixels in my file?_  

A: Statistics: **hist** & **stats**

There are two programs [**stats**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/stats/stats.html) and [**hist**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/hist/hist.html) that will provide statistics about the pixels of an image. The output from stats looks like:


```
Group = Results
    From                    = Intro2isis.cub
    Band                    = 1
    Average                 = 61.770642254011
    StandardDeviation       = 8.0295403784653
    Variance                = 64.473518689404
    Median                  = 62.0
    Mode                    = 66.0
    Skew                    = -0.085692730285373
    Minimum                 = 2.0
    Maximum                 = 252.0
    Sum                     = 76029592.0
    TotalPixels             = 1271424
    ValidPixels             = 1230837
    OverValidMaximumPixels  = 0
    UnderValidMinimumPixels = 0
    NullPixels              = 40587
    LisPixels               = 0
    LrsPixels               = 0
    HisPixels               = 0
    HrsPixels               = 0
End_Group
```

**View your image: [qview](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/qview/qview.html)**

You can also display the image on a monitor using the program [**qview**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/qview/qview.html), and position the cursor over a very dark pixel. The [DN](https://astrogeology.usgs.gov/docs/concepts/glossary/#dn) displayed on the screen will either be [NULL](https://astrogeology.usgs.gov/docs/concepts/glossary/#null), [LIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lis), [LRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#lrs), or a very low [DN](https://astrogeology.usgs.gov/docs/concepts/glossary/#dn) value. The [HIS](https://astrogeology.usgs.gov/docs/concepts/glossary/#his) and [HRS](https://astrogeology.usgs.gov/docs/concepts/glossary/#hrs) pixels will be displayed as white pixels on a monitor.

## Related ISIS Applications
-----------------------------------------------------------


*   [**hist**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/hist/hist.html)
*   [**stats**](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/stats/stats.html)
*   [**qview**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/qview/qview.html)
*   [**isis2ascii**](http://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/isis2ascii/isis2ascii.html)