# ISIS STAC API - ISIS Global DTMs

This API implements a **subset of the STAC Search specification** using
[`stac-server`](https://github.com/stac-utils/stac-server).

It provides an opinionated search endpoint designed to resolve the most
to determine the most appropriate ISIS shape model for a given target body, as well as standard
STAC collection and item endpoints for browsing.

---

## Base URL

`https://isis-stac.prod-asc.chs.usgs.gov/`

---

## ISIS Global DTMs Collection URL
Use this endpoint for browsing and spatial queries (e.g., bbox):

`https://isis-stac.prod-asc.chs.usgs.gov/collections/isis-global-dtms/items`

---

## STAC Search Endpoint

The `/search` endpoint is optimized for automated ISIS workflows and returns a single, recommended shape model per request.

`https://isis-stac.prod-asc.chs.usgs.gov/search`

### Query Options

`query.target.eq` (required)

Specifies the planetary body for which a shape model is requested.

- Type: string

- Required: yes

- Matching: case-insensitive

- Source: typically extracted from an ISIS cube label (TargetName)

---

### Example Curl Request

```
curl -X POST "https://isis-stac.prod-asc.chs.usgs.gov/search" \
  -H "Content-Type: application/json" \
  -d '{"query":{"target":{"eq":"Mars"}}}'
```

### JSON Response
The endpoint returns a single JSON object.

```
{
    "id": "molaMarsPlanetaryRadius0005", 
    "tiff_url": "https://asc-isisdata.s3.us-west-2.amazonaws.com/isis-stac/isis-dtm-collection/molaMarsPlanetaryRadius0005.tiff"
}
```

| Field      | Type     | Description                                                                                         |
| ---------- | -------- | --------------------------------------------------------------------------------------------------- |
| `id`       | `string` | STAC Item ID of the selected shape model. When multiple versions exist, this is the latest version. |
| `tiff_url` | `string` | GDAL-compatible `/vsicurl/` URL pointing to the GeoTIFF shape model asset.                          |


### Shape Model Version Selection

When multiple shape models exist for the same target, the /search endpoint automatically selects the latest version using the ISIS KernelDb versioning convention.

This behavior ensures consistency with existing ISIS kernel resolution logic and avoids ambiguity for automated workflows.

#### Example Item IDs

```
molaMarsPlanetaryRadius0003
molaMarsPlanetaryRadius0004
molaMarsPlanetaryRadius0005
```

In this scheme:

 - The trailing four digits represent the version number

- Higher numbers indicate newer versions


#### How the /search Endpoint Determines the Latest Version

Internally, the endpoint:

1. Queries OpenSearch for up to 10 shape models matching the target

2. Extracts the version number from the item ID

3. Compares version numbers numerically

4. Selects the item with the highest version number

#### Version Parsing Logic

1. If the last four characters of the item ID are digits, they are interpreted as the version

2. If no numeric suffix is present, the version is treated as 0

3. The item with the highest parsed version is returned

This mirrors how ISIS KernelDb resolves multiple kernel candidates.

### Inspecting the Shape Model GeoTIFF Using GDAL

To inspect the returned shape model using GDAL, prepend /vsicurl/ to the
returned URL.

`gdalinfo /vsicurl/https://asc-isisdata.s3.us-west-2.amazonaws.com/isis-stac/isis-dtm-collection/molaMarsPlanetaryRadius0005.tiff`


### How to use STAC API in ISIS

ISIS uses its integrated GDAL support to read GeoTIFF shape models directly from vsicurl URLs without requiring a local download.

The `spiceinit` application includes a `WEB` option under the `SHAPE` parameter that allows shape model selection via the STAC API.
If no matching shape model is found, spiceinit falls back to the `SYSTEM` option, which searches for a shape model in the local data area.

`spiceinit from=default.cub to=spiced-default.cub shape=web`

#### Example PVL output:
```
  Group = Kernels
    NaifFrameCode             = -27002
    ShapeModel                = /vsicurl/https://asc-isisdata.s3.us-west-2.am-
                                azonaws.com/isis-stac/isis-dtm-collection/mol-
                                aMarsPlanetaryRadius0005.tiff
    LeapSecond                = $base/kernels/lsk/naif0012.tls
    TargetAttitudeShape       = $base/kernels/pck/pck00009.tpc
    TargetPosition            = (Table, $base/kernels/spk/de430.bsp,
                                 $base/kernels/spk/mar097.bsp)
    InstrumentPointing        = (Table, $viking1/kernels/ck/vo1_sedr_ck2.bc,
                                 $viking1/kernels/fk/vo1_v10.tf)
    Instrument                = Null
    SpacecraftClock           = ($viking1/kernels/sclk/vo1_fict.tsc,
                                 $viking1/kernels/sclk/vo1_fsc.tsc)
    InstrumentPosition        = (Table, $viking1/kernels/spk/viking1a.bsp)
    InstrumentAddendum        = $viking1/kernels/iak/vikingAddendum003.ti
    InstrumentPositionQuality = Reconstructed
    InstrumentPointingQuality = Reconstructed
    CameraVersion             = 1
    Source                    = ale
  End_Group
```
