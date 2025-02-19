# GDAL Support

<script src="https://asc-public-docs.s3.us-west-2.amazonaws.com/common/scripts/isis-demos/jquery-3.7.1.min.js"></script>
<link href="../../../css/isis-demos.css" media="all" rel="stylesheet"/>


<script type="text/javascript">
if (typeof window.isisDemosLoaded == 'undefined') {
    var isisDemosLoaded = true;
    $.getScript("https://asc-public-docs.s3.us-west-2.amazonaws.com/common/scripts/isis-demos/easeljs-0.8.1.min.js").done( function(s,t) { $.getScript("../../../js/isisDemos.js");});
}
</script>


The Geospatial Data Abstraction Library (GDAL) provides a broad range of data formats that ISIS could read or write. Currently, ISIS only supports Geospatial Tag Image File Format (GeoTiff) but has the potential to expand to other desired formats. How to access each format along with any potential quirks of processing using said formats will be detailed bellow.

## Processing With GeoTIFFs

Users wanting to process using GeoTIFFs only have to use `+GTiff` as an output attribute similar to cube [storage formats](../../concepts/isis-fundamentals/command-line-usage.md#storage-format) in ISIS found under the Command Line Usage page in the Isis Fundamentals. This will produce a `.tiff` file and a `.tiff.msk` file as your output file. For example:

```
mroctx2isis from=mroraw.img to=mrotiff.tiff+GTiff
```
results in

```
mrotiff.tiff
mrotiff.tiff.msk
```
The GeoTIFFs can then be used as input like cubes to other applications, just remember to add the `+GTiff` to any output if that output should be formated as a GeoTIFF.

One can also combine supported output attributes with the `+GTiff` attribute. The `GTiff` attribute will work with all ISIS [pixel type attributes](https://astrogeology.usgs.gov/docs/concepts/isis-fundamentals/command-line-usage/#pixel-type) and [label format attributes](https://astrogeology.usgs.gov/docs/concepts/isis-fundamentals/command-line-usage/#label-format). [Pixel storage order](https://astrogeology.usgs.gov/docs/concepts/isis-fundamentals/command-line-usage/#pixel-storage-order) does not work and will not perform any alterations to the byte ordering.