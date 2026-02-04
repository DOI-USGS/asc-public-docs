#ISIS FAQ

??? question "How do I install ISIS?"

    There are two main ways of installing ISIS:

    __As a user__: ISIS releases are distributed using the Anaconda package manager. Through the package manager, you can download precompiled versions of ISIS including older versions. See [Installation][8] for installing via Anaconda. 


    __As a developer__: Anaconda is also used to maintain ISIS dependencies, so we generally advise developers to use Anaconda environments and provided environment files to build ISIS. See [Developing ISIS3 with cmake][9].

    [8]: ../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md
    [9]: ../../how-to-guides/isis-developer-guides/developing-isis3-with-cmake.md


??? question "How do I install a specific version of ISIS/update my current copy of ISIS?"

    During the installation process, you can use Anaconda’s syntax for specifying version numbers. 

    To update your version of ISIS, you simply run `conda update -c usgs-astrogeology isis=<version number>`.

    ISIS release candidates are tagged with “RC”. Installing/updating RC’s would require you to explicitly mention the RC label with `-c usgs-astrogeology/label/RC `.  ISIS Long Term Support releases are similarly tagged with "LTS".

    Examples:   
    `conda install -c usgs-astrogeology isis`, install the latest version of ISIS   
    `conda update -c usgs-astrogeology isis`, update to the latest version of ISIS   
    `conda update -c usgs-astrogeology isis=7.2.0`, update to ISIS version 7.2.0   
    `conda install -c usgs-astrogeology isis=7.2.0`, install ISIS version 7.2.0   
    `conda install -c usgs-astrogeology/label/RC isis=7.2.0`, install release candidate for ISIS version 7.2.0   
    `conda install -c usgs-astrogeology/label/LTS`, install the latest LTS version of ISIS 

    Related:

    - [List of ISIS versions on Conda](https://anaconda.org/usgs-astrogeology/isis/files)
    - [Maintaining your conda packages (conda docs)](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html)
    - [Semantic Versioning](https://github.com/DOI-USGS/ISIS3/tree/dev#Semantic-Versioning)
    - [Release Schedule](../../how-to-guides/software-management/isis-release-schedule.md)
    - [LTS Release Process](../../how-to-guides/software-management/lts-release-process.md)
    - [ISIS RFC8 - Long Term Support (LTS)](https://github.com/USGS-Astrogeology/ISIS3/discussions/4691)
    - [ISIS RFC14 - Changing ISIS Release Schedule](https://github.com/DOI-USGS/ISIS3/discussions/5731)


??? question "How do I keep two different versions of ISIS on my system and switch between them?"

    Yes, use a different conda environment for each version. This is useful for testing a development version of ISIS.  Follow the steps for installing ISIS using a new conda environment with a different name (e.g. `isis-lts` `isis7.2.0`, `isis-dev`).
    ```sh
    # Create a conda environment, this name can be whatever you like
    conda create -n isis7.2.0
    conda activate isis7.2.0
    
    # Install via conda, here you can specify which ISIS version you want to install.
    # See the previous question for more info on specifying the isis version.
    conda install -c usgs-astrogeology isis=7.2.0
    ```
    *Note: you may need to [add channels](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda/#channels) before running `conda install [...]`.*

??? question "I Installed ISIS but I get “<app>: command not found” or similar error."

    If you successfully installed ISIS with Anaconda, but still get this error, it’s because the installation directory was not added to your PATH. It’s generally not recommended you manually set your PATH to your Anaconda environment and instead should ensure your environment is activated by running `conda activate <isis3 env name>`. 

??? question "How do I install ISIS on Windows?"

    We do not officially support ISIS on windows. It may be possible using the Linux subsystem ([How to Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install), [ISIS and ASP on Windows 11 (WSL, take 3)](https://planetarygis.blogspot.com/2024/02/isis-and-asp-on-windows-11-wsl-take-3.html)).  This approach isn’t tested and we strongly recommend ISIS users operate MacOS, Linux or a Linux VM on Windows machines.

??? question "When trying to run an ISIS command, I get `Please set ISISROOT before running any Isis applications`"

    The environment variable `ISISROOT` needs to be set to the root of your installation directory. This is critical for using ISIS applications.  Without this variable set correctly, ISIS applications cannot run.

    Run  `isisVarInit.py`, located in the ISIS3 installation directory. This will make ISISROOT, ISIS3DATA, and ISIS3TESTDATA be set on environment activation.  


??? question "Why is `spiceinit` failing?"

    Spiceinit attaches kernel information to ingested ISIS cubes for later use in commands that require camera models (campt, cam2map, etc.). See [ISIS3 spiceinit documentation][3] for more details on spiceinit. If spiceinit is erroring there are two likely causes:

    * Base data area is not installed (See [Full or Partial ISIS Data Download][4] from the ISIS readme)
    * Mission-specific area is not installed (See [Mission Specific Data Downloads][5] from the ISIS readme)

    These errors can also be remedied by using the [SPICE Web Server][6] (web=true in command line or activating the web check box in GUI). __However__, some instruments require mission data to be present for calibration, which may not be supported by the SPICE Web Server exclusively, and some programs that are designed to run an image from ingestion through the mapping phase do not have an option to use the SPICE Web Service. For information specific to an instrument, see the documentation for radiometric calibration programs. 

    If spiceinit fails with `**PROGRAMMER ERROR** No value or default value to translate for translation group [MissionName]`, this is typical behavior in `spiceinit` when `spiceinit` input was output from `pds2isis`. `pds2isis` generates a cube without instrument specific data. Instead use an ingestion app specific to the image’s instrument. See [Locating and Ingesting Image Data][7] for basic ingestion workflows in ISIS. 

??? question "Why is my mission calibration command (‘ctxcal’,’lronaccal’, etc.) producing cubes filled with zero data?"

    The default setting for ‘RadiometricType’ on a lot of calibration commands is ‘IOF’ which stands for incidence solar flux. The calculation of this metric requires knowledge of the distance from the target body to the sun. Currently, the SPICE Web Server currently does not attach this information to the cube, so local version of the mission data are still necessary for this calculation. Using ‘RadiometricType=RADIANCE’ will not result in this error. To fix this error, download the base ISIS3 data and the mission specific data:

    - For base data installation see [Full or Partial ISIS Data Download][4] from the ISIS readme
    - For mission-specific area installation see [Mission Specific Data Downloads][5] from the ISIS readme

??? question "I updated my ISIS version and now my mission calibration command is throwing errors."

    Some ISIS software updates include mission specific command updates motivated by new information (updated kernels, format changes, etc.) from mission teams. When the software is updated the data area should also be updated, see [Mission Specific Data Downloads][5].

    [3]: https://isis.astrogeology.usgs.gov/Application/presentation/Tabbed/spiceinit/spiceinit.html
    [4]: ../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md#full-download
    [5]: ../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md#mission-specific-data-areas
    [6]: ../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md#isis-spice-web-service
    [7]: ../../getting-started/using-isis-first-steps/locating-and-ingesting-image-data.md

??? question "Can I still use legacy versions of ISIS?"

    ### Supported ISIS Versions

    LTS versions of ISIS are supported for 18 months from their release date ([RFC8](https://github.com/USGS-Astrogeology/ISIS3/discussions/4691), [RFC14](https://github.com/DOI-USGS/ISIS3/discussions/5731)).  Versions before that are not officially supported or maintained, may no longer be hosted by USGS Astrogeology, and/or ***may no longer be installable***.
    
    In particular, ISIS2 and Legacy ISIS3 distributions hosted on `isisdist.wr.usgs.gov` and `isisdist.astrogeology.usgs.gov` are no longer available.

    ### Legacy ISIS3 Versions 

    ISIS versions 3.6.1 and above are hosted on conda in the 
    [usgs-astrogeology channel](https://anaconda.org/usgs-astrogeology/repo). 
    Versions 3.6.1 to 3.9.1 are under the [isis3 package](https://anaconda.org/usgs-astrogeology/isis3/files), 
    and versions 3.10.0 onwards are under the [isis package](https://anaconda.org/usgs-astrogeology/isis/files). 
    
    Older versions of ISIS may have different setup requirements and/or different scripts to facilitate installation. Check the `README.md` in the GitHub repo (under your version's tag), and/or the [Software Manuals](https://isis.astrogeology.usgs.gov) for more information.

    ISIS versions back to 3.5.x may be viewed in the [ISIS GitHub source code repository](https://github.com/DOI-USGS/ISIS3/tree/v3.5.2) and the [ISIS Software Manuals](https://isis.astrogeology.usgs.gov/3.5.0/).  The [Legacy Install Guide](https://isis.astrogeology.usgs.gov/8.2.0/documents/LegacyInstallGuide/index.html) details the method of installation, but ISIS distributions hosted on `isisdist.astrogeology.usgs.gov` are no longer available.

    ### Legacy ISIS2 Documentation

    Some online ISIS2 documentation pages [remain here](https://isis.astrogeology.usgs.gov/Isis2/html/isis.html) for historical purposes, but they are unmaintained and unsupported.  The [Wayback Machine](https://web.archive.org/web/20030613002511/http://isis.astrogeology.usgs.gov/) may help you find missing pages or broken links.  As of 2025, the ISIS2 software does not appear to be installable; ISIS2 distributions are no longer hosted by USGS Astrogeology.
   

???+ abstract "Additional Helpful Docs"

    [Exhaustive list of ISIS commands](https://isis.astrogeology.usgs.gov/Application/index.html)

    [Glossary of terminology used in ISIS documentation](../../concepts/glossary.md)

    [Dictionary explaining label terms for ISIS cubes](https://isis.astrogeology.usgs.gov/documents/LabelDictionary/LabelDictionary.html)