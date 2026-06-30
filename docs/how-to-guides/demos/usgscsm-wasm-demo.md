# USGSCSM WASM Interactive Demo

This page provides an interactive demonstration of the USGSCSM WebAssembly bindings running directly in your browser.

<style>
    .demo-container {
        background: white;
        padding: 25px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        margin-bottom: 20px;
    }

    .demo-section {
        margin-bottom: 25px;
    }

    .demo-section h3 {
        color: #34495e;
        margin-top: 0;
        font-size: 1.3em;
    }

    .demo-container label {
        display: block;
        margin-bottom: 5px;
        font-weight: 600;
        color: #555;
    }

    .demo-container input[type="number"], 
    .demo-container input[type="text"], 
    .demo-container textarea, 
    .demo-container select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
        box-sizing: border-box;
    }

    .demo-container textarea {
        min-height: 150px;
        font-family: 'Courier New', monospace;
        font-size: 12px;
    }

    .demo-button {
        background-color: #3498db;
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        margin-right: 10px;
        margin-top: 10px;
        transition: background-color 0.3s;
    }

    .demo-button:hover {
        background-color: #2980b9;
    }

    .demo-button:disabled {
        background-color: #bdc3c7;
        cursor: not-allowed;
    }

    .demo-output {
        background-color: #ecf0f1;
        padding: 15px;
        border-radius: 4px;
        border-left: 4px solid #3498db;
        margin-top: 15px;
        white-space: pre-wrap;
        font-family: 'Courier New', monospace;
        font-size: 13px;
    }

    .demo-status {
        padding: 10px;
        border-radius: 4px;
        margin-bottom: 15px;
    }

    .demo-status.loading {
        background-color: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
    }

    .demo-status.success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .demo-status.error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .demo-input-group {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 10px;
        margin-bottom: 15px;
    }

    .demo-example-link {
        color: #3498db;
        text-decoration: none;
        font-size: 0.9em;
        margin-top: 5px;
        display: inline-block;
    }

    .demo-example-link:hover {
        text-decoration: underline;
    }
</style>

## Live Demo

<div class="demo-container">
    <div class="demo-section">
        <h3>1. Load Camera Model</h3>
        <p style="margin-bottom: 15px; color: #555;">Load a camera model from ISD (Image Support Data). The model type is automatically determined from the ISD.</p>
        
        <div class="demo-status loading" style="margin-bottom: 15px;">
            <strong>⚠️ Known Issue in USGSCSM v2.1:</strong> Your ISD must include an <code>image_identifier</code> field. Standard ISDs from ALE don't have this - add it manually as a workaround. This will be fixed in a future version.
        </div>
        
        <label for="isdJson">ISD JSON Data:</label>
        <textarea id="isdJson" placeholder='Paste your ISD JSON here or click "Load Example Model" below'></textarea>
        <a href="https://github.com/DOI-USGS/ale" class="demo-example-link" target="_blank" style="margin-top: 10px; display: inline-block;">
            ℹ️ Generate ISD files using ALE
        </a>

        <button onclick="loadExampleModel()" id="exampleBtn" class="demo-button" disabled>Load Example ISD</button>
        <button onclick="loadModel()" id="loadBtn" class="demo-button" disabled>Load Model from ISD</button>
        <div id="loadStatus" class="demo-status" style="display: none; margin-top: 15px;"></div>
    </div>
</div>

<div class="demo-container">
    <div class="demo-section">
        <h3>2. Image to Ground Conversion</h3>
        <div class="demo-input-group">
            <div>
                <label for="imgLine">Line (row):</label>
                <input type="number" id="imgLine" value="512" step="0.5">
            </div>
            <div>
                <label for="imgSample">Sample (column):</label>
                <input type="number" id="imgSample" value="512" step="0.5">
            </div>
            <div>
                <label for="height">Height (meters):</label>
                <input type="number" id="height" value="0" step="100">
            </div>
        </div>
        <button onclick="imageToGround()" disabled id="i2gBtn" class="demo-button">Convert to Ground</button>
        <div id="i2gOutput" class="demo-output" style="display: none;"></div>
    </div>
