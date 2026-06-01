# Processing Chandrayaan 2 OHRC Images

More info on Chandrayaan 2:

- [Chandrayaan 2 Mission - USGS Astro](https://astrogeology.usgs.gov/docs/concepts/missions/chandrayaan2)
- [Processing Chandrayaan 2 TMC-2 Images](ingesting-tmc2.md)
- [Chandrayaan 2 Stereo - Ames Stereo Pipeline](https://stereopipeline.readthedocs.io/en/latest/examples/chandrayaan2.html)

The OHRC (Orbiter High Resolution Camera) is a panchromatic pushbroom camera
with a ground sample distance of about 0.25 m. The ingestion workflow is the
same as for [TMC-2](ingesting-tmc2.md), with one intentional difference in how
the SPICE kernels are sourced (see the note below).

### Environment

You will need:

* ISIS 10.0.0_RC2
* ALE >= 1.1.3
* SpiceQL >= 1.2.7
* usgscsm

To install these with conda:
```sh
conda create -n ch2 \
    -c usgs-astrogeology/label/RC \
    -c conda-forge \
    matplotlib isis=10.0.0_RC2 ale=1.1.3 usgscsm=2.0.2
conda activate ch2 # activate env
```

!!! Note "ISIS 10 release candidate"

    ISIS 10 has not been formally released yet, so the command above installs the
    `10.0.0_RC2` release candidate from the `usgs-astrogeology/label/RC` channel.

### Image Data, Label, and Template

The `.img` image and `.xml` label are required to import an OHRC image into the
ISIS cube format. These can be downloaded from [ISRO's interactive map](https://chmapbrowse.issdc.gov.in)
or [ISRO's PRADAN system for bulk downloads](https://pradan.issdc.gov.in/ch2/protected/payload.xhtml).
(New users must register an account.)

!!! Note "SPICE Kernel Coverage"

    Chandrayaan 2 SPICE kernels are distributed through the ISIS data area and
    fetched with `downloadIsisData chandrayaan2 $ISISDATA` (see the next section).
    Coverage may still lag for the most recent acquisitions. You can check which
    kernels are available with the following CURL command:

    ```bash
    curl -XGET "https://astrogeology.usgs.gov/apis/spiceql/latest/searchForKernelsets?spiceqlNames=\[chandrayaan2\]&limitCk=-1&limitSpk=-1" | jq
    ```

    The filenames for CKs and SPKs tell you their time coverage.

### Set Environmental Variables

ISIS requires `ISISROOT` and `ISISDATA` to be set. You can set `ISISROOT` equal
to the `CONDA_PREFIX`. You will need to [set up the ISIS Data Area](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/isis-data-area/)
and set `ISISDATA` to point to it, with at least the `base` and `chandrayaan2`
areas installed:

```bash
downloadIsisData base $ISISDATA
downloadIsisData chandrayaan2 $ISISDATA
```

### Create an ISIS compatible Cube or GTiff

Import the image with `isisimport`, attach the kernels with `spiceinit`, then
create the ISD with `isd_generate`:

```sh
isisimport from=ch2_ohr_ncp_20211228T2209123959_d_img_d18.xml to=ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub
spiceinit from=ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub
# create an ISD; this writes ch2_ohr_ncp_20211228T2209123959_d_img_d18.json
isd_generate -k ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub
```

!!! Note "Why OHRC uses `spiceinit` and `isd_generate -k`"

    Unlike the [TMC-2 workflow](ingesting-tmc2.md), which reads kernels from the
    local data area with `isd_generate -s`, OHRC runs `spiceinit` first and then
    `isd_generate -k`. For OHRC, `spiceinit` cleanly attaches the SPICE kernels to
    the cube, so `-k` reads them directly from the cube. This is the most
    reproducible path from a fresh `downloadIsisData`, as it does not require any
    local metakernel setup. The `-s` approach used for TMC-2 also works if you
    prefer to read kernels from the local `ISISDATA` area.

    The cube name appears twice on purpose: `-k <cube>` points `isd_generate` at
    the SPICE kernels attached by `spiceinit`, and the second occurrence is the
    input image the ISD is generated for.

    You can troubleshoot `isd_generate` with `-v`. The most common issue is
    missing kernels covering the image's time range.

Check you have the files; you will need the `.json` and `.cub`:

```
ls -1
# ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub
# ch2_ohr_ncp_20211228T2209123959_d_img_d18.img
# ch2_ohr_ncp_20211228T2209123959_d_img_d18.json
# ch2_ohr_ncp_20211228T2209123959_d_img_d18.xml
```

From here you can use the `.cub` and `.json` for any CSM compatible tool like
Socet GXP or Ames Stereo Pipeline.

### Create an ISIS-compatible image

To use this image in ISIS, you will need to combine the JSON ISD with the cube.
These can be written as an ISIS Cube or GTiff. We recommend GTiffs given the
large size of CH2 images.

```
mamba install usgscsm # if not installed already
csminit from=ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub isd=ch2_ohr_ncp_20211228T2209123959_d_img_d18.json
cubeatt from=ch2_ohr_ncp_20211228T2209123959_d_img_d18.cub to=ch2_ohr_ncp_20211228T2209123959_d_img_d18.tiff+GTIFF
```

You can view the image with `qview`, `qgis`, or other tools designed for spatial
data. The image is large and may take a moment to render.

```bash
qview ch2_ohr_ncp_20211228T2209123959_d_img_d18.tiff
```

From here you can use the image in other ISIS apps such as `footprintinit` and
`cam2map`. Initial pointing in OHRC has errors (as with most instruments), so
bundle adjustment is necessary for accuracy.

See for bundle adjustment info: https://astrogeology.usgs.gov/docs/how-to-guides/image-processing/bundle-adjustment-in-isis/

See for OHRC stereo info in ASP: https://stereopipeline.readthedocs.io/en/latest/examples/chandrayaan2.html
