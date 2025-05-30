# Setting up ISIS data for a new mission

Every spacecraft camera that ISIS supports requires a directory in the [`ISIS data area`](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md). It stores the camera position, orientation, sensor properties, etc.; data that is later added to an image to process with [spiceinit](https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html). This page documents how to set up such a directory for a new mission, with the Chandrayaan-2 Lunar orbiter data serving as an example.

The environmental variable ISISDATA points to the top-most directory in the ISIS data area. We will create there the subdirectory `${ISISDATA}/chandrayaan2`, and inside of it there will be a directory named ``kernels`` that will have the above-mentioned metadata, which in the planetary data community is called [SPICE kernels](https://naif.jpl.nasa.gov/naif/index.html).

The ``kernels`` directory has subdirectories with names such as ``spk``, ``ck``, ``ik``, etc., whose meaning will be discussed shortly. Ech of these must have one more index files, in plain text, with a name such as ``kernels.0000.db``, that enumerates the SPICE kernels and some of their properties.

For ``spk`` and ``ck`` kernels, ISIS3 provides a dedicated tool called [kerneldbgen](https://isis.astrogeology.usgs.gov/9.0.0/Application/presentation/Tabbed/kerneldbgen/kerneldbgen.html). For the others, this index file needs to be set up manually.

## SPK kernels

SPK stands for Spacecraft Position Kernels. They contain the ephemeris (position and velocity) information for spacecraft, planetary bodies, etc. The kernels usually have the ``.bsp`` extension. Create the directory:

```sh

  $ISISDATA/chandrayaan2/kernels/spk

```

and copy there these files. Run a command as:

```sh

   cd ${ISISDATA}/chandrayaan2/kernels/spk

   kerneldbgen                                       \
    to = '$chandrayaan2/kernels/spk/kernels.????.db' \
    type = SPK                                       \
    recondir = '$chandrayaan2/kernels/spk'           \
    reconfilter = 'ch2*.bsp'                         \
    lsk = '$base/kernels/lsk/naif????.tls'

```

It is very important to use simple quotes above, not double quotes, so that the shell does not expand these variables. This also ensures relative paths are created, rather than absolute ones specific to a given file system. Before rerunning this command, delete any existing ``.db`` files, as otherwise new entries will be made.

This will create an index file such as ``kernels.0000.db``. This normally has four digits, and the number gets incremented if there is more than one index. 

Save this command to a shell script in the current directory named ``makedb``, so that it keeps a record of how the index ws produced. See also the ``makedb`` script for other datasets, for comparison.

## CK kernels

 CK (Spacecraft Pointing Kernels) contain the attitude (orientation) information for the spacecraft and its instruments. The command for assembling the index file for this is very similar.

```sh

   cd ${ISISDATA}/kernels/ck

   kerneldbgen                                           \
     to = '$chandrayaan2/kernels/ck/kernels.????.db'     \
     type = CK                                           \
     recondir = '$chandrayaan2/kernels/ck'               \
     reconfilter = 'ch2*.bc'                             \
     sclk = '$chandrayaan2/kernels/sclk/ch2_sclk_v1.tsc' \
     lsk = 'base/kernels/lsk/naif????.tls'
```

## IK Kernels

IK (Instrument Kernels) provide detailed information about the instrument's physical properties, such as focal length, pixel scale, and lens distortion models.

Go to ``$ISISDATA/chandrayaan2/kernels/ik``. Create a file named ``kernels.0000.db`` (or ``kernels.db``) with content along the lines of:

```sh

   Object = Instrument
     Group = Selection
       Match = ("Instrument", "InstrumentId","IIR")
       File  = ("chandrayaan2", "kernels/ik/ch2_iir_v01.ti")
     EndGroup

     Group = Selection
       Match = ("Instrument", "InstrumentId","OHR")
       File  = ("chandrayaan2", "kernels/ik/ch2_ohr_v01.ti")
     EndGroup

     Group = Selection
       Match = ("Instrument", "InstrumentId","TMC-2")
       File  = ("chandrayaan2", "kernels/ik/ch2_tmc_v01.ti")
     EndGroup
   EndObject

```

It is very important to have the precise name of each instrument, and to ensure the proper ``.ti`` files are passed in.

Consider also inspecting the analogous files for other missions.

## FK Kernels

FK (Frame Kernels) define reference frames that are not intrinsically defined by SPICE (like spacecraft frames or instrument frames) and establish relationships between them. They are crucial for transforming data between different coordinate systems.

Navigate to your mission's FK kernel directory (for example, ``$ISISDATA/chandrayaan2/kernels/fk``). Create a file named ``kernels.0000.db`` (or ``kernels.db``) with content like this, listing your ``.tf`` (Text Frame) files:
   
```sh

   Object = Frame
     Group = Selection
       File = ("chandrayaan2", "kernels/fk/ch2_v01.tf")
     EndGroup
   EndObject

```

## SCLK Kernels

SLCK (Spacecraft Clock Kernels) contain the mapping between the spacecraft's internal clock time (SCLK) and ephemeris time (ET).

Navigate to your mission's SCLK kernel directory (e.g., ``$ISISDATA/chandrayaan2/kernels/sclk``). Create a file named ``kernels.db`` (or ``kernels.0001.db``) with content like this, listing your ``.tsc`` (Text Spacecraft Clock) files:

```sh
   
   Object = SpacecraftClock
     Group = Selection
       File = ("chandrayaan2", "kernels/sclk/ch2_sclk_v1.tsc")
     EndGroup
   EndObject
```

## IAK Kernels

IAK (Instrument Addendum Kernels) provide additional, instrument-specific information that is not typically found in standard IK files. This can include subtle detector characteristics, advanced distortion models, or unique calibration parameters. 

For Chandrayaan2 data, such kernels were not supplied and needed to be guessed.

Navigate (or create) your mission's IAK kernel directory (e.g., ``$ISISDATA/chandrayaan2/kernels/iak``). Create a file named ``kernels.db`` (or ``kernels.0001.db``) with content like:

```sh
   Object = InstrumentAddendum
     Group = Selection
       Match = ("Instrument","InstrumentId", "TMC-2")
       File  = ("chandrayaan2", "kernels/iak/ch2_tmc_iak_v01.ti")
     EndGroup
   EndObject
```

Ensure that the instrument id and ``.ti`` files are correctly specified. If no ``.ti`` entries exist, omit the ``Match`` and ``File`` entries.

## Other kernels

There exist a few kernels that apply to all missions, and are usually stored in the ``$ISISDATA/base/kernels`` directory. These include LSK (Leapsecond Kernels), PCK (Planetary Constants Kernels), and EK (Event Kernels). These should normally already exist in the data area.

## Record the new dataset

Add an entry of the form::

```sh

      Chandrayaan2 = $ISISDATA/chandrayaan2
```

to ``isis/IsisPreferences`` in the ISIS source directory for future uses, and to the local version of this file in the installation directory for local use. Ensure that the entry is in the ``DataDirectory`` group, as for other missions.