</div>

<div class="demo-container">
    <div class="demo-section">
        <h3>3. Ground to Image Conversion</h3>
        <div class="demo-input-group">
            <div>
                <label for="ecefX">Body-Fixed X (meters):</label>
                <input type="number" id="ecefX" value="3396190" step="1000">
            </div>
            <div>
                <label for="ecefY">Body-Fixed Y (meters):</label>
                <input type="number" id="ecefY" value="0" step="1000">
            </div>
            <div>
                <label for="ecefZ">Body-Fixed Z (meters):</label>
                <input type="number" id="ecefZ" value="0" step="1000">
            </div>
        </div>
        <button onclick="groundToImage()" disabled id="g2iBtn" class="demo-button">Convert to Image</button>
        <div id="g2iOutput" class="demo-output" style="display: none;"></div>
    </div>
</div>

<div class="demo-container">
    <div class="demo-section">
        <h3>4. Sensor Position & Velocity</h3>
        <div class="demo-input-group">
            <div>
                <label for="sensorLine">Line:</label>
                <input type="number" id="sensorLine" value="512" step="0.5">
            </div>
            <div>
                <label for="sensorSample">Sample:</label>
                <input type="number" id="sensorSample" value="512" step="0.5">
            </div>
            <div></div>
        </div>
        <button onclick="getSensorInfo()" disabled id="sensorBtn" class="demo-button">Get Sensor Info</button>
        <div id="sensorOutput" class="demo-output" style="display: none;"></div>
    </div>
</div>

<div class="demo-container">
    <div class="demo-section">
        <h3>5. Model Metadata & Illumination</h3>
        <button onclick="getMetadata()" disabled id="metadataBtn" class="demo-button">Get Model Info</button>
        <div id="metadataOutput" class="demo-output" style="display: none;"></div>
        
        <div style="margin-top: 20px;">
            <label>Get Sun Direction at Ground Point:</label>
            <div class="demo-input-group" style="margin-top: 10px;">
                <div>
                    <label for="illumX">Body-Fixed X (meters):</label>
                    <input type="number" id="illumX" value="-1456616" step="1000">
                </div>
                <div>
                    <label for="illumY">Body-Fixed Y (meters):</label>
                    <input type="number" id="illumY" value="-136023" step="1000">
                </div>
                <div>
                    <label for="illumZ">Body-Fixed Z (meters):</label>
                    <input type="number" id="illumZ" value="-552284" step="1000">
                </div>
            </div>
            <button onclick="getIllumination()" disabled id="illumBtn" class="demo-button">Get Illumination Direction</button>
            <div id="illumOutput" class="demo-output" style="display: none;"></div>
        </div>
    </div>
</div>

<div class="demo-container">
    <div class="demo-section">
        <h3>6. Export Model State</h3>
        <p style="margin-bottom: 15px; color: #555;">View the optimized model state representation (useful for debugging or saving).</p>
        <button onclick="getModelState()" disabled id="stateBtn" class="demo-button">Export Model State</button>
        <div id="stateOutput" class="demo-output" style="display: none;"></div>
    </div>
</div>


