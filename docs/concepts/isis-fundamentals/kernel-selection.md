# ISIS Kernel Load Selection

ISIS selects the SPICE kernels to be used with an ISIS cube as part of running the spiceinit application.

The user can enter kernels they would like to load via `spiceinit` (either by hand, or with a parameter file) or use the spice server, but that is not covered by this write up. This documents what happens when `spiceinit` selects kernels from the default location (`$ISIS3DATA/mission/kernels` or a different location specified by the `IsisPreferences` file) using the ISIS kernel databases. 

In spiceinit, the `KernelDb` class is used to select which kernels to load. This class can be called directly to query the ISIS kernel databases if desired.

## Kernel Types

First, the allowed kernel “types” are specified for both cks and spks: 

- **Nadir** : The worst quality kernel. Used as a last resort because it assumes the spacecraft is always nadir-looking.
- **Predicted** : Preliminary kernels produced by a mission with best-estimates of where the spacecraft will be.
- **Reconstructed** : Typically produced by a mission a few weeks after the target has been reached.
- **Smithed** : The best quality kernel, will be used first when selected. Smithed kernels have been improved or adjusted for accuracy by a mission team or for the purpose of a cartographic product. Consider the source, content and completeness of Smithed kernels when selecting this level of quality. 

Kernels of a non-allowed type will not be selected, and the highest quality kernel that meets the other selection criteria will be returned.

Above, the types are in order of lowest to highest quality kernel category. For more information about these kernel quality categories, and the spiceinit application, please see [spiceinit documentation](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html).

## Kernel Selection

1. The location of the correct kernel database file to use is determined using the mission name, the cube’s label (to get the `InstrumentID`), and the user's `IsisPreferences` file. There is one kernel.db file for each "type" of kernel needed by the image (ck, spk, fk, ik, iak...) but these are simple files for all but the cks and spks (TODO: Add more detail here).

1. The most recent kernel database file in the appropriate directory is loaded (unless there is a kernel configuration file, see *Kernel Configuration File* below). Kernel databases are updated when new kernels become available or there is a change to which kernels need to be loaded communicated from the team. 

1. The `StartTime` and `StopTime` keywords from the `Instrument` group in the input cube label are used to search through the available kernels as specified by PVL groups in the kernel database file and determine the best match. `StopTime` is an optional keyword in ISIS cubes, so if it is not available, it is set equal to the `StartTime`

!!! info "Kernel Configuration File"

    A kernel configuration file is a file of the form `kernels.????.conf` that contains information about which kernel database files to load in which cases.

## Kernel Distribution Infrastructure

In the ISIS data area, shell scripts within each ck and spk directory that receive new kernels from an automated download script are run to re-generate kernel database files when new kernels are downloaded. These scripts are usually named `makedb` and call the ISIS application makedb. After update, in most cases, these new kernels and kernel database files are immediately pushed to the rsync server. 