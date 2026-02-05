# Chandrayaan 2

The Chandrayaan 2 is an Indian Space Research Organisation 
(ISRO) Lunar Mission. 
The Chandrayaan 2 Lunar Orbiter was launched in 2019 
and remains in successful operation (as of early 2026). 
The Orbiter's instruments, TMC-2 and OHRC, 
are notable for their high resolution images.

## Obtaining Chandrayaan 2 Images

Chandrayaan 2 images can be downloaded from the [ISRO Website](https://chmapbrowse.issdc.gov.in).  A login is required; new users must register an account.

## Using TMC-2 and OHRC Images in ISIS

Chandrayaan 2 images from the TMC-2 and OHRC instruments can be imported with [`isisimport`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/isisimport/isisimport.html).  Templates to import images from either instrument are included and should be autodetected in ISIS versions 10.0 and above.

!!! example "`isisimport` example"

    The Image (`.img`) and Label (`.xml`) files for an observation should be placed in the same directory, and the Label (`.xml`) file should be specified in the from parameter for `isisimport`:

    ```sh
    isisimport from=ch2_tmc_nca_20200207T0716469418_d_img_d18.xml to=ch2_tmc_nca_20200207T0716469418_d_img_d18.cub
    ```

-----

Further examples for processing these observations:

- [Chandrayaan 2 TMC-2 Images in Knoten - Astro Docs Jupyter Notebook](../../../getting-started/csm-stack/knoten-chandrayaan.ipynb)
- [Chandrayaan 2 OHRC - Ames Stereo Pipeline](https://stereopipeline.readthedocs.io/en/latest/examples/chandrayaan2.html)