# Exploring SpiceQL's REST, Python, and C++ APIs

This tutorial will go over making SpiceQL calls using the USGS-hosted web service (link-tbd) and your local SpiceQL service.

SpiceQL has three APIs that can be accessed to utilize the library:  

- REST  
- Python bindings  
- C++  

The following parameters are universal across the three interfaces: 

- `useWeb`: Boolean flag to use web-enabled SpiceQL as backend  
- `searchKernels`: Boolean flag to search through SpiceQL's kernels  
- `kernelList`: A list of kernels to be furnished

!!! note "Parameter `useWeb` Conditions"

    Verify that if `useWeb` is set to `True`, either `searchKernels` or `kernelList` must set. Both `searchKernels` and `kernelList` can be passed in together as well. 

### Response Types
!!! info "Response Types"

    === "REST"

        ```json
        {
            "statusCode": 200, 
            "body": {
                "return": ,
                "kernels": {}
            }
        }
        ```
        Return type: JSON object  

        - `statusCode`: HTTP status code  
        - `body`  
            - `return`: Return data object  
            - `kernels`: List of kernels used  

    === "Python"

        ```py
        tuple ()
        ```

    === "C++"

        ```c++
        using namespace std;

        std::pair <>;
        ```


## Using Web SpiceQL

You can set the flag `useWeb` to enable SpiceQL's cloud application without having to download ISIS data areas.

!!! example "Calling getTargetOrientations"

    ### Function calls

    === "REST"

        ``` bash
        curl -GET "http://127.0.0.1:8080/getTargetOrientations?ets=[690201375.8323615]&toFrame=-74000&refFrame=-74690&mission=ctx&useWeb=True&searchKernels=True"
        ```

    === "Python"

        ``` python
        import pyspiceql as pql

        pql.getTargetOrientations(
            ets=[690201375.8323615],
            toFrame=-74000,
            refFrame=-74690,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ``` c++
        #include api.h

        int main(void) {
        SpiceQL::getTargetOrientations({690201375.8323615}, -74000, -74690, "ctx", true, true)
        }
        ```

    ### Responses

    === "REST"

        ``` json
        {"statusCode":200,"body":{"return":[[0.9999924134600601,0.0005720078450331138,0.003853027964066137,-2.2039789431520754e-06,0.0,0.0,0.0]],"kernels":{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"pck":["/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"tspk":["/base/kernels/spk/de430.bsp"]}}}
        ```
    === "Python"

        ```py
        ([[0.9999924134600601,0.0005720078450331138,0.003853027964066137,-2.2039789431520754e-06,0.0,0.0,0.0]],{'ck': ['/mro/kernels/ck/mro_sc_psp_211109_211115.bc'],'ctx_ck_quality': 'reconstructed','fk': ['/mro/kernels/fk/mro_v16.tf'],'lsk': ['/base/kernels/lsk/naif0012.tls'],'pck': ['/base/kernels/pck/pck00009.tpc'],'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc'],'tspk': ['/base/kernels/spk/de430.bsp']})
        ```

    === "C++"

        ```c++
        ({}, {})
        ```


## Using Your Local SpiceQL Server

### 1. Set up conda environment

Follow the repo's [README](https://github.com/DOI-USGS/SpiceQL?tab=readme-ov-file#building-the-library) to set up and build your local SpiceQL environment.

### 2. Export environment variables
!!! warning ""
    Set the following environment variables:

    - `ISISDATA`: Path to your ISIS data area 
    - `SPICEQL_CACHE_DIR`: Path to the folder that will contain your database and cached files
    - `SPICEQL_REST_URL`: Your local FastAPI URL, most likely "http://127.0.0.1:8080/"
    - `SPICEQL_LOG_LEVEL`: *(Optional)* Outputs logs based on level of severity [`off`, `critical`, `error`, `warning` (default), `info`, `debug`, `trace`]


### 3. Generate your database

The database is generated over the data in your `ISISDATA` dir and is outputted to an agnostic HDF5 file in your `SPICEQL_CACHE_DIR` path.

!!! info "Before you proceed..."

    Generating your database over a full `ISISDATA` area may take *a few hours*. We recommend targeting missions specific to your use case for a faster generation time. You can find acceptable mission names at TBD-PUBLIC-URL and under the [repo's db/ folder](https://github.com/DOI-USGS/SpiceQL/tree/main/SpiceQL/db) with the format being "<mission>.json". Mission instrument names can be found in each "<mission>.json" file as JSON keys. Supplemental names like planetary bodies can be found in the [db/base.json](https://github.com/DOI-USGS/SpiceQL/blob/main/SpiceQL/db/base.json) file as JSON keys.

#### Generate database for the entire `ISISDATA` area

!!! example "Entire `ISISDATA` area"
    ```py
    import pyspiceql as pql

    pql.create_database()
    ```

#### Generate database for specific missions

The `create_database()` function accepts a `list` parameter of names to search for to populate the database with.

!!! example "MRO CTX"
    ```py
    import pyspiceql as pql

    pql.create_database(["base", "mro", "mars", "ctx"])
    ```

### 4. Spin up your local SpiceQL server

In a terminal, go to your SpiceQL repo's `fastapi/` dir and run the command below to spin up your local SpiceQL server. This will host your local SpiceQL at [http://127.0.0.1:8080/](http://127.0.0.1:8080/) which should be what your `SPICEQL_REST_URL` is set as.

```bash
uvicorn app.main:app --reload --port 8080
```

