# Using ShadowCam Data in ISIS

## Configuring Kernels and Calibration Files

--8<-- "docs/snippets/kernel-setup.md"

*The short-name for this mission is `kplo`.*

## Import & Calibration

In ISIS, Raw EDR ShadowCam images can be imported and calibrated as so:

```sh
shadowcam2isis from=M076035652SE.cub to=M076035652SE.2isis.cub
shadowcamcal from=M076035652SE.2isis.cub to=M076035652SE.cal.cub
```

*ISIS App Manuals: [`shadowcam2isis`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/shadowcam2isis/shadowcam2isis.html); [`shadowcamcal`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/shadowcamcal/shadowcamcal.html);*

!!! note "EDR vs Pre-Calibrated Images"

    An array of data products are available for each image. For our observation, M076035652S**C**.cub is the **C**alibrated 32-bit version, and M076035652S**E**.cub is the non-calibrated 8-bit **E**DR version.

    The pre-calibrated ISIS cubes do not need to be imported or calibrated, but still need `spiceinit`.  If run on a pre-calibrated ShadowCam cube, the import and calibration ISIS apps will notify that that their processing is not needed.

## Attaching SPICE

After import and calibration, attach spice information with [`spiceinit`](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html):

```sh
spiceinit from=M076035652SE.cal.cub
```

To initialize with a specific DEM, run `spiceinit` with `shape=user` instead, specifying your DEM with the `model=` option:

```sh
spiceinit from=M076035652SE.cal.cub shape=user model=$ISISDATA/base/dems/LRO_LOLA_LDEM_global_128ppd_20100915.cub
```

*The LOLA Global DEM is included in the ISIS Data Area. However, for higher resolution data a local DEM/DTM is recommended.  See [ShadowCam - Calculating Photometric Angles](shadowcam-photometric-angles.md) for more details.*