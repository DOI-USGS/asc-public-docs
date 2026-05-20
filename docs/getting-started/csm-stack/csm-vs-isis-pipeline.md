# Pipelines for CSM vs ISIS Camera Models

Two types of camera model are available from USGS Astro: CSM or ISIS.

For ether model, the first step is to ingest the image into an ISIS .cub using an `2isis` app.  After that, the process diverges, depending on which Camera Model is preferred. You can attach ***SPICE information*** for the **ISIS Camera Model**, or a ***CSM State String*** for the **CSM Camera Model**.

```mermaid
flowchart TD
    A["Raw Image (.img)"] -->|ISIS: x2isis | B["Uninitialized Cube (.cub)"]
    B -->|ALE: isd_generate| C["ISD (.json)"]
    C -->|ISIS: csminit| D["CSM Camera Model (.cub)"]
    B -->|ISIS: spiceinit| E["ISIS Camera Model (.cub)"]
    D --> F(Camera Model-dependent ISIS Apps)
    E --> F
```

The ISIS and CSM Camera Models differ slightly from each other. But either way, after a Camera Model is attached, you can do further Camera Model-dependent work in ISIS:

- Control Networks
- Bundle Adjustment
- Mosaics
- DEM/Shape Model Creation