<script type="module">
    import USGSCSM from '/docs/how-to-guides/demos/usgscsm.js';
    
    let Module = null;
    let cameraModel = null;

    window.updateStatus = function(type, message, elementId = 'globalStatus') {
        const statusEl = document.getElementById(elementId);
        if (statusEl) {
            statusEl.className = 'demo-status ' + type;
            statusEl.textContent = message;
            statusEl.style.display = 'block';
        }
    }

    window.enableModelButtons = function(enabled) {
        document.getElementById('i2gBtn').disabled = !enabled;
        document.getElementById('g2iBtn').disabled = !enabled;
        document.getElementById('sensorBtn').disabled = !enabled;
        document.getElementById('metadataBtn').disabled = !enabled;
        document.getElementById('illumBtn').disabled = !enabled;
        document.getElementById('stateBtn').disabled = !enabled;
    }

    window.loadModel = function() {
        try {
            const isdJson = document.getElementById('isdJson').value.trim();

            if (!isdJson) {
                window.updateStatus('error', 'Please provide ISD JSON data', 'loadStatus');
                return;
            }
            if (!Module) {
                window.updateStatus('error', 'WASM module not loaded. Please wait for initialization.', 'loadStatus');
                return;
            }

            const isdObj = JSON.parse(isdJson);
            
            if (!isdObj.name_model) {
                window.updateStatus('error', 'ISD is missing required field: name_model', 'loadStatus');
                return;
            }

            const modelType = isdObj.name_model;

            cameraModel = new Module.USGSCSMModel();

            const success = cameraModel.loadFromISD(isdJson, modelType);

            if (success) {
                window.updateStatus('success', `Camera model loaded successfully! Model type: ${modelType}`, 'loadStatus');
                window.enableModelButtons(true);
            } else {
                window.updateStatus('error', 'Failed to load camera model from ISD. Check console for details.', 'loadStatus');
                cameraModel = null;
                window.enableModelButtons(false);
            }
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            window.updateStatus('error', 'Error loading model: ' + errorMsg, 'loadStatus');
            window.enableModelButtons(false);
        }
    }

    window.loadExampleModel = function() {
        fetch('/docs/how-to-guides/demos/example-frame-camera.isd')
            .then(response => response.json())
            .then(exampleISD => {
                document.getElementById('isdJson').value = JSON.stringify(exampleISD, null, 2);
                window.updateStatus('success', 'Example ISD loaded! This is a Voyager 2 Narrow Angle Camera image of Europa. Click "Load Model from ISD" to use it.', 'loadStatus');
            })
            .catch(err => {
                window.updateStatus('error', 'Failed to load example ISD file.', 'loadStatus');
            });
    }

    window.imageToGround = function() {
        if (!cameraModel) {
            document.getElementById('i2gOutput').textContent = 'Error: No camera model loaded. Please load a model first.';
            document.getElementById('i2gOutput').style.display = 'block';
            return;
        }

        try {
            const line = parseFloat(document.getElementById('imgLine').value);
            const sample = parseFloat(document.getElementById('imgSample').value);
            const height = parseFloat(document.getElementById('height').value);

            const ground = cameraModel.imageToGround(line, sample, height);

            if (ground) {
                const x = Array.isArray(ground) ? ground[0] : ground.x;
                const y = Array.isArray(ground) ? ground[1] : ground.y;
                const z = Array.isArray(ground) ? ground[2] : ground.z;
                
                if (x !== undefined && y !== undefined && z !== undefined) {
                    const output = `Image Coordinates: (${line}, ${sample})
Height: ${height} m

Body-Fixed Ground Coordinates:
  X: ${x.toFixed(3)} m
  Y: ${y.toFixed(3)} m
  Z: ${z.toFixed(3)} m`;

                    document.getElementById('i2gOutput').textContent = output;
                    document.getElementById('i2gOutput').style.display = 'block';

                    document.getElementById('ecefX').value = x.toFixed(3);
                    document.getElementById('ecefY').value = y.toFixed(3);
                    document.getElementById('ecefZ').value = z.toFixed(3);
                } else {
                    document.getElementById('i2gOutput').textContent = 'Error: Failed to convert image to ground coordinates';
                    document.getElementById('i2gOutput').style.display = 'block';
                }
            } else {
                document.getElementById('i2gOutput').textContent = 'Error: Failed to convert image to ground coordinates';
                document.getElementById('i2gOutput').style.display = 'block';
            }
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            document.getElementById('i2gOutput').textContent = 'Error: ' + errorMsg;
            document.getElementById('i2gOutput').style.display = 'block';
        }
    }

    window.groundToImage = function() {
        if (!cameraModel) {
            document.getElementById('g2iOutput').textContent = 'Error: No camera model loaded. Please load a model first.';
            document.getElementById('g2iOutput').style.display = 'block';
            return;
        }

        try {
            const x = parseFloat(document.getElementById('ecefX').value);
            const y = parseFloat(document.getElementById('ecefY').value);
            const z = parseFloat(document.getElementById('ecefZ').value);

            const image = cameraModel.groundToImage(x, y, z);

            if (image) {
                const line = Array.isArray(image) ? image[0] : image.line;
                const sample = Array.isArray(image) ? image[1] : (image.sample || image.samp);
                
                if (line !== undefined && sample !== undefined) {
                    const output = `Body-Fixed Coordinates: (${x.toFixed(3)}, ${y.toFixed(3)}, ${z.toFixed(3)})

Image Pixel Coordinates:
  Line: ${line.toFixed(3)}
  Sample: ${sample.toFixed(3)}`;

                    document.getElementById('g2iOutput').textContent = output;
                    document.getElementById('g2iOutput').style.display = 'block';
                } else {
                    const output = 'Ground point is not visible in the image or conversion failed.';
                    document.getElementById('g2iOutput').textContent = output;
                    document.getElementById('g2iOutput').style.display = 'block';
                }
            } else {
                const output = 'Ground point is not visible in the image or conversion failed.';
                document.getElementById('g2iOutput').textContent = output;
                document.getElementById('g2iOutput').style.display = 'block';
            }
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            document.getElementById('g2iOutput').textContent = 'Error: ' + errorMsg;
            document.getElementById('g2iOutput').style.display = 'block';
        }
    }

    window.getSensorInfo = function() {
        if (!cameraModel) {
            document.getElementById('sensorOutput').textContent = 'Error: No camera model loaded. Please load a model first.';
            document.getElementById('sensorOutput').style.display = 'block';
            return;
        }

        try {
            const line = parseFloat(document.getElementById('sensorLine').value);
            const sample = parseFloat(document.getElementById('sensorSample').value);

            const position = cameraModel.getSensorPosition(line, sample);
            const velocity = cameraModel.getSensorVelocity(line, sample);

            let output = `Sensor information at pixel (${line}, ${sample}):

`;

            if (position) {
                const px = Array.isArray(position) ? position[0] : position.x;
                const py = Array.isArray(position) ? position[1] : position.y;
                const pz = Array.isArray(position) ? position[2] : position.z;
                
                if (px !== undefined && py !== undefined && pz !== undefined) {
                    output += `Position (Body-Fixed):
  X: ${px.toFixed(3)} m
  Y: ${py.toFixed(3)} m
  Z: ${pz.toFixed(3)} m

`;
                } else {
                    output += 'Position: Not available\n\n';
                }
            } else {
                output += 'Position: Not available\n\n';
            }

            if (velocity) {
                const vx = Array.isArray(velocity) ? velocity[0] : velocity.x;
                const vy = Array.isArray(velocity) ? velocity[1] : velocity.y;
                const vz = Array.isArray(velocity) ? velocity[2] : velocity.z;
                
                if (vx !== undefined && vy !== undefined && vz !== undefined) {
                    output += `Velocity (Body-Fixed):
  X: ${vx.toFixed(6)} m/s
  Y: ${vy.toFixed(6)} m/s
  Z: ${vz.toFixed(6)} m/s`;
                } else {
                    output += 'Velocity: Not available';
                }
            } else {
                output += 'Velocity: Not available';
            }

            document.getElementById('sensorOutput').textContent = output;
            document.getElementById('sensorOutput').style.display = 'block';
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            document.getElementById('sensorOutput').textContent = 'Error: ' + errorMsg;
            document.getElementById('sensorOutput').style.display = 'block';
        }
    }

    window.getMetadata = function() {
        if (!cameraModel) {
            document.getElementById('metadataOutput').textContent = 'Error: No camera model loaded. Please load a model first.';
            document.getElementById('metadataOutput').style.display = 'block';
            return;
        }

        try {
            const modelName = cameraModel.getModelName();
            const imageId = cameraModel.getImageIdentifier();
            const sensorId = cameraModel.getSensorIdentifier();
            const platformId = cameraModel.getPlatformIdentifier();
            const imageSize = cameraModel.getImageSize();
            const imageStart = cameraModel.getImageStart();
            const isLoaded = cameraModel.isLoaded();

            let output = `Model Information:

Model Type: ${modelName || 'N/A'}
Image ID: ${imageId || 'N/A'}
Sensor: ${sensorId || 'N/A'}
Platform: ${platformId || 'N/A'}
Model Loaded: ${isLoaded ? 'Yes' : 'No'}

`;

            if (imageSize) {
                const lines = imageSize.lines !== undefined ? imageSize.lines : (Array.isArray(imageSize) ? imageSize[0] : 'N/A');
                const samples = imageSize.samples !== undefined ? imageSize.samples : (Array.isArray(imageSize) ? imageSize[1] : 'N/A');
                output += `Image Size: ${lines} lines × ${samples} samples\n`;
            } else {
                output += 'Image Size: N/A\n';
            }

            if (imageStart) {
                const startLine = imageStart.line !== undefined ? imageStart.line : (Array.isArray(imageStart) ? imageStart[0] : 'N/A');
                const startSamp = imageStart.sample !== undefined ? imageStart.sample : (imageStart.samp || (Array.isArray(imageStart) ? imageStart[1] : 'N/A'));
                output += `Image Start: (${startLine}, ${startSamp})`;
            } else {
                output += 'Image Start: N/A';
            }

            document.getElementById('metadataOutput').textContent = output;
            document.getElementById('metadataOutput').style.display = 'block';
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            document.getElementById('metadataOutput').textContent = 'Error: ' + errorMsg;
            document.getElementById('metadataOutput').style.display = 'block';
        }
    }

    window.getIllumination = function() {
        if (!cameraModel) {
            document.getElementById('illumOutput').textContent = 'Error: No camera model loaded. Please load a model first.';
            document.getElementById('illumOutput').style.display = 'block';
            return;
        }

        try {
            const x = parseFloat(document.getElementById('illumX').value);
            const y = parseFloat(document.getElementById('illumY').value);
            const z = parseFloat(document.getElementById('illumZ').value);

            const sunVec = cameraModel.getIlluminationDirection(x, y, z);

            if (sunVec) {
                const sx = Array.isArray(sunVec) ? sunVec[0] : sunVec.x;
                const sy = Array.isArray(sunVec) ? sunVec[1] : sunVec.y;
                const sz = Array.isArray(sunVec) ? sunVec[2] : sunVec.z;

                if (sx !== undefined && sy !== undefined && sz !== undefined) {
                    const magnitude = Math.sqrt(sx*sx + sy*sy + sz*sz);

                    const output = `Ground Point: (${x.toFixed(3)}, ${y.toFixed(3)}, ${z.toFixed(3)})

Sun Direction (unit vector):
  X: ${sx.toFixed(6)}
  Y: ${sy.toFixed(6)}
  Z: ${sz.toFixed(6)}
  Magnitude: ${magnitude.toFixed(6)} (should be ~1.0)

This vector points from the ground point toward the sun.
Use for illumination angle, shadow, or photometric calculations.`;

                    document.getElementById('illumOutput').textContent = output;
                    document.getElementById('illumOutput').style.display = 'block';
                } else {
                    document.getElementById('illumOutput').textContent = 'Error: Could not retrieve illumination direction.';
                    document.getElementById('illumOutput').style.display = 'block';
                }
            } else {
                document.getElementById('illumOutput').textContent = 'Illumination direction not available for this point.';
                document.getElementById('illumOutput').style.display = 'block';
            }
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            document.getElementById('illumOutput').textContent = 'Error: ' + errorMsg;
            document.getElementById('illumOutput').style.display = 'block';
        }
    }

    window.getModelState = function() {
        if (!cameraModel) {
            document.getElementById('stateOutput').textContent = 'Error: No camera model loaded. Please load a model first.';
            document.getElementById('stateOutput').style.display = 'block';
            return;
        }

        try {
            const state = cameraModel.getModelState();

            if (state) {
                let formatted;
                if (typeof state === 'string') {
                    try {
                        formatted = JSON.stringify(JSON.parse(state), null, 2);
                    } catch {
                        formatted = state;
                    }
                } else {
                    formatted = JSON.stringify(state, null, 2);
                }
                
                document.getElementById('stateOutput').textContent = 'Model State (copy this for later use):\n\n' + formatted;
                document.getElementById('stateOutput').style.display = 'block';
            } else {
                document.getElementById('stateOutput').textContent = 'Error: Failed to export model state';
                document.getElementById('stateOutput').style.display = 'block';
            }
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            document.getElementById('stateOutput').textContent = 'Error: ' + errorMsg;
            document.getElementById('stateOutput').style.display = 'block';
        }
    }

    window.loadFromState = function() {
        const stateText = document.getElementById('stateOutput').textContent;

        if (!stateText || !stateText.includes('Model State')) {
            window.updateStatus('error', 'Please export model state first');
            return;
        }

        try {
            const jsonStart = stateText.indexOf('{');
            const stateJson = stateText.substring(jsonStart);

            cameraModel = new Module.USGSCSMModel();

            const success = cameraModel.loadFromState(stateJson);

            if (success) {
                window.updateStatus('success', 'Camera model loaded from state successfully! Model is ready to use.');
                window.enableModelButtons(true);
            } else {
                window.updateStatus('error', 'Failed to load camera model from state. Check console for details.');
                cameraModel = null;
                window.enableModelButtons(false);
            }
        } catch (err) {
            const errorMsg = err && err.message ? err.message : String(err);
            window.updateStatus('error', 'Error loading from state: ' + errorMsg);
            window.enableModelButtons(false);
        }
    }

    const moduleConfig = {
        locateFile: function(path) {
            if (path.endsWith('.wasm')) {
                return '/docs/how-to-guides/demos/usgscsm.wasm';
            }
            return path;
        }
    };
    
    USGSCSM(moduleConfig).then(mod => {
        Module = mod;
        window.updateStatus('success', 'USGSCSM WASM module loaded successfully! Ready to use.');

        document.getElementById('loadBtn').disabled = false;
        document.getElementById('exampleBtn').disabled = false;
    }).catch(err => {
        window.updateStatus('error', 'Failed to load USGSCSM WASM module: ' + err.message);
    });
