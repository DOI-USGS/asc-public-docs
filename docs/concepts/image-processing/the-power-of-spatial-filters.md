# The Power of Spatial Filters

## What is an Image Filter?

In the most basic sense, a filter is a mechanism that removes something from whatever passes through it. An image filter blocks or passes through image data based on what kind of filter it is. A low pass filter allows low frequency data, or data that does not change much from pixel to neighboring pixel, to pass through, removing the high frequency data, or data that changes rapidly from pixel to neighboring pixel. Conversely, a high pass filter allows high frequency data to pass, removing low frequency data.

Image filters have a wide variety of uses, such as noise removal, edge enhancement, creating an embossed appearance, and making an image appear crisper and sharper.

This image shows a portion of the original image data (upper left),
and the results of three different filters applied to the original:
low pass (upper right), high pass (lower left), and sharpen (lower right)

<figure markdown>
  ![Image Filter](../../assets/spatial_filters/filter_comparison.png)
  <figcaption>A Comparison of Spatial Filters</figcaption>
</figure>


## What is a Box Car?

In general, image filters operate by performing a mathematical operation on each pixel using the pixels surrounding it to generate the result. For instance, a low pass filter changes the value of each pixel in the image to the average of it and the pixels in its neighborhood.

The filter's box car size determines how big that neighborhood is. For instance, a 3x3 box car is 3 samples (pixels wide) by 3 lines (pixels high) with the target pixel in the center of the box car. The filter moves through every pixel in the image, performing the same mathematical operation using the surrounding pixels in its neighborhood, or box car, to determine the target pixel’s new value.

Changing the box car size determines how features in the image are affected. In general, small box cars affect small features, large box cars affect large features, tall and narrow box cars affect vertical features, and short and wide box cars affect horizontal features.

<figure markdown>
  ![Box Car](../../assets/spatial_filters/box_car.png)
  <figcaption>Illustration of a Box Car Iterating Over an Image</figcaption>
</figure>

A filter processes each pixel in the image. The output pixel will be at the same location as the pixel of the center of the box car. The filter calculates the new output value of that pixel using all the input pixels in the box car. The animation (linked below) illustrates the movement of the filter application through the input image, and where the box car neighborhood is located.

## The Low Pass Filter

### Basics of the Low Pass Filter
A low pass filter allows low frequency data, or data that does not change much from pixel to neighboring pixel, to pass through, removing the high frequency data, or data that changes rapidly from pixel to neighboring pixel. The visible result is the image appears blurred or smoothed. The amount of blur depends on the size of the box car. Low pass filters affect features smaller than the box car size. A small box car will cause a slight blur and reduce the amount of difference between small areas and their surrounding regions. For an image that contains a lot of noise, such a filter would smooth out the image and reduce the noise with minimal effect on large features in the image. A low pass filter with large box car will affect large features in the image, and will reduce or eliminate the smaller features.

<figure class="inline" markdown>
  ![Lowpass Original](../../assets/spatial_filters/lowpass_original.png){width=250px}
  <figcaption>Original</figcaption>
</figure>

<figure markdown>
  ![Lowpass 3x3](../../assets/spatial_filters/lowpass_3x3.png){width=250px}
  <figcaption>3x3 Low Pass</figcaption>
</figure>


<figure class="inline" markdown>
  ![Lowpass 7x7](../../assets/spatial_filters/lowpass_7x7.png){width=250px}
  <figcaption>7x7 Low Pass</figcaption>
</figure>
<figure markdown>
  ![Lowpass 21x21](../../assets/spatial_filters/lowpass_21x21.png){width=250px}
  <figcaption>21x21 Low Pass</figcaption>
</figure>

!!! NOTE "Boxcar Size Effects Features"
    As the size of the boxcar increases, the edges of features begin to soften and eventually lead to the destruction of features.
-----



### The Algorithm
The mathematical operation the low pass filter performs in order to achieve these effects is to replace each pixel in the image with the average of all the pixel values in the box car.

### Running ISIS3 lowpass
The ISIS3 lowpass application allows you to set what the low and high values that will be included in this operation are and which types of pixels will be changed by the operation. See the [lowpass](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lowpass/lowpass.html) documentation’s parameters section for a full list of parameters and their description.

### Uses of the Low Pass Filter
For remote sensing analysis, low pass filtering is useful for subduing or removing detail and enhancing large features or albedo. Choose the box car size based on the size of the details you wish to remove or subdue. In image processing, low pass filters can serve to remove noise, reduce resolution (without reducing the image size), or subdue details in one step of a procedure. In more complicated image processing procedures, the low pass filtered image can be used to return image hues and coloring to the resulting image after other processing procedures have removed them in the process of enhancing details.

