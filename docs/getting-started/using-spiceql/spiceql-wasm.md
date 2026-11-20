# Using SpiceQL WebAssembly Bindings

SpiceQL is an interface for querying data from NAIF SPICE Kernels.  It has WebAssembly (Wasm) Bindings so it can be used in Web, JavaScript, and Node.js environments.


With kernels loaded in to the virtual filesystem, SpiceQL can be used to let a web read data from it.

## Included Files

SpiceQL Wasm bindings are distributed via [NPM](https://www.npmjs.com/package/@usgs-astrogeology/spiceql).  The distribution includes [these files](https://www.npmjs.com/package/@usgs-astrogeology/spiceql?activeTab=code):

```sh
spiceql/
├── dist/
│   ├── naifspice.js        # raw CSPICE marshaller
│   ├── spiceql.js          # Wrapper (Import this one!!!)
│   ├── spiceql_wasm.data   # Config DB, Leap-second Kernel, naifspice signatures
│   ├── spiceql_wasm.js     # Emscripten Loader (ES Module)
│   └── spiceql_wasm.wasm   # WebAssembly Binary
├── LICENSE.md
├── README.md
└── package.json
```

## Installation

Create a project with [NPM](https://docs.npmjs.com/about-npm), or use [jsDelivr](https://www.jsdelivr.com) for a quick start.

=== "NPM"

    [NPM](https://docs.npmjs.com/about-npm) is a package manager, ideal for setting up a project with multiple dependencies.  Use [Vite](https://vite.dev/guide/) and install USGSCSM to setup a quick project:

    1.  **Get a Module Bundler** (See [webreference](https://webreference.com/javascript/advanced/module-bundlers/), [wikipedia](https://en.wikipedia.org/wiki/Module_bundler))

        Needed to resolve import path.  If starting from scratch, setup Vite:  

        ```sh
        # In your terminal in the project folder:
        npm create vite@latest
        ```

    2.  **Install SpiceQL**  

        ```sh
        # In your terminal in the project folder:
        npm install @usgs-astrogeology/spiceql
        ```

    3.  **Import SpiceQL** in your javascript

        ```js title="yourscript.js"
        import spiceql from "@usgs-astrogeology/spiceql/"
        ```

    4.  **Write Code with SpiceQL**

        See [Examples](#examples) below.

    5.  **Run A Server**
    
        If you're using Vite, by default, you should be able to run a local server with:  
        ```sh
        # In your terminal in the project folder:
        npm run dev
        ```

=== "jsDelivr (CDN)"

    [jsDelivr](https://www.jsdelivr.com) is a Content Delivery Network. It fetches SpiceQL from NPM (or GitHub) for a quick and easy import with no setup.  It may add a little bit of loading time though.

    ```js title="yourscript.js"
    import { loadSpiceQL } from 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/spiceql.js'
    ```

=== "Manual Download"

    Download the above files from the 
    [release page](https://github.com/DOI-USGS/spiceql/releases), 
    and place the files in your project directory.  (For this example, in a `scripts` folder.)

    ```js title="yourscript.js"
    import { loadSpiceQL } from "./scripts/spiceql.js"
    ```

## Limitations of Wasm Version

??? warning "A server or JS environment, and using `<script type="module" ...>` are required."

    Running a server or JS environment is required to use web assembly modules. 
    Just accessing a page with SpiceQL via `file://` won't work.

    #### Node

    `node` can run plain JS modules with a server-like environment:

    ```sh
    node yourSpiceQLscript.js
    ```

    #### Server

    For a full web app/project, 
    [Use NPM + Vite to setup a local server](#__tabbed_1_1).
    If python is installed, it can run a simple local server:

    ```sh
    # In your terminal in the project folder:
    python3 -m http.server 8080
    ```

    #### Module

    Use `type="module"` in the script tag in your HTML:

    === "HTML with separate .js file"

        ```html title="index.html"
        <script type="module" src="/src/yourscript.js"></script>
        ```

        ```js title="yourscript.js"
        // In your javascript:
        import { loadSpiceQL } from 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/spiceql.js';
        const spiceql = await loadSpiceQL();
          // ...
        ```

    === "HTML with embedded script"

        ```html title="index.html"
        <script type="module">
          import { loadSpiceQL } from 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/spiceql.js';
          const spiceql = await loadSpiceQL();
          // ...
        </script>
        ```

!!! warning "No Kernel Search in Wasm Version of SpiceQL"

    Some kernels (Leap-Second Kernels) are built in, but for queries that require other kernels, they must be loaded in to the file system.

???+ warning "Overriding Location (if SpiceQL is outside the working directory)"

    If importing SpiceQL from somewhere else, 
    you may have to manually override the file path when loading SpiceQL.

    *If you are using a module bundler, 
    you should be able to configure the library locations there
    instead of this configuration step.*

    === "Node"

        ```js
        import { loadSpiceQL } from './scripts/spiceql.js';
        
        const spiceqlBasePath = './scripts/';
        const spiceql = await loadSpiceQL({
            moduleOverrides: { locateFile: (path) => spiceqlBasePath + path }
        });
        ```

    === "CDN"

        ```js
        import { loadSpiceQL } from 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/spiceql.js';
        
        const spiceqlBasePath = 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/';
        const spiceql = await loadSpiceQL({
            moduleOverrides: { locateFile: (path) => spiceqlBasePath + path }
        });
        ```

## Examples

### Kernel-less Queries

SpiceQL has some general NAIF SPICE Information built-in.  The following commands can sometimes succeed without furnishing a kernel (though a kernel may be required for Names, Codes, or Frame Info for specific missions):

- utcToEt / etToUtc
- translateNameToCode / translateCodeToName
- getFrameInfo / getTargetFrameInfo

???+ example "Ephemeris Time Conversion (Basic, No Kernels)"

    For the most basic usage, run a UTC to ET conversion.  This conversion is built-in; there is no need to load a Lead-Second Kernel.

    === "Local (Node)"

        ```js title="spiceql-mini-example.js"

        import { loadSpiceQL } from './spiceql.js';
        const spiceql = await loadSpiceQL();
        const { result: ephTime } = spiceql.utcToEt('2000-01-01T00:00:00', { searchKernels: false });
        console.info("ET", ephTime);   // ET seconds past J2000
        ```

        To run this example in your terminal:

        ```sh
        node spiceql-mini-example.js
        ```

    === "Online (jsFiddle)"

        <script async src="//jsfiddle.net/jrcain_usgs/o08svbyq/embed/result,js,html,css/dark/"></script>

??? example "Translate Name to Code"

    ```js title="spiceql-name-to-code.js"
    import { loadSpiceQL } from 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/spiceql.js';
    const spiceql = await loadSpiceQL();

    const { result: frameCode } = spiceql.translateNameToCode('MRO', {
        mission: 'ctx',
        searchKernels: false
    });

    console.info("Result", frameCode);
    ```

### Queries that Require Kernels

Queries that deal with Target States/Orientations, Frame Trace, Sclk Conversions, and Keywords require a kernel to succeed.

???+ note "Loading Kernels"

    For queries that require kernels, they must be loaded in to the file system:

    === "Local Kernels"

        This works for local files without a server, i.e. when running a script with `node yourscript.js`.

        ```js
        import { readFileSync } from 'node:fs';
        spiceql.mountKernel('/kernels/mro_v16.tf', readFileSync('mro_v16.tf'));
        ```

    === "Online Kernels"

        `fetch` can retrieve files from a server, i.e. local files you are serving with `npm run dev`, or 3rd-party hosted files (as long the 3rd-party allows cross-origin requests).

        ```js
        const mro_v16_file = await fetch('https://asc-isisdata.s3.us-west-2.amazonaws.com/usgs_data/mro/kernels/fk/mro_v16.tf');
        const mro_v16_buffer = new Uint8Array(await mro_v16_file.arrayBuffer())
        spiceql.mountKernel('/kernels/mro_v16.tf', mro_v16_buffer);
        ```

???+ example "Translate Spacecraft Time & Loading Kernels"

    === "Local (Node)"

        For this example, the five files in the SpiceQL Wasm package (.js, .data, and .wasm files)
        are in a directory at the same level as the example script. 
        The kernels are in a data subdirectory (with the same folder structure as ISISDATA).

        ```sh title="File Tree"
        project/
        ├── data/
        │   ├── base/...
        │   └── lro/...
        ├── translate-spacecraft-time-local.js
        ├── naifspice.js
        ├── spiceql.js
        ├── spiceql_wasm.data
        ├── spiceql_wasm.js
        └── spiceql_wasm.wasm
        ```

        ```js title="translate-spacecraft-time-local.js"
        // Import and Load SpiceQL
        import { readFileSync } from 'node:fs';
        import { loadSpiceQL } from './spiceql.js';
        const spiceql = await loadSpiceQL();

        // Initial Data
        console.log("---");
        console.log("Initial Data:");
        const frameCode = -85;
        const sclkTime = 922997380.174174;
        console.info("It is Sclk Time", sclkTime);
        console.info("At Frame Code", frameCode);
        console.log("---");

        // SpiceQL can get common code/name translations without kernels
        const { result: frameName } = spiceql.translateCodeToName(frameCode, {
            mission: 'lro',
            searchKernels: false,
        });
        console.info("Frame Code " + frameCode + " is the", frameName);
        console.log("---");

        // Mount Kernels
        const kernelList = [];
        const kernelUrls = [
            './data/base/kernels/lsk/naif0012.tls',
            './data/lro/kernels/iak/lro_instrumentAddendum_v05.ti',
            './data/lro/kernels/fk/lro_frames_2014049_v01.tf',
            './data/lro/kernels/sclk/lro_clkcor_2024262_v00.tsc',
        ]
        for (const url of kernelUrls) {
            const kernelPath = '/kernels/' + url.split('/').pop();    // Get filename, discard path
            spiceql.mountKernel(kernelPath, readFileSync(url));       // Mount as sanitized path
            kernelList.push(kernelPath)                               // Add sanitized path to list
        }

        // Convert Spacecraft Clock Time (sclk) to Ephemeris Time (et)
        const { result: ephTime } = spiceql.doubleSclkToEt(frameCode, sclkTime, {
            mission: 'lro',
            searchKernels: false,
            kernelList,
        });
        console.log("Sclk time " + sclkTime + " on the " + frameName + " is");
        console.log("Ephemeris Time", ephTime);
        console.log("---");

        // Get UTC from ET
        const { result: utcTime } = spiceql.etToUtc(ephTime, {
            searchKernels: false
        });

        console.log("Sclk time " + sclkTime + " on the " + frameName + " is");
        console.log("Earth UTC", utcTime);
        ```


        
        ```sh title="Run in your terminal"
        node translate-spacecraft-time-local.js
        ```

        ```sh title="Output"
        ---
        Initial Data:
        It is Sclk Time 922997380.174174
        At Frame Code -85
        ---
        Frame Code -85 is the LUNAR RECONNAISSANCE ORBITER
        ---
        Sclk time 922997380.174174 on the LUNAR RECONNAISSANCE ORBITER is
        Ephemeris Time 31593348.006268278
        ---
        Sclk time 922997380.174174 on the LUNAR RECONNAISSANCE ORBITER is
        Earth UTC 2001-01-01T03:54:44
        ```
    
    === "NPM + Vite"

        For this example, follow the [NPM installation instructions](#__tabbed_1_1) above. 

        Place the required kernels in the public/data folder, with a scheme
        matching ISISDATA. (See the kernelUrls in the example.)

        Place the JS code in `src/main.js`.

        ```sh title="File Tree"
        project/
        ├── node_modules/
        ├── public/
        │   └── data
        │       ├── base/...
        │       └── lro/...
        ├── src/
        │   ├── main.js
        │   └── style.css
        ├── index.html
        └── package.json
        ```

        === "src/main.js"

            ```js
            import { loadSpiceQL } from '@usgs-astrogeology/spiceql';
            const spiceql = await loadSpiceQL();

            // Mount Kernels
            const kernelList = [];
            const kernelUrls = [
                'data/base/kernels/lsk/naif0012.tls',
                'data/lro/kernels/iak/lro_instrumentAddendum_v05.ti',
                'data/lro/kernels/fk/lro_frames_2014049_v01.tf',
                'data/lro/kernels/sclk/lro_clkcor_2024262_v00.tsc',
            ]
            for (const url of kernelUrls) {
                const kernelData = await fetch(url);                              // Fetch
                const kernelBuff = new Uint8Array(await kernelData.arrayBuffer()) // Load into Buffer
                const kernelPath = '/kernels/' + url.split('/').pop();            // Get filename, discard path
                spiceql.mountKernel(kernelPath, kernelBuff);                      // Mount as sanitized path
                kernelList.push(kernelPath)                                       // Add sanitized path to list
            }

            const convertTime = () => {
                // Read Initial Data
                const frameCode = document.getElementById("frame-code").value;
                const sclkTime = document.getElementById("sclk-time").value;

                // Get Frame Name from Code
                const { result: frameName } = spiceql.translateCodeToName(frameCode, {
                    mission: 'lro',
                    searchKernels: false,
                    kernelList,
                });
                document.getElementById("frame-name").innerHTML = "Frame Name: " + frameName;

                // Convert Spacecraft Clock Time (sclk) to Ephemeris Time (et)
                const { result: ephTime } = spiceql.doubleSclkToEt(frameCode, sclkTime, {
                    mission: 'lro',
                    searchKernels: false,
                    kernelList,
                });
                document.getElementById("eph-time").innerHTML = "Ephemeris Time: " + ephTime;

                // Get UTC from ET
                const { result: utcTime } = spiceql.etToUtc(ephTime, {
                    searchKernels: false
                });
                document.getElementById("utc-time").innerHTML = "UTC Time: " + utcTime;
            }

            document.getElementById('convert').addEventListener('click', convertTime);
            ```

        === "index.html"

            ```html
            <!doctype html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8" />
                    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>spql-wasm</title>
                </head>
                <body>
                    <div id="outer">
                        <div>
                        Input
                        <hr/>
                        <label for="frame-code">
                            Frame Code
                        </label>
                        <br/>
                        <input id="frame-code" disabled="true" value="-85"></input>
                        <br/>
                        <br/>
                        <label for="sclk-time">
                            Spacecraft Clock (SCLK)
                        </label>
                        <br/>
                        <input id="sclk-time" type="datetime" value="922997380.174174"></input>
                        <br/>
                        <br/>
                        <button id="convert">Convert Time →</button>
                        </div>
                        <div id="result">
                        Output
                        <hr/>
                        <p id="frame-name">Frame Name: </p>
                        <p id="eph-time">Ephemeris Time: </p>
                        <p id="utc-time">UTC Time: </p>
                        </div>
                    </div>
                    <script type="module" src="/src/main.js"></script>
                </body>
            </html>
            ```
        === "src/style.css"

            ```css
            body {
                font-family: sans-serif;
                background-color: rgb(30, 33, 31);
            }

            #outer {
                display: flex;
                flex-direction: row;
                margin-bottom: 50px;
            }

            #outer > div {
                background-color: rgb(68, 80, 175);
                color: white;
                margin: 5px;
                padding: 10px;
                align-content: center;
                border-radius: 5px;
            }
            ```

    === "Online"
        
        ```js title="translate-spacecraft-time-online.js"
        // Import and Load SpiceQL
        import { loadSpiceQL } from 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/spiceql.js';

        const CDN = 'https://cdn.jsdelivr.net/npm/@usgs-astrogeology/spiceql/dist/';
        const spiceql = await loadSpiceQL({
            moduleOverrides: { locateFile: (path) => CDN + path }
        });

        // Mount Kernels
        const kernelList = [];
        const kernelUrls = [
            'https://asc-isisdata.s3.us-west-2.amazonaws.com/usgs_data/base/kernels/lsk/naif0012.tls',
            'https://asc-isisdata.s3.us-west-2.amazonaws.com/usgs_data/lro/kernels/iak/lro_instrumentAddendum_v05.ti',
            'https://asc-isisdata.s3.us-west-2.amazonaws.com/usgs_data/lro/kernels/fk/lro_frames_2014049_v01.tf',
            'https://asc-isisdata.s3.us-west-2.amazonaws.com/usgs_data/lro/kernels/sclk/lro_clkcor_2024262_v00.tsc',
        ]
        for (const url of kernelUrls) {
            const kernelData = await fetch(url);                              // Fetch
            const kernelBuff = new Uint8Array(await kernelData.arrayBuffer()) // Load into Buffer
            const kernelPath = '/kernels/' + url.split('/').pop();            // Get filename, discard path
            spiceql.mountKernel(kernelPath, kernelBuff);                      // Mount as sanitized path
            kernelList.push(kernelPath)                                       // Add sanitized path to list
        }

        const convertTime = () => {
            // Read Initial Data
            const frameCode = document.getElementById("frame-code").value;
            const sclkTime = document.getElementById("sclk-time").value;
        
            // Get Frame Name from Code
            const { result: frameName } = spiceql.translateCodeToName(frameCode, {});
            document.getElementById("frame-name").innerHTML = "Frame Name: " + frameName;

            // Convert Spacecraft Clock Time (sclk) to Ephemeris Time (et)
            const { result: ephTime } = spiceql.doubleSclkToEt(frameCode, sclkTime, {
                mission: 'lro',
                searchKernels: false,
                kernelList,
            });
            document.getElementById("eph-time").innerHTML = "Ephemeris Time: " + ephTime;

            // Get UTC from ET
            const { result: utcTime } = spiceql.etToUtc(ephTime, {
                searchKernels: false
            });
            document.getElementById("utc-time").innerHTML = "UTC Time: " + utcTime;
        }

        document.getElementById('convert').addEventListener('click', convertTime);

        ```

    === "Try It"

        <p class="codepen" data-height="500" data-pen-title="SpiceQL Wasm Time Conversions" data-version="2" data-default-tab="result" data-slug-hash="azJzevz" data-user="Jacob-Cain" style="height: 475px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
        <span>See the Pen <a href="https://codepen.io/editor/Jacob-Cain/pen/01a045c7-a04a-774f-a94a-8f2517204599">
        SpiceQL Wasm Time Conversions</a> by Jacob Cain (<a href="https://codepen.io/Jacob-Cain">@Jacob-Cain</a>)
        on <a href="https://codepen.io">CodePen</a>.</span>
        </p>
        <script async src="https://public.codepenassets.com/embed/index.js"></script>

        

