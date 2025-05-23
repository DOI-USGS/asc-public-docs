# Preference Dictionary

## Introduction

This reference document describes the elements of the ISIS Preference file.

## Types of Preference Files

### System Preference File

Your local ISIS administrator manages a system-wide preference file. The file $ISISROOT/IsisPreferences, is in Parameter Value Language (PVL) format, and contains specifications for how ISIS should operate. For example,

```
Group = UserInterface
  ProgressBarPercent = 10
EndGroup
```

### User Preference File

The user can override elements of the system wide preference file by creating a personal preference file. The file must reside in the hidden directory $HOME/.Isis and must be named IsisPreferences.

An example usage is,
```
Group = UserInterface
  ProgressBarPercent = 1
EndGroup
```

### Project Preference File 

Finally the highest priority preference file is a project file. It is specified on the command line when executing ISIS applications. For example,

`highpass -pref=/bigProject/Preferences`

## User Interface

The preference file's user interface group enables customization of how applications run and their graphical appearance. In both graphical and command line modes, users receive a progress indicator. The progress bar's increment can be tailored to increase by 1%, 2%, 5%, or 10%. Additionally, in command line mode, users can opt to disable the progress bar. GUI style options include Windows and Fusion. Users can specify the browser launched from the GUI, as well as the GUI's font type and size. By default, all history files are stored in the user's home directory under .Isis/history, but this can be customized to save files in the current directory (using '.') or any other directory. Users can also disable history recording if they prefer not to record program history.

```
Group=UserInterface
  ProgressBarPercent = 1 | 2 | 5 | 10
  ProgressBar        = On | Off
  GuiStyle           = windows | fusion
  GuiHelpBrowser     = firefox { your preferred browser, may need path }
  GuiFontName        = helvitica | times | charter | any legal font
  GuiFontSize        = 10 | 12 | 14 | any font point size
  HistoryPath        = $HOME/.Isis/history { your preferred location for the application .par files }
  HistoryRecording   = On | Off
  HistoryLength      = your preferred count of history entries to remember
EndGroup
```

### GuiStyle Examples

| Default  | Windows | Fusion |
| -------- | ------- | ------ |
| [![[jigsaw default style GUI Screenshot]](../../assets/isis-fundamentals/default-style.png)](../../assets/isis-fundamentals/default-style.png)  | [![[jigsaw windows style GUI Screenshot]](../../assets/isis-fundamentals/windows-style.png)](../../assets/isis-fundamentals/windows-style.png)    | [![[jigsaw fusion style GUI Screenshot]](../../assets/isis-fundamentals/fusion-style.png)](../../assets/isis-fundamentals/fusion-style.png) |

## Error Facility

Errors can be written in either **standard** (single line) or **PVL** format, with the option to suppress the source file and line number identifying where the error occurred.  Deprecation warnings can be shown or hidden.  Additionally, stack traces can be displayed when running ISIS in debug mode.

```
Group = ErrorFacility
  Format   = Standard | Pvl
  FileLine = On | Off
  ShowDeprecated = On | Off
  StackTrace = On | Off
EndGroup
```

## ShapeModel

These parameters govern the selection of the ray-tracing engine for handling shape models. To utilize the ISIS default, either omit or comment out the ShapeModel group. The tolerance, measured in kilometers, is used to assess the visibility or occlusion of a point.

```
Group = ShapeModel
  RayTraceEngine = Bullet | Embree
  OnError = Continue | Fail
  Tolerance = { numerical value that will be set as the
                tolerance for the Bullet or Embree shape
                model }
EndGroup
```

## Session Log

These parameters govern the session log, allowing for complete logging cessation, directing logs to a terminal, a file, or both. The log file's name is customizable, and its content can either overwrite existing data or be appended to it.

```
TerminalOutput = On | Off
FileOutput = On | Off
FileName = print.prt | /mydirectory/myfile.prt
FileAccess = Append | Overwrite
```

| TerminalOutput | |
| --- | --- |
| On - in command-line mode | User input parameters, results, and accounting are reported to the terminal. Errors are reported in Pvl format, also to the terminal. |
| On - in interactive mode | Similar to command-line mode, but the output is directed to the GUI. In the event of an error, nothing is reported to the GUI except a pop-up window displaying the error. |
| Off - in command-line mode | Only the results are reported to the terminal. In the case of an error, the error is reported in PVL format to the terminal. |
| Off - in interactive mode | Similar to command-line mode, but errors are reported in a pop-up window in the GUI. |


## Cube Customization

Users have control over the specific attributes of cube I/O operations. They can determine whether programs will:

1. Automatically overwrite an existing cube or issue an error message.
2. Generate a single attached file containing labels, history, and cube data, or create a detached cube with three separate files (label, history, data).
3. Record a history entry of the program in the cube file.
4. Define the maximum size of the cube in gigabytes.

```
Group = CubeCustomization
  Overwrite  = Allow | Error
  Format     = Attached | Detached
  History    = On | Off
  MaximumSize = max # of gigabytes
EndGroup
```

## File Customization
Users can configure whether non-cube files can be overwritten or if an error should be triggered instead.

```
Group = FileCustomization
  Overwrite = Error | Allow
EndGroup
```

## Performance

Users have the option to tailor how ISIS utilizes the resources of their computer.

```
Group = Performance
  CubeWriteThread = Always | Optimized | Never
  GlobalThreads = Optimized | N
EndGroup
```

| CubeWriteThread| |
|---|---|
|Always | Override ISIS program defaults and consistently utilize a separate thread for writing out cubes. While this change may enhance performance for certain programs, it could potentially have a negative impact on programs that read and write the same file. This option should be approached with caution. |
| Optimized | Allow the ISIS program to make decisions based on its own internal knowledge. |
| Never | Revert to the original method of writing cubes. |

| GlobalThreads| |
|---|---|
| Optimized | The number of global (active processing) threads utilized will align with the current system's CPU core count. |
| N | Global (processing threads) handle the majority of CPU-intensive operations in ISIS. This value should be a positive whole number greater than 0. Note that this number doesn't affect the count of other thread types in ISIS, such as the cube write thread, but it should provide a reasonable estimate of overall CPU usage potential in ISIS. |

## Plugins
Users can specify the locations where ISIS should search for Community Sensor Model (CSM) plugins. The value of this keyword should be a list of paths containing CSM plugin libraries. 

For developers, see [Adding USGSCSM Plugin to ISIS](../../how-to-guides/environment-setup-and-maintenance/adding-usgscsm-plugin-to-isis.md#for-developers) for setting up USGSCSM plugins in ISIS Preferences.

```
Group = Plugins
  CSMDirectory = ("$ISISROOT/lib/csmplugins/", -
                  "$ISISROOT/lib/isis/csm3.0.3/", -
                  "$ISISROOT/csmlibs/3.0.3/", -
                  "$HOME/.Isis/csm3.0.3/")
EndGroup
```

## Data Directories

ISIS supports numerous missions that necessitate various data, such as SPICE kernels or calibration files. Given that these files can be substantial in size, it may be necessary to relocate the data to different directories from the standard distribution. This customization facilitates meeting that requirement. Typically, the ISIS system manager would adjust this group in the system-wide preference file.

```
Group = DataDirectory
  Apollo15     = $ISISDATA/apollo15
  Apollo16     = $ISISDATA/apollo16
  Apollo17     = $ISISDATA/apollo17
  Base         = $ISISDATA/base
  Cassini      = $ISISDATA/cassini
  Chan1        = $ISISDATA/chan1
  Chandrayaan1 = $ISISDATA/chandrayaan1
  Clementine1  = $ISISDATA/clementine1
  Clipper      = $ISISDATA/../datalocal/clipper
  Control      = $ISISDATA/control
  Dawn         = $ISISDATA/dawn
  Galileo      = $ISISDATA/galileo
  Hayabusa     = $ISISDATA/hayabusa
  Hayabusa2    = $ISISDATA/hayabusa2
  Juno         = $ISISDATA/juno
  Kaguya       = $ISISDATA/kaguya
  Lo           = $ISISDATA/lo
  Lro          = $ISISDATA/lro
  Mariner10    = $ISISDATA/mariner10
  Mer          = $ISISDATA/mer
  Mex          = $ISISDATA/mex
  Messenger    = $ISISDATA/messenger
  Mgs          = $ISISDATA/mgs
  Mro          = $ISISDATA/mro
  Near         = $ISISDATA/near
  NewHorizons  = $ISISDATA/newhorizons
  Odyssey      = $ISISDATA/odyssey
  OsirisRex    = $ISISDATA/osirisrex
  Rolo         = $ISISDATA/rolo
  Rosetta      = $ISISDATA/rosetta
  Smart1       = $ISISDATA/smart1
  Tgo          = $ISISDATA/tgo
  Viking1      = $ISISDATA/viking1
  Viking2      = $ISISDATA/viking2
  Voyager1     = $ISISDATA/voyager1
  Voyager2     = $ISISDATA/voyager2
  Temporary    = .
EndGroup
```

