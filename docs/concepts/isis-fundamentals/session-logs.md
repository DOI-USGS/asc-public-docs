# Session Logs

Session logs are a way for users to keep track of work they have done. They record the execution of an ISIS program or sequence of ISIS programs. Info written to the log includes:

- Program run, with:
    - Version, Date/time run, Computer name, Username, Description
    - Groups for:
        - User input parameters, Results, Accounting, and Errors (if any occur)

## Format

Session logs are output in the Parameter Value Language (PVL) format; below are two examples.

??? abstract "Session Log File recording a High Pass Filter"
    ```ini
    Object = Highpass
      IsisVersion        = 3.0
      ProgramVersionDate = 2003-05-16
      ExecutionDateTime  = 2003-06-25T12:18:45
      ComputerName       = char
      UserName           = janderso
      ProgramDescription = "Apply a high pass filter to a cube"
    
      Group = UserParameters
        From      = input.cub
        To        = output.cub
        Samples   = 5
        Lines     = 5
        Low       = "Use all pixels" 
        High      = "Use all pixels"
        Minimum   = 0
        Propagate = True
      EndGroup
    
      Group = Results
        PixelsChanged  = 1024000
        PercentChanged = 100.0
      EndGroup
    
      Group = Accounting
        ConnectTime  = 0:00:05.2
        CpuTime      = 0:00:04.1
        DirectIO     = 0
        PageFaults   = 2673
        ProcessSwaps = 0
      EndGroup
    EndObject
    ```

??? failure "Session Log File with Error"

    Notice `Group = Error` and the associated error information.
    ```ini
    Object = Highpass
      IsisVersion        = 3.0
      ProgramVersionDate = 2003-05-16
      ExecutionDateTime  = 2003-06-25T12:18:45
      ComputerName       = char
      UserName           = janderso
      ProgramDescription = "Apply a high pass filter to a cube"
    
      Group = UserParameters
        From      = moon.cub
        To        = output.cub
        Samples   = 5
        Lines     = 5
        Low       = "Use all pixels" 
        High      = "Use all pixels"
        Minimum   = 0
        Propagate = True
      EndGroup
    
      Group = Error
        Program = Highpass
        Class   = "I/O ERROR"
        Code    = -3
        Message = "Unable to open cube [moon.cub]"
        Source  = IsisCube.cpp
        Line    = 203
      EndGroup
    EndObject
    ```

## Output

Output of session logs can be set with [ISIS user preferences](../../concepts/isis-fundamentals/preference-dictionary.md).
File and Terminal/STDOUT output can both be set On or Off independently. 
If `FileOutput` is `On`, then the `FileName` and `FileAccess` parameters will apply.

```ini
    # Isis Preferences File
    Group = SessionLog
      TerminalOutput = On | Off
      FileOutput = On | Off
      FileName = print.prt
      FileAccess = Append | Overwrite
    EndGroup
```

!!! tip "Terminal Output and Redirection"

    If `TerminalOutput` is `On`, info will be logged to STDOUT (the terminal), 
    and standard Unix constructs may be used to redirect the output. For example,

        stats from=moon.cub > stats.log