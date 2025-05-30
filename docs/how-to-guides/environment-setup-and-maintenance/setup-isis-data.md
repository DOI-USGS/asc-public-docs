# Setting up ISIS data for a new mission

Every spacecraft camera that ISIS supports requires a directory in the [`ISIS data area`](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/isis-data-area/). It stores the camera position, orientation, sensor properties, etc.; data that is later added to an image to process with [spiceinit](https://isis.astrogeology.usgs.gov/9.0.0/Application/presentation/Tabbed/spiceinit/spiceinit.html). This page documents how to set up such a directory for a new mission, with the Chandrayaan-2 Lunar orbiter data serving as an example.

The environemntal variable ISISDATA points to the top-most directory in the ISIS data area. We will create there the subdirectory `${ISISDATA}/chandrayaan2`, and inside of it there will be a directory named ``kernels`` that will have the above-mentioned metadata, which in the planetary data community is called [SPICE kernels](https://naif.jpl.nasa.gov/naif/index.html).

The ``kernels`` directory has subdirectories with names such as ``spk``, ``ck``, ``ik``, etc., whose meaning will be discussed shortly. Ech of these must have one more index files, in plain text, with a name such as kernels.0000.db, that enumerates the SPICE kernels and some of their properties.

For ``spk`` and ``ck`` kernels, ISIS3 provides a dedicated tool called [kerneldbgen](https://isis.astrogeology.usgs.gov/8.3.0/Application/presentation/PrinterFriendly/kerneldbgen/kerneldbgen.html). For the others, this index file needs to be set up manually.

## SPK kernels

SPK stands for Spacecraft Position Kernels. They conctain the ephemeris (position and velocity) information for spacecraft, planetary bodies, etc. The kernels usually have the ``.bsp`` extension. Create the directory:

```sh

  $ISISDATA/chandrayaan2/kernels/spk

```

and copy there these files. Then, to create the index files with .db extension, run a command as::

```sh

   cd ${ISISDATA}

   kerneldbgen                                       \
    to = '$chandrayaan2/kernels/spk/kernels.????.db' \
    type = SPK                                       \
    recondir = '$chandrayaan2/kernels/spk'           \
    reconfilter = 'ch2*.bsp'                         \
    lsk = '$base/kernels/lsk/naif????.tls'

```

It is very important to use simple quotes above, not double quotes, so that the shell does not expand these variables. This also ensures relative paths are created, rather than absolute ones specific to a given file system. Before rerunning this command, delete any existing .db files, as otherwise new entries will be made.

There may be options for smitheddir and smithedfilter that point to the directory containing "smithed" (predicted or less precise) SPK files. Often, these can be the same as recondir and reconfilter if all your SPK files are in one place. See this program's documentation for details. 

Some ISIS data directories have a script named ``makedb`` that has the precice invocation of this program for that directory. Those can serve as other examples.

## CK kernels

 CK (Spacecraft Pointing Kernels) contain the attitude (orientation) information for the spacecraft and its instruments. The command for assembling the index file for this is very similar.

```sh

  kerneldbgen                                                      \
    to = "${ISISDATA}/chandrayaan2/kernels/ck/kernels.????.db"     \
    type = CK                                                      \
    recondir = "${ISISDATA}/chandrayaan2/kernels/ck"               \
    reconfilter = 'ch2*.bc'                                   \
    sclk = "${ISISDATA}/chandrayaan2/kernels/sclk/ch2_sclk_v1.tsc" \
    lsk = "${ISISDATA}/base/kernels/lsk/naif????.tls"
``
            
The parameters are identical in meaning to the SPK setup, but type=CK is used.

3. Manual set up of other kernel types

For the following kernel types, kerneldbgen is not used. Simply create a plain
text kernels.db (or kernels.0001.db) file in the respective directory and list
the specific kernel files ISIS should load.

3.1 IK Kernels (Instrument Kernels)

IK kernels provide detailed information about the instrument's physical properties, such as focal length, pixel scale, and distortion models. They are essential for accurate camera modeling.

Navigate to your mission's IK kernel directory (e.g.,
$ISISDATA/chandrayaan2/kernels/ik/). Create a file named kernels.0001.db (or
kernels.db) with content like this, listing the .ti files and their
corresponding InstrumentId values:

Object = Instrument
  Group = Selection
    Match = ("Instrument","InstrumentId","IIR")
    File  = ("chandrayaan2", "kernels/ik/ch2_iir_v01.ti")
  EndGroup

  Group = Selection
    Match = ("Instrument","InstrumentId","OHR")
    File  = ("chandrayaan2", "kernels/ik/ch2_ohr_v01.ti")
  EndGroup

  Group = Selection
    Match = ("Instrument","InstrumentId","TMC-2")
    File  = ("chandrayaan2", "kernels/ik/ch2_tmc_v01.ti")
  EndGroup
EndObject

The Match parameter's InstrumentId must precisely match the ID defined within the .ti kernel file itself. Otherwise one may get errors about a null instrument.

Consider also inspecting the analogous files for other missions, for comparison.

3.2. FK Kernels (Frame Kernels)

What they mean: FK kernels define reference frames that are not intrinsically defined by SPICE (like spacecraft frames or instrument frames) and establish relationships between them. They are crucial for transforming data between different coordinate systems.

Setup Example (kernels.db content):

Navigate to your mission's FK kernel directory (e.g., $ISISDATA/chandrayaan2/kernels/fk/).
Create a file named kernels.0001.db (or kernels.db) with content like this, listing your .tf (Text Frame) files:

Object = Frame
  Group = Selection
    File = ("chandrayaan2", "kernels/fk/ch2_v01.tf")
  EndGroup
EndObject

3.3 SCLK Kernels (Spacecraft Clock Kernels)

SCLK kernels contain the mapping between the spacecraft's internal clock time (SCLK) and ephemeris time (ET).

Setup Example (kernels.db content):

Navigate to your mission's SCLK kernel directory (e.g., $ISISDATA/chandrayaan2/kernels/sclk/).
Create a file named kernels.db (or kernels.0001.db) with content like this, listing your .tsc (Text Spacecraft Clock) files:

Object = SpacecraftClock
  Group = Selection
    File = ("chandrayaan2", "kernels/sclk/ch2_sclk_v1.tsc")
  EndGroup
EndObject

3.5. LSK Kernels (Leapsecond Kernels)
What they mean: LSK kernels define the relationship between Ephemeris Time (ET), Universal Time (UT), and other time systems, accounting for leap seconds. They are fundamental for accurate time conversions in all SPICE computations.

Setup Example (kernels.db content):
LSK kernels are typically global to your ISIS3 installation, usually found in $ISISDATA/base/kernels/lsk/.
Create a file named kernels.db (or kernels.0001.db) in that directory with content like this, listing your .tls (Text Leapsecond) files:

Object = Leapsecond
  Group = Selection
    File = ("base", "kernels/lsk/naif????.tls")
  EndGroup
EndObject
Note the use of "base" as the mission name, indicating it's part of the base ISIS3 data.

3.6. PCK Kernels (Planetary Constants Kernels)
What they mean: PCK kernels provide orientation models for natural bodies (like planets, moons, asteroids) and their physical constants (e.g., radii, rotation rates, gravitational parameters). This allows ISIS to accurately model the shape and orientation of targets.

Setup Example (kernels.db content):
PCK kernels are also typically global to your ISIS3 installation, usually found in $ISISDATA/base/kernels/pck/.
Create a file named kernels.db (or kernels.0001.db) in that directory with content like this, listing your .tpc (Text PCK) or .bpc (Binary PCK) files:

Object = PlanetaryConstants
  Group = Selection
    File = ("base", "kernels/pck/pck?????.tpc")
  EndGroup
  Group = Selection
    File = ("base", "kernels/pck/moon_366.bpc") # Example for a binary PCK
  EndGroup
EndObject

Again, "base" indicates it's part of the base ISIS3 data.

3.7. IAK Kernels (Instrument Addendum Kernels)

What they mean: IAK kernels provide additional, instrument-specific information
that is not typically found in standard IK files. This can include subtle
detector characteristics, advanced distortion models, or unique calibration
parameters. For Chandrayaan2 data, this file was not supplied and needed to be
guessed.

Setup Example (kernels.db content - including empty):

Navigate to your mission's IAK kernel directory (e.g.,
$ISISDATA/chandrayaan2/kernels/iak/). If this directory doesn't exist, you'll
need to create it first:

Bash

mkdir -p $ISISDATA/chandrayaan2/kernels/iak

To make an empty IAK database: If you don't have specific IAK files for your
mission/instrument but ISIS3 is still looking for an IAK database, you can
create a minimal, empty one. This satisfies spiceinit without actually loading
any specific IAK data. Create a file named kernels.db (or kernels.0001.db) in
your iak directory with just the basic object definition:

Object = InstrumentAddendum
EndObject
This tells ISIS that an IAK database exists, but it's currently empty.

If you do have specific IAK files (e.g., ch2_tmc_iak_v01.ti):
Your kernels.db would look like this:

Object = InstrumentAddendum
  Group = Selection
    Match = ("Instrument","InstrumentId","TMC-2") # Or the actual InstrumentId from your IAK file
    File  = ("chandrayaan2", "kernels/iak/ch2_tmc_iak_v01.ti")
  EndGroup
EndObject

Ensure that the instrument id is correctly specified.

9. EK Kernels (Event Kernels)

What they mean: EK kernels contain "event" data, which can be anything from
geological features on a planetary surface to specific mission events. These are
often used for specialized analyses or to define regions of interest. They are
less commonly needed for basic spiceinit operations.

Setup Example (kernels.db content):

Navigate to your mission's EK kernel directory (e.g., $ISISDATA/chandrayaan2/kernels/ek/).
Create a file named kernels.db (or kernels.0001.db) with content like this, listing your .ek files:

Object = Event
  Group = Selection
    File = ("chandrayaan2", "kernels/ek/ch2_science_events.ek")
  EndGroup
EndObject

By systematically setting up these kernel directories and their corresponding .db files, you provide ISIS3 with all the necessary SPICE information to accurately process and understand your planetary data. Remember to always verify your kernel file patterns and the exact InstrumentIds to ensure a smooth spiceinit experience!