### Fill-in NULL pixels
The lowpass application can be used to replace Special Pixels with the average of surrounding valid pixels. The average is computed based on the boxcar size (line X sample) that is specified.

!!! EXAMPLE "Filling-in NULL pixels:"
    ` lowpass from=input_with_nulls.cub to=output_fill.cub samples=3 lines=3 filter=outside null=yes hrs=no his=no lrs=no replacement=center `

    - The average of valid pixels will be computed based on the size of the boxcar (line x sample)
    - The larger the boxcar size, the 'smoother' the resulting average will be
    - If the desired output is to fill with 'details', the approach would be to fill in with small boxcar sizes (3x3, 5x5) until the special pixel value areas are filled in.
    - If any special pixels assigned to be replaced remain in the output, lowpass can be applied consecutively until the desired special pixels are completely filled with surrounding averages.


### Similar Filters
- [gauss](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/gauss/gauss.html) uses a weighted average to compute the new value for the target pixel, with the weight based on the Gaussian distribution as a function of the distance of the boxcar pixel from the target
- [noisefilter](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/noisefilter/noisefilter.html) determines what pixels are considered "noise" based on tolerances provided by the user, and replaces those noise pixels with either the average of the box car or a "null" value based on the user's choice
- [divfilter](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/divfilter/divfilter.html) divides the original image values by the average of the boxcar, equivalent to dividing the original image by the low pass filter results of the same image using the ratio application


## The High Pass Filter

### Basics of the High Pass Filter
The high pass filter allows high frequency data to pass through, suppressing low frequency data. High pass filtering can be useful for finding edges, enhancing lines and edges, or sharpening an image. Small box cars will enhance small features and details. Large box cars will allow large features to pass through, suppressing or eliminating smaller features.

<figure class="inline" markdown>
  ![Highpass Original](../../assets/spatial_filters/lowpass_original.png){width=250px}
  <figcaption>Original</figcaption>
</figure>

<figure markdown>
  ![Highpass 3x3](../../assets/spatial_filters/highpass_3x3.png){width=250px}
  <figcaption>3x3 High Pass</figcaption>
</figure>


<figure class="inline" markdown>
  ![Highpass 7x7](../../assets/spatial_filters/highpass_7x7.png){width=250px}
  <figcaption>7x7 High Pass</figcaption>
</figure>
<figure markdown>
  ![Highpass 21x21](../../assets/spatial_filters/highpass_21x21.jpeg){width=250px}
  <figcaption>21x21 High Pass</figcaption>
</figure>


### The Algorithm
The mathematical operation the high pass filter performs in order to achieve these effects is to replace each pixel in the image with the difference between it and the average of all the pixel values in the box car. This filter can be viewed as a kind of slope filter, in that it highlights pixels that have values that are different from their neighboring pixels. The greater the difference, the higher or lower (visually: brighter or darker) the output value will be.

### Running ISIS3 highpass
The ISIS3 [highpass](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/highpass/highpass.html) application allows you to set what the low and high values that will be included in the operation. You can also set the percentage of addback, which will add the original image (weighted by the percent addback chosen) to the high pass results. See the highpass documentation’s parameters section for a full list of parameters and their descriptions.

<figure class="inline" markdown>
  ![Highpass Original](../../assets/spatial_filters/lowpass_original.png){width=200px}
  <figcaption>Original</figcaption>
</figure>

<figure class="inline" markdown>
  ![Highpass Original](../../assets/spatial_filters/highpass_3x3_50addback.png){width=200px}
  <figcaption>3x3 High Pass with 50% addback</figcaption>
</figure>

<figure markdown>
  ![Highpass 3x3](../../assets/spatial_filters/highpass_3x3_100addback.png){width=200px}
  <figcaption>3x3 High Pass with 100% addback</figcaption>
</figure>


### Uses of the High Pass Filter
For remote sensing analysis, high pass filtering is useful for reducing albedo features and enhancing structural details. Choose the box car size based on the size of the structural details you wish to enhance. In image processing, high pass filters can serve to sharpen a fuzzy image when used with addback. In more complicated image processing procedures, the high pass filtered image can be used to return image details to the resulting image after other processing procedures have removed them in the process of removing noise or artifacts.

### Similar Filters
- [sharpen](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lowpass/lowpass.html) is a specialized high pass filter that has a preset addback value of 100%, resulting in an image which looks similar to the original, but crisper and sharper