</script>

---

!!! info "WASM Files Included"
    The USGSCSM WASM files (`usgscsm.js`, `usgscsm.wasm`, `usgscsm.d.ts`) from [release 2.1.0](https://github.com/DOI-USGS/usgscsm/releases/tag/2.1.0) are included in this repository, so the demo works immediately without additional setup.

## What the Demo Shows

The interactive demo demonstrates:

1. **Loading Camera Models**
   - Load sensor models from ISD (Image Support Data) JSON
   - Support for Frame, Line Scanner, and SAR models
   - Example model loading

2. **Image to Ground Conversion**
   - Convert pixel coordinates (line, sample) to Body-Fixed ground coordinates
   - Specify height above reference ellipsoid
   - Real-time coordinate transformation

3. **Ground to Image Conversion**
   - Convert Body-Fixed coordinates to pixel coordinates
   - Determine which pixels image a given ground point

4. **Sensor Position & Velocity**
   - Query camera position at any pixel location
   - Get sensor velocity vectors (useful for line scanners)

5. **Model Metadata & Illumination**
   - View model information (type, image ID, sensor, platform)
   - Get image dimensions and starting coordinates
   - Calculate sun direction for lighting/shadow analysis

6. **Export Model State**
   - View the optimized internal model representation
   - Copy the state for use in other applications

## Related Documentation

- [Using USGSCSM WASM Bindings](/docs/getting-started/csm-stack/usgscsm-wasm-bindings/) - Installation and setup guide
- [USGSCSM GitHub Repository](https://github.com/DOI-USGS/usgscsm) - Full source code and documentation
- [CSM Sandbox Tutorial](../../getting-started/csm-stack/csm-sandbox.ipynb) - Python-based CSM examples