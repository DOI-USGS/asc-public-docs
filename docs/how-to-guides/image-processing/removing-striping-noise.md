# Removing Striping Noise

## Summary of the Method
Destriping is a common procedure used on images to remove distracting horizontal or vertical noise in an image. This type of destriping involves running two filters on the original image creating two new images, a low pass filtered image and a high pass filtered image, and combining the results.


<figure markdown>
  ![Striping](../../assets/striping/striping.png)
  <figcaption>Example of striping</figcaption>
</figure>

This Lunar Orbiter image contains horizontal striping noise due to the scanning, output, and transmission phases of its collection.

## Concepts

If both a low pass and a high pass filter of the same size are run on an image and then added together, the result will be the original image. If the filter sizes are not the same, the result will not be exactly the same as the original. The goal in choosing sizes for the two filters is to create an output for each without the unwanted striping. If this is accomplished, when the filter outputs are added together, the striping will have been removed or subdued. If the sizes of the two filters differ too much, artifacts may be introduced into the result. This type of procedure works very well on horizontal and vertical striping, but is not recommended for diagonal striping.


## Related ISIS3 Application

See the following ISIS3 documentation for information about the applications you will need to use to perform this procedure:

- [lowpass](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/lowpass/lowpass.html) - low pass filter application
- [highpass](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/highpass/highpass.html) - high pass filter application
- [algebra](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/algebra/algebra.html) - used to add the results of the low and high pass filters


## Some general tips for choosing the filter sizes

- The boxcar shapes for both the low pass and high pass filters should be similar in shape to the striping. This is not a firm rule. The filter sizes can be opposite (i.e., long and short -vs- narrow and tall).

- The size of the low pass filter should be large enough to completely encompass the problem, plus enough extra pixels to keep the average of any boxcar from being overly effected by the striping. A good rule of thumb to start with is a low pass boxcar size twice the size of the striping.

- The size of the high pass filter should be small enough to completely fit inside the problem, minus enough pixels to keep the average of any boxcar from being overly effected by the striping. A good rule here is to make the high pass filter boxcar size less than one half the size of the striping.


<figure markdown>
  ![Image Filter](../../assets/striping/striping_close_up.png)
  <figcaption>Striping Close-Up</figcaption>
</figure>

Enlarged view to show the height of the striping. The blocks in the scale bar along the left side of the image measure a 3 pixel by 3 pixel area. The stripes are roughly 7 to 10 pixels high.

## Destriping Example

The image used in this example is a sub-area of a Lunar Orbiter filmstrip. The scanning, output, and transmission phases introduced some striping noise.

<figure markdown>
  ![Striping](../../assets/striping/striping.png)
  <figcaption>Example of striping</figcaption>
</figure>
This Lunar Orbiter image contains horizontal striping noise due to the scanning, output, and transmission phases of its collection

<figure markdown>
  ![Low Pass](../../assets/striping/low_pass.png)
  <figcaption>Low Pass Filter</figcaption>
</figure>
This image is the result of running a low pass filter on the original image, with a boxcar shape that is very wide but not very tall

<figure markdown>
  ![High Pass](../../assets/striping/high_pass.png)
  <figcaption>High Pass Filter</figcaption>
</figure>
This image is the result of running a high pass filter on the original image, with a boxcar shape that is very wide and very short

<figure markdown>
  ![Sum](../../assets/striping/sum.png)
  <figcaption>Sum of High and Low pass filters</figcaption>
</figure>

