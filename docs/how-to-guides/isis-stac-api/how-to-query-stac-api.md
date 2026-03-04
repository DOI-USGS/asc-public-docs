# ISIS STAC API - ISIS Global DTMs

This API implements a **subset of the STAC Search specification** using
[`stac-server`](https://github.com/stac-utils/stac-server).

It provides an opinionated search endpoint designed to resolve the most
to determine the most appropriate ISIS shape model for a given target body, as well as standard
STAC collection and item endpoints for browsing.

---

## Base URL

'https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/'

---

## ISIS Global DTMs Collection URL
Use this endpoint for browsing and spatial queries (e.g., bbox):

`https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/collections/isis-global-dtms/items`

---

## STAC Search Endpoint

The `/search` endpoint is optimized for automated ISIS workflows and returns a single, recommended shape model per request.

`https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/search`

### Query Options

`query["ssys:targets"].in` (required)

Specifies the planetary body for which a shape model is requested.

- Type: array of strings
- Required: yes
- Matching: case-insensitive, matches if any value in the array equals a target
- Source: typically extracted from an ISIS cube label (TargetName)

#### Example:
```
{
  "query": {
    "ssys:targets": {
      "in": ["Mars"]
    }
  }
}
```

### Sort Options

`sort` (required if you want the latest versioned DEM)

Controls the order of returned Items. Multiple sort fields can be specified; they are applied in order.

- Type: array of objects
- Required: yes if requesting the latest versioned DEM; optional otherwise
- Fields:
  - `field` – property name to sort by (e.g., "version")
  - `direction` – "asc" for ascending or "desc" for descending

#### Example:
```
{
  "sort": [
    {
      "field": "version",
      "direction": "desc"
    }
  ]
}
```

This sorts Items by `version` in descending order, so the newest version comes first.

### Limit Option

`limit` (required if you want the latest versioned DEM)

Specifies the maximum number of Items returned in a single response.

- Type: integer
- Required: yes if requesting the latest versioned DEM; optional otherwise
- Behavior: If omitted, the server may return multiple Items, not necessarily the latest.

#### Example:
```
{
  "limit": 1
}
```

This request will return only one Item, which, combined with the descending version sort, ensures you get the latest version.

#### Combined Example: Get the Latest DEM:
```
{
  "collections": ["isis-global-dtms"],
  "query": {
    "ssys:targets": { "in": ["Mars"] }
  },
  "sort": [
    { "field": "version", "direction": "desc" }
  ],
  "limit": 1
}
```
**Behavior:**
 - Filters to Mars DTMs
 - Sorts by newest version first
 - Returns only the latest versioned Item

---

### Example Curl Request

```
curl -X POST "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/search"   -H "Content-Type: application/json"   -d '{
     "collections": ["isis-global-dtms"],
     "query": {
       "ssys:targets": {"in": ["Mars"]}
     },
     "sort": [{"field": "version", "direction": "desc"}],
     "limit": 1
   }'
```

### JSON Response
The endpoint returns a single JSON object.

```
{
    "type": "FeatureCollection",
    "stac_version": "1.0.0",
    "stac_extensions": [],
    "context": {
        "limit": 1,
        "matched": 3,
        "returned": 1
    },
    "numberMatched": 3,
    "numberReturned": 1,
    "features": [
        {
            "type": "Feature",
            "stac_version": "1.1.0",
            "stac_extensions": [
                "https://stac-extensions.github.io/version/v1.0.0/schema.json"
            ],
            "id": "molaMarsPlanetaryRadius0005",
            "geometry": {
                "type": "Polygon",
                "coordinates": [
                    [
                        [
                            180,
                            -89.99843755425232
                        ],
                        [
                            180,
                            90
                        ],
                        [
                            -180,
                            90
                        ],
                        [
                            -180,
                            -89.99843755425232
                        ],
                        [
                            180,
                            -89.99843755425232
                        ]
                    ]
                ]
            },
            "bbox": [
                -180,
                -89.99843755425232,
                180,
                90
            ],
            "properties": {
                "ssys:targets": [
                    "Mars"
                ],
                "version": "0005",
                "datetime": "2026-01-12T19:45:38.253407Z",
                "created": "2025-12-01T17:12:43.395Z",
                "updated": "2026-01-12T19:49:54.921Z"
            },
            "links": [
                {
                    "rel": "self",
                    "type": "application/geo+json",
                    "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/collections/isis-global-dtms/items/molaMarsPlanetaryRadius0005"
                },
                {
                    "rel": "parent",
                    "type": "application/json",
                    "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/collections/isis-global-dtms"
                },
                {
                    "rel": "collection",
                    "type": "application/json",
                    "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/collections/isis-global-dtms"
                },
                {
                    "rel": "root",
                    "type": "application/json",
                    "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod"
                },
                {
                    "rel": "thumbnail",
                    "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/collections/isis-global-dtms/items/molaMarsPlanetaryRadius0005/thumbnail"
                }
            ],
            "assets": {
                "data": {
                    "href": "https://asc-isisdata.s3.us-west-2.amazonaws.com/isis-stac/isis-dtm-collection/molaMarsPlanetaryRadius0005.tiff",
                    "type": "image/tiff; application=geotiff"
                }
            },
            "collection": "isis-global-dtms"
        }
    ],
    "links": [
        {
            "rel": "next",
            "title": "Next page of Items",
            "method": "POST",
            "type": "application/geo+json",
            "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod/search",
            "merge": false,
            "body": {
                "query": {
                    "ssys:targets": {
                        "in": [
                            "Mars"
                        ]
                    }
                },
                "collections": [
                    "isis-global-dtms"
                ],
                "limit": 1,
                "next": "2026-01-12T19:45:38.253407Z,molaMarsPlanetaryRadius0005,isis-global-dtms"
            }
        },
        {
            "rel": "root",
            "type": "application/json",
            "href": "https://3hr5l9mbj6.execute-api.us-west-2.amazonaws.com/prod"
        }
    ]
}
```

### Key Fields in STAC Response

| Field Path                                   | Description                     |
|---------------------------------------------|---------------------------------|
| `features[0].id`                            | STAC Item ID                     |
| `features[0].properties.version`            | DEM version                      |
| `features[0].properties["ssys:targets"][0]`| Target body                       |
| `features[0].assets.data.href`              | GeoTIFF URL (use `/vsicurl/` to access via GDAL) |
| `features[0].links[*]` where `rel="self"`  | STAC JSON URL for the Item       |
| `features[0].links[*]` where `rel="thumbnail"` | Thumbnail image URL          |

### Inspecting the Shape Model GeoTIFF Using GDAL

To inspect the returned shape model using GDAL, prepend /vsicurl/ to the
returned URL.

`gdalinfo /vsicurl/https://asc-isisdata.s3.us-west-2.amazonaws.com/isis-stac/isis-dtm-collection/molaMarsPlanetaryRadius0005.tiff`


### How to use STAC API in ISIS

ISIS uses its integrated GDAL support to read GeoTIFF shape models directly from vsicurl URLs without requiring a local download.

The `spiceinit` application includes a `WEB` option under the `SHAPE` parameter that allows shape model selection via the STAC API.
If no matching shape model is found, spiceinit falls back to the `SYSTEM` option, which searches for a shape model in the local data area.

`spiceinit from=default.cub shape=web`

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
