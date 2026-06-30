# Using USGSCSM WASM Bindings

USGSCSM provides WebAssembly (WASM) bindings that allow you to use Community Sensor Model (CSM)-compliant sensor models directly in JavaScript/TypeScript environments, including web browsers and Node.js applications.

## Overview

The WASM bindings enable you to:

- Use USGSCSM sensor models in web applications
- Perform camera model operations in JavaScript/TypeScript
- Access framing camera, line scan camera, and SAR sensor models
- Load and process Image Support Data (ISD) files
- Convert between image and ground coordinates

!!! tip "Try the Interactive Demo"
    Want to see USGSCSM WASM in action? Check out our [interactive browser-based demo](/docs/how-to-guides/demos/usgscsm-wasm-demo/) that demonstrates all the core functionality. The demo includes the WASM files and works out of the box!

## Installation

USGSCSM WASM bindings are distributed via [GitHub Releases](https://github.com/DOI-USGS/usgscsm/releases).

Each release includes three files:

1. **`usgscsm.wasm`** - The WebAssembly binary (~942 KB)
2. **`usgscsm.js`** - JavaScript wrapper/loader (~124 KB)
3. **`usgscsm.d.ts`** - TypeScript type definitions (~9.69 KB)

**Latest Release:** [USGSCSM 2.1.0](https://github.com/DOI-USGS/usgscsm/releases/tag/2.1.0)

### Download and Include in Your Project

Download the files from the release page and include them in your project:

- [usgscsm.wasm](https://github.com/DOI-USGS/usgscsm/releases/download/2.1.0/usgscsm.wasm)
- [usgscsm.js](https://github.com/DOI-USGS/usgscsm/releases/download/2.1.0/usgscsm.js)
- [usgscsm.d.ts](https://github.com/DOI-USGS/usgscsm/releases/download/2.1.0/usgscsm.d.ts)

Place the files in your project directory and reference them locally:

```html
<script src="./usgscsm.js"></script>
```

!!! warning "Cannot Load Directly from GitHub"
    GitHub serves release assets with headers that prevent direct script execution in browsers. You must download the files and serve them from your own web server or local project.

## Basic Usage

### In Browser

The simplest way to use USGSCSM WASM is to load it directly in your HTML:

```html
<!DOCTYPE html>
<html>
<head>
  <title>USGSCSM WASM Example</title>
  <script src="usgscsm.js"></script>
</head>
<body>
  <script>
    usgscsm().then(Module => {
      console.log('USGSCSM ready');
      // Your code here
    });
  </script>
</body>
</html>
```

### With Module Bundlers (Webpack, Vite, etc.)

If you're using a module bundler, you can import the files directly:

```javascript
// Make sure usgscsm.js and usgscsm.wasm are in your project
import usgscsm from './path/to/usgscsm.js';

usgscsm().then(Module => {
  // WASM module loaded and ready
});
```

For TypeScript projects, include `usgscsm.d.ts` in your project for type definitions.

## Complete Example

Here's a complete example showing how to load a model and perform coordinate conversions:

```javascript
// Load the USGSCSM WASM module
usgscsm().then(async Module => {
  // Create a new camera model
  const model = new Module.USGSCSMModel();
  
  // Load from ISD JSON (fetch from file or API)
  const isdJson = await fetch('path/to/your/model.json').then(r => r.text());
  const loaded = model.loadFromISD(isdJson, 'USGS_ASTRO_FRAME_SENSOR_MODEL');
  
  if (!loaded) {
    console.error('Failed to load model');
    return;
  }
  
  // Convert image coordinates to ground
  const ground = model.imageToGround(512, 512, 0);
  if (ground) {
    console.log('ECEF coordinates:', ground);
    // Output: { x: ..., y: ..., z: ... }
  }
  
  // Convert ground coordinates back to image
  const image = model.groundToImage(ground.x, ground.y, ground.z);
  if (image) {
    console.log('Image coordinates:', image);
    // Output: { line: 512, sample: 512 }
  }
  
  // Get sensor position
  const position = model.getSensorPosition(512, 512);
  console.log('Camera position:', position);
  
  // Export model state for faster loading next time
  const state = model.getModelState();
  localStorage.setItem('cameraModel', state);
  
  // Later, load from saved state (much faster than ISD)
  const newModel = new Module.USGSCSMModel();
  newModel.loadFromState(state);
}).catch(console.error);
```

## Sensor Model Types

USGSCSM provides three CSM-compliant sensor models through the WASM bindings:

1. **USGS_ASTRO_FRAME_SENSOR_MODEL** - Generic framing camera model
2. **USGS_ASTRO_LINE_SCANNER_SENSOR_MODEL** - Generic line scan camera model
3. **USGS_ASTRO_SAR_SENSOR_MODEL** - Generic synthetic-aperture radar (SAR) model

## Working with Image Support Data (ISD)

USGSCSM uses JSON-formatted Image Support Data (ISD) files to define camera models. ISD files can be generated using:

- [ALE (Abstraction Library for Ephemerides)](https://github.com/DOI-USGS/ale) with SPICE kernels
- ISIS cubes with attached SPICE data

The ISD format is converted internally to an optimized model state for efficient camera operations.

!!! warning "Known Issue in USGSCSM v2.1"
    USGSCSM v2.1 requires an `image_identifier` field in the ISD, even though standard ISDs from ALE don't include this field. This is a known issue - the C++ plugin automatically adds this field, but the WASM bindings bypass that step.
    
    **Workaround:** Add `image_identifier` to your ISD before loading:
    ```javascript
    const isd = JSON.parse(isdJson);
    isd.image_identifier = "my_image_name";
    model.loadFromISD(JSON.stringify(isd), modelType);
    ```
    
    This will be fixed in a future version to match the plugin behavior.

### Example ISD Structure

A typical ISD JSON file includes:

```json
{
  "radii": {
    "semimajor": 3396190.0,
    "semiminor": 3376200.0
  },
  "sensor_position": {
    "positions": [[3000000, 0, 2000000]],
    "velocities": [[0, 3000, 0]],
    "unit": "m"
  },
  "image_lines": 1024,
  "image_samples": 1024,
  "focal_length": 350.0,
  "detector_center": {
    "line": 512,
    "sample": 512
  }
}
```

For complete, valid ISD examples, use ALE to generate them from real mission data.

## File Requirements

When using USGSCSM WASM bindings:

1. Keep `usgscsm.js` and `usgscsm.wasm` in the same directory
2. The JavaScript file will automatically load the WASM file from the same directory
3. For TypeScript projects, include `usgscsm.d.ts` for type definitions

!!! note "File Paths"
    The `usgscsm.js` file expects `usgscsm.wasm` to be in the same directory by default. If you need to load the WASM file from a different location, you may need to configure the path in your bundler or build system.

## Additional Resources

- [USGSCSM GitHub Repository](https://github.com/DOI-USGS/usgscsm)
- [USGSCSM Releases](https://github.com/DOI-USGS/usgscsm/releases) - Download WASM bindings
- [ALE (for generating ISD files)](https://github.com/DOI-USGS/ale)

## Support

For issues, questions, or contributions related to USGSCSM WASM bindings:

- Open an issue on the [USGSCSM GitHub repository](https://github.com/DOI-USGS/usgscsm/issues)

## Version Information

WASM support was introduced in USGSCSM version 2.1.0 (released June 2026).

Check the [releases page](https://github.com/DOI-USGS/usgscsm/releases) for the latest version and release notes.
