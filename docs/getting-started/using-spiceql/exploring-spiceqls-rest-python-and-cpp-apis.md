# Exploring SpiceQL's REST, Python, and C++ APIs

This tutorial will go over making SpiceQL calls using the USGS-hosted web service at https://astrogeology.usgs.gov/apis/spiceql/latest/ and your local SpiceQL service.

SpiceQL has three APIs that can be accessed to utilize the library:  

- REST  
- Python bindings  
- C++  

The following parameters are universal across the three interfaces: 

- `searchKernels`: Boolean flag to search through SpiceQL's kernels  
- `kernelList`: A list of kernels to be furnished


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


## Using USGS's web-hosted SpiceQL

You can set the flag `useWeb` to enable SpiceQL's cloud feature without having to download ISIS data areas for Python and C++ calls.

!!! note "Parameter `useWeb` Conditions"

    Verify that if `useWeb` is set to `True`, either `searchKernels` or `kernelList` must set. Both `searchKernels` and `kernelList` can be passed in together as well. 


*Note: The following **C++** responses are formatted as though they were initialized with appropriate data type syntax.

!!! tip "Before following the API examples..."

    === "REST"

        Install `curl` in your terminal or copy/paste the example URL in your browser.

    === "Python"

        ```py
        import pyspiceql as pql
        ```

    === "C++"

        ```c++
        #include spiceql.h
        ```

### Examples

??? example "getTargetStates"

    #### getTargetStates

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/getTargetStates?ets=[690201375.8323615,690201389.2866975]&target=SUN&observer=Mars&frame=IAU_MARS&mission=ctx&abcorr=LT%2BS&searchKernels=true"
        ```

    === "Python"

        ```python
        pql.getTargetStates(
            ets=[690201375.8323615,690201389.2866975],
            target="SUN",
            observer="Mars",
            frame="IAU_MARS",
            abcorr="LT+S",
            mission="ctx",
            useWeb=True,
            searchKernels=True)
        ```

    === "C++"

        ```c++
        SpiceQL::getTargetOrientations({690201375.8323615}, -74000, -74690, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":[[123515791.9195627,187209003.7067195,80611152.03610656,13251.543112834495,-8742.597438450646,-6.575020419444353,794.9856233875888],[123694026.59723282,187091292.98278633,80611063.57350075,13243.211405493359,-8755.21373709343,-6.575031051390966,794.985539001637]],"kernels":{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","ctx_spk_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/hayabusa2/kernels/lsk/naif0012.tls","/base/kernels/lsk/naif0012.tls"],"pck":["/odyssey/kernels/pck/pck00009.tpc","/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"spk":["/mro/kernels/spk/mro_psp61.bsp"],"tspk":["/tgo/kernels/tspk/mar097.bsp","/dawn/kernels/spk/de432.bsp","/base/kernels/spk/de430.bsp"]}}}
        ```
    === "Python"

        ```py
        ([[123515791.9195627, 187209003.7067195, 80611152.03610656, 13251.543112834495, -8742.597438450646, -6.575020419444353, 794.9856233875888], [123694026.59723282, 187091292.98278633, 80611063.57350075, 13243.211405493359, -8755.21373709343, -6.575031051390966, 794.985539001637]], {'ck': ['/mro/kernels/ck/mro_sc_psp_211109_211115.bc'], 'ctx_ck_quality': 'reconstructed', 'ctx_spk_quality': 'reconstructed', 'fk': ['/mro/kernels/fk/mro_v16.tf'], 'lsk': ['/hayabusa2/kernels/lsk/naif0012.tls', '/base/kernels/lsk/naif0012.tls'], 'pck': ['/odyssey/kernels/pck/pck00009.tpc', '/base/kernels/pck/pck00009.tpc'], 'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc'], 'spk': ['/mro/kernels/spk/mro_psp61.bsp'], 'tspk': ['/tgo/kernels/tspk/mar097.bsp', '/dawn/kernels/spk/de432.bsp', '/base/kernels/spk/de430.bsp']})
        ```

    === "C++"

        ```c++
        {{{123515791.9195627,187209003.7067195,80611152.03610656,13251.543112834495,-8742.597438450646,-6.575020419444353,794.9856233875888},{123694026.59723282,187091292.98278633,80611063.57350075,13243.211405493359,-8755.21373709343,-6.575031051390966,794.985539001637}},{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","ctx_spk_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/hayabusa2/kernels/lsk/naif0012.tls","/base/kernels/lsk/naif0012.tls"],"pck":["/odyssey/kernels/pck/pck00009.tpc","/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"spk":["/mro/kernels/spk/mro_psp61.bsp"],"tspk":["/tgo/kernels/tspk/mar097.bsp","/dawn/kernels/spk/de432.bsp","/base/kernels/spk/de430.bsp"]}}
        ```


??? example "getTargetOrientations"

    #### getTargetOrientations

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/getTargetOrientations?ets=[690201375.8323615]&toFrame=-74000&refFrame=-74690&mission=ctx&useWeb=True&searchKernels=True"
        ```

    === "Python"

        ```py
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

        ```c++
        SpiceQL::getTargetOrientations({690201375.8323615}, -74000, -74690, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":[[0.9999924134600601,0.0005720078450331138,0.003853027964066137,-2.2039789431520754e-06,0.0,0.0,0.0]],"kernels":{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"pck":["/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"tspk":["/base/kernels/spk/de430.bsp"]}}}
        ```
    === "Python"

        ```py
        ([[0.9999924134600601,0.0005720078450331138,0.003853027964066137,-2.2039789431520754e-06,0.0,0.0,0.0]],{'ck': ['/mro/kernels/ck/mro_sc_psp_211109_211115.bc'],'ctx_ck_quality': 'reconstructed','fk': ['/mro/kernels/fk/mro_v16.tf'],'lsk': ['/base/kernels/lsk/naif0012.tls'],'pck': ['/base/kernels/pck/pck00009.tpc'],'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc'],'tspk': ['/base/kernels/spk/de430.bsp']})
        ```

    === "C++"

        ```c++
        {{{0.9999924134600601,0.0005720078450331138,0.003853027964066137,-2.2039789431520754e-06,0.0,0.0,0.0}},{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"pck":["/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"tspk":["/base/kernels/spk/de430.bsp"]}}
        ```


??? example "strSclkToEt"

    #### strSclkToEt

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/strSclkToEt?frameCode=-74&sclk=1321396563:036&mission=ctx&searchKernels=True"
        ```

    === "Python"

        ```py
        pql.strSclkToEt(
            frameCode=-74,
            sclk="1321396563:036",
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::strSclkToEt(-74, "1321396563:036", "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":690201375.8323615,"kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"]}}}
        ```

    === "Python"

        ```py
        (690201375.8323615, {'fk': ['/mro/kernels/fk/mro_v16.tf'], 'lsk': ['/base/kernels/lsk/naif0012.tls'], 'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc']})
        ```

    === "C++"

        ```c++
        {690201375.8323615,{"fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"]}}
        ```


??? example "doubleSclkToEt"

    #### doubleSclkToEt

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/doubleSclkToEt?frameCode=-85&sclk=922997380.174174&mission=lro&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.doubleSclkToEt(
            frameCode=-85,
            sclk=922997380.174174,
            mission="lro",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::doubleSclkToEt(-74, "1321396563:036", "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":31593348.006268278,"kernels":{"fk":["/lro/kernels/fk/lro_frames_2014049_v01.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/lro/kernels/sclk/lro_clkcor_2024262_v00.tsc"]}}}
        ```

    === "Python"

        ```py
        (31593348.006268278, {'fk': ['/lro/kernels/fk/lro_frames_2014049_v01.tf'], 'lsk': ['/base/kernels/lsk/naif0012.tls'], 'sclk': ['/lro/kernels/sclk/lro_clkcor_2024262_v00.tsc']})
        ```

    === "C++"

        ```c++
        {31593348.006268278,{"fk":["/lro/kernels/fk/lro_frames_2014049_v01.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/lro/kernels/sclk/lro_clkcor_2024262_v00.tsc"]}}}
        ```


??? example "doubleEtToSclk"

    #### doubleEtToSclk

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/doubleEtToSclk?et=690201375.8323615&frameCode=-74&kernelList=[]&mission=ctx&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.doubleEtToSclk(
            frameCode=-74,
            et=690201375.8323615,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::doubleEtToSclk(-74, "1321396563:036", "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":"27/1321396563.036","kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"]}}}
        ```

    === "Python"

        ```py
        ('27/1321396563.036', {'fk': ['/mro/kernels/fk/mro_v16.tf'], 'lsk': ['/base/kernels/lsk/naif0012.tls'], 'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc']})
        ```

    === "C++"

        ```c++
        {"27/1321396563.036",{"fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"]}}
        ```
        

??? example "utcToEt"

    #### utcToEt

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/utcToEt?utc=1971-08-04T16:28:24.9159358&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.utcToEt(
            utc="1971-08-04T16:28:24.9159358",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::utcToEt("1971-08-04T16:28:24.9159358", true, true)
        ```

    <h3>Responses</h3> 

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":-896556653.900884,"kernels":{"lsk":["/Volumes/t7-shield/isis_data/base/kernels/lsk/naif0012.tls"]}}}
        ```

    === "Python"

        ```py
        (-896556653.900884, {'lsk': ['/base/kernels/lsk/naif0012.tls']})
    
        ```

    === "C++"

        ```c++
        {-896556653.900884,{"lsk":["/Volumes/t7-shield/isis_data/base/kernels/lsk/naif0012.tls"]}}
        ```


??? example "etToUtc"

    #### etToUtc

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/etToUtc?et=-896556653.900884&format=C&precision=10&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.etToUtc(
            et=-896556653.900884,
            format="C",
            precision=10,
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::etToUtc(-896556653.900884, "C", 10, true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":"1971 AUG 04 16:28:24.9159357548","kernels":{"lsk":["/base/kernels/lsk/naif0012.tls"]}}}
        ```

    === "Python"

        ```py
        ('1971 AUG 04 16:28:24.9159357548', {'lsk': ['/base/kernels/lsk/naif0012.tls']})
        ```

    === "C++"

        ```c++
        {"1971 AUG 04 16:28:24.9159357548",{"lsk":["/base/kernels/lsk/naif0012.tls"]}}
        ```

    
??? example "translateNameToCode"

    #### translateNameToCode

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/translateNameToCode?frame=MRO&mission=ctx&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.translateNameToCode(
            frame="MRO",
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::translateNameToCode("MRO", "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":-74,"kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"]}}}
        ```

    === "Python"

        ```py
        (-74, {'fk': ['/mro/kernels/fk/mro_v16.tf']})
        ```

    === "C++"

        ```c++
        {-74,{"fk":["/mro/kernels/fk/mro_v16.tf"]}}
        ```


??? example "translateCodeToName"

    #### translateCodeToName

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/translateCodeToName?frame=-74&mission=ctx&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.translateNameToCode(
            frame=-74,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::translateNameToCode(-74, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":"MRO","kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"]}}}
        ```

    === "Python"

        ```py
        ('MRO', {'fk': ['/mro/kernels/fk/mro_v16.tf']})
        ```

    === "C++"

        ```c++
        {"MRO",{"fk":["/mro/kernels/fk/mro_v16.tf"]}}
        ```


??? example "getFrameInfo"

    #### getFrameInfo

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/getFrameInfo?frame=-74021&mission=ctx&searchKernels=true"
        ```

    === "Python"

        ```py
        pql.getFrameInfo(
            frame=-74021,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::getFrameInfo(-74021, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":[-74,4,-74021],"kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"]}}}
        ```

    === "Python"

        ```py
        ([-74, 4, -74021], {'fk': ['/mro/kernels/fk/mro_v16.tf']})
        ```

    === "C++"

        ```c++
        {{-74,4,-74021},{"fk":["/mro/kernels/fk/mro_v16.tf"]}}
        ```


??? example "getTargetFrameInfo"

    #### getTargetFrameInfo

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/getTargetFrameInfo?targetId=499&mission=ctx&searchKernels=True"
        ```

    === "Python"

        ```py
        pql.getTargetFrameInfo(
            targetId=499,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::getTargetFrameInfo(499, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":{"frameCode":10014,"frameName":"IAU_MARS"},"kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"]}}}
        ```

    === "Python"

        ```py
        ({'frameCode': 10014, 'frameName': 'IAU_MARS'}, {'fk': ['/mro/kernels/fk/mro_v16.tf']})
        ```

    === "C++"

        ```c++
        {{"frameCode":10014,"frameName":"IAU_MARS"},{"fk":["/mro/kernels/fk/mro_v16.tf"]}}
        ```


??? example "findMissionKeywords"

    #### findMissionKeywords

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/findMissionKeywords?key=*-74021*&mission=ctx&searchKernels=True"
        ```

    === "Python"

        ```py
        pql.findMissionKeywords(
            key="*-74021*",
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::findMissionKeywords("*-74021*", "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":{"FRAME_-74021_CENTER":-74.0,"FRAME_-74021_CLASS":4.0,"FRAME_-74021_CLASS_ID":-74021.0,"FRAME_-74021_NAME":"MRO_CTX","INS-74021_BORESIGHT":[0.0,0.0,1.0],"INS-74021_BORESIGHT_LINE":0.430442527,"INS-74021_BORESIGHT_SAMPLE":2543.46099,"INS-74021_CCD_CENTER":[2500.5,0.5],"INS-74021_CK_FRAME_ID":-74000.0,"INS-74021_CK_REFERENCE_ID":-74900.0,"INS-74021_F/RATIO":3.25,"INS-74021_FOCAL_LENGTH":352.9271664,"INS-74021_FOV_ANGLE_UNITS":"DEGREES","INS-74021_FOV_ANGULAR_SIZE":[5.73,0.001146],"INS-74021_FOV_CLASS_SPEC":"ANGLES","INS-74021_FOV_CROSS_ANGLE":0.00057296,"INS-74021_FOV_FRAME":"MRO_CTX","INS-74021_FOV_REF_ANGLE":2.86478898,"INS-74021_FOV_REF_VECTOR":[0.0,1.0,0.0],"INS-74021_FOV_SHAPE":"RECTANGLE","INS-74021_IFOV":[2e-05,2e-05],"INS-74021_ITRANSL":[0.0,142.85714285714,0.0],"INS-74021_ITRANSS":[0.0,0.0,142.85714285714],"INS-74021_OD_K":[-0.0073433925920054505,2.8375878636241697e-05,1.2841989124027099e-08],"INS-74021_PIXEL_LINES":1.0,"INS-74021_PIXEL_PITCH":0.007,"INS-74021_PIXEL_SAMPLES":5000.0,"INS-74021_PIXEL_SIZE":[0.007,0.007],"INS-74021_PLATFORM_ID":-74000.0,"INS-74021_TRANSX":[0.0,0.0,0.007],"INS-74021_TRANSY":[0.0,0.007,0.0],"TKFRAME_-74021_ANGLES":[0.0,0.0,0.0],"TKFRAME_-74021_AXES":[1.0,2.0,3.0],"TKFRAME_-74021_RELATIVE":"MRO_CTX_BASE","TKFRAME_-74021_SPEC":"ANGLES","TKFRAME_-74021_UNITS":"DEGREES"},"kernels":{"fk":["/mro/kernels/fk/mro_v16.tf"],"iak":["/mro/kernels/iak/mroctxAddendum005.ti"],"ik":["/mro/kernels/ik/mro_ctx_v11.ti"]}}}
        ```

    === "Python"

        ```py
        ({'FRAME_-74021_CENTER': -74.0, 'FRAME_-74021_CLASS': 4.0, 'FRAME_-74021_CLASS_ID': -74021.0, 'FRAME_-74021_NAME': 'MRO_CTX', 'INS-74021_BORESIGHT': [0.0, 0.0, 1.0], 'INS-74021_BORESIGHT_LINE': 0.430442527, 'INS-74021_BORESIGHT_SAMPLE': 2543.46099, 'INS-74021_CCD_CENTER': [2500.5, 0.5], 'INS-74021_CK_FRAME_ID': -74000.0, 'INS-74021_CK_REFERENCE_ID': -74900.0, 'INS-74021_F/RATIO': 3.25, 'INS-74021_FOCAL_LENGTH': 352.9271664, 'INS-74021_FOV_ANGLE_UNITS': 'DEGREES', 'INS-74021_FOV_ANGULAR_SIZE': [5.73, 0.001146], 'INS-74021_FOV_CLASS_SPEC': 'ANGLES', 'INS-74021_FOV_CROSS_ANGLE': 0.00057296, 'INS-74021_FOV_FRAME': 'MRO_CTX', 'INS-74021_FOV_REF_ANGLE': 2.86478898, 'INS-74021_FOV_REF_VECTOR': [0.0, 1.0, 0.0], 'INS-74021_FOV_SHAPE': 'RECTANGLE', 'INS-74021_IFOV': [2e-05, 2e-05], 'INS-74021_ITRANSL': [0.0, 142.85714285714, 0.0], 'INS-74021_ITRANSS': [0.0, 0.0, 142.85714285714], 'INS-74021_OD_K': [-0.0073433925920054505, 2.8375878636241697e-05, 1.2841989124027099e-08], 'INS-74021_PIXEL_LINES': 1.0, 'INS-74021_PIXEL_PITCH': 0.007, 'INS-74021_PIXEL_SAMPLES': 5000.0, 'INS-74021_PIXEL_SIZE': [0.007, 0.007], 'INS-74021_PLATFORM_ID': -74000.0, 'INS-74021_TRANSX': [0.0, 0.0, 0.007], 'INS-74021_TRANSY': [0.0, 0.007, 0.0], 'TKFRAME_-74021_ANGLES': [0.0, 0.0, 0.0], 'TKFRAME_-74021_AXES': [1.0, 2.0, 3.0], 'TKFRAME_-74021_RELATIVE': 'MRO_CTX_BASE', 'TKFRAME_-74021_SPEC': 'ANGLES', 'TKFRAME_-74021_UNITS': 'DEGREES'}, {'fk': ['/mro/kernels/fk/mro_v16.tf'], 'iak': ['/mro/kernels/iak/mroctxAddendum005.ti'], 'ik': ['/mro/kernels/ik/mro_ctx_v11.ti']})
        ```

    === "C++"

        ```c++
        {{"FRAME_-74021_CENTER":-74.0,"FRAME_-74021_CLASS":4.0,"FRAME_-74021_CLASS_ID":-74021.0,"FRAME_-74021_NAME":"MRO_CTX","INS-74021_BORESIGHT":[0.0,0.0,1.0],"INS-74021_BORESIGHT_LINE":0.430442527,"INS-74021_BORESIGHT_SAMPLE":2543.46099,"INS-74021_CCD_CENTER":[2500.5,0.5],"INS-74021_CK_FRAME_ID":-74000.0,"INS-74021_CK_REFERENCE_ID":-74900.0,"INS-74021_F/RATIO":3.25,"INS-74021_FOCAL_LENGTH":352.9271664,"INS-74021_FOV_ANGLE_UNITS":"DEGREES","INS-74021_FOV_ANGULAR_SIZE":[5.73,0.001146],"INS-74021_FOV_CLASS_SPEC":"ANGLES","INS-74021_FOV_CROSS_ANGLE":0.00057296,"INS-74021_FOV_FRAME":"MRO_CTX","INS-74021_FOV_REF_ANGLE":2.86478898,"INS-74021_FOV_REF_VECTOR":[0.0,1.0,0.0],"INS-74021_FOV_SHAPE":"RECTANGLE","INS-74021_IFOV":[2e-05,2e-05],"INS-74021_ITRANSL":[0.0,142.85714285714,0.0],"INS-74021_ITRANSS":[0.0,0.0,142.85714285714],"INS-74021_OD_K":[-0.0073433925920054505,2.8375878636241697e-05,1.2841989124027099e-08],"INS-74021_PIXEL_LINES":1.0,"INS-74021_PIXEL_PITCH":0.007,"INS-74021_PIXEL_SAMPLES":5000.0,"INS-74021_PIXEL_SIZE":[0.007,0.007],"INS-74021_PLATFORM_ID":-74000.0,"INS-74021_TRANSX":[0.0,0.0,0.007],"INS-74021_TRANSY":[0.0,0.007,0.0],"TKFRAME_-74021_ANGLES":[0.0,0.0,0.0],"TKFRAME_-74021_AXES":[1.0,2.0,3.0],"TKFRAME_-74021_RELATIVE":"MRO_CTX_BASE","TKFRAME_-74021_SPEC":"ANGLES","TKFRAME_-74021_UNITS":"DEGREES"},{"fk":["/mro/kernels/fk/mro_v16.tf"],"iak":["/mro/kernels/iak/mroctxAddendum005.ti"],"ik":["/mro/kernels/ik/mro_ctx_v11.ti"]}}
        ```


??? example "findTargetKeywords"

    #### findTargetKeywords

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/findTargetKeywords?key=*499*&mission=ctx&searchKernels=True"
        ```

    === "Python"

        ```py
        pql.findTargetKeywords(
            key="*499*",
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::findTargetKeywords("*499*", "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":{"BODY499_PM":[176.63,350.89198226,0.0],"BODY499_POLE_DEC":[52.8865,-0.0609,0.0],"BODY499_POLE_RA":[317.68143,-0.1061,0.0],"BODY499_RADII":[3396.19,3396.19,3376.2]},"kernels":{"pck":["/base/kernels/pck/pck00009.tpc"]}}}
        ```

    === "Python"

        ```py
        ({'BODY499_PM': [176.63, 350.89198226, 0.0], 'BODY499_POLE_DEC': [52.8865, -0.0609, 0.0], 'BODY499_POLE_RA': [317.68143, -0.1061, 0.0], 'BODY499_RADII': [3396.19, 3396.19, 3376.2]}, {'pck': ['/base/kernels/pck/pck00009.tpc']})
        ```

    === "C++"

        ```c++
        {{"BODY499_PM":[176.63,350.89198226,0.0],"BODY499_POLE_DEC":[52.8865,-0.0609,0.0],"BODY499_POLE_RA":[317.68143,-0.1061,0.0],"BODY499_RADII":[3396.19,3396.19,3376.2]},{"pck":["/base/kernels/pck/pck00009.tpc"]}}
        ```


??? example "frameTrace"

    #### frameTrace

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/frameTrace?et=690201382.5595295&initialFrame=-74021&mission=ctx&searchKernels=True"
        ```

    === "Python"

        ```py
        pql.frameTrace(
            et=690201382.5595295,
            initialFrame=-74021,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::frameTrace(690201382.5595295, -74021, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":[[-74000,-74900,1],[-74021,-74020,-74699,-74690,-74000]],"kernels":{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"pck":["/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"tspk":["/base/kernels/spk/de430.bsp"]}}}
        ```

    === "Python"

        ```py
        ([[-74000, -74900, 1], [-74021, -74020, -74699, -74690, -74000]], {'ck': ['/mro/kernels/ck/mro_sc_psp_211109_211115.bc'], 'ctx_ck_quality': 'reconstructed', 'fk': ['/mro/kernels/fk/mro_v16.tf'], 'lsk': ['/base/kernels/lsk/naif0012.tls'], 'pck': ['/base/kernels/pck/pck00009.tpc'], 'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc'], 'tspk': ['/base/kernels/spk/de430.bsp']})
        ```

    === "C++"

        ```c++
        {{{-74000,-74900,1},{-74021,-74020,-74699,-74690,-74000}},{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","fk":["/mro/kernels/fk/mro_v16.tf"],"lsk":["/base/kernels/lsk/naif0012.tls"],"pck":["/base/kernels/pck/pck00009.tpc"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"],"tspk":["/base/kernels/spk/de430.bsp"]}}
        ```


??? example "extractExactCkTimes"

    #### extractExactCkTimes

    <h3>Function calls</h3>

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/extractExactCkTimes?observStart=690201375.8323615&observEnd=690201389.2866975&targetFrame=-74021&mission=ctx&searchKernels=True"
        ```

    === "Python"

        ```py
        pql.extractExactCkTimes(
            observStart=690201375.8323615,
            observEnd=690201389.2866975,
            targetFrame=-74021,
            mission="ctx",
            useWeb=True,
            searchKernels=True
        )
        ```

    === "C++"

        ```c++
        SpiceQL::extractExactCkTimes(690201375.8323615, 690201389.2866975, -74021, "ctx", true, true)
        ```

    <h3>Responses</h3>

    === "REST"

        ```json
        {"statusCode":200,"body":{"return":[690201375.8001044,690201375.9005225,690201376.0001376,690201376.1005514,690201376.2003593,690201376.3007555,690201376.4001434,690201376.5005605,690201376.6001616,690201376.7006094,690201376.8001995,690201376.9005914,690201377.0002506,690201377.1006265,690201377.2001615,690201377.3006384,690201377.4002154,690201377.5006325,690201377.6001914,690201377.7006304,690201377.8002934,690201377.9007006,690201378.0002494,690201378.1006765,690201378.2002484,690201378.3007184,690201378.4002284,690201378.5006794,690201378.6003283,690201378.7007493,690201378.8002504,690201378.9007055,690201379.0002974,690201379.1006984,690201379.2002794,690201379.3007773,690201379.4004143,690201379.5007674,690201379.6002804,690201379.7012802,690201379.8006243,690201379.9007763,690201380.0003043,690201380.1007553,690201380.2004362,690201380.3008415,690201380.4003323,690201380.5007504,690201380.6003684,690201380.7007734,690201380.8003484,690201380.9007963,690201381.0004884,690201381.1008502,690201381.2003893,690201381.3008813,690201381.4004093,690201381.5008324,690201381.6003863,690201381.7008892,690201381.8004864,690201381.9009064,690201382.0004803,690201382.1008643,690201382.2004443,690201382.3009053,690201382.4004704,690201382.5008882,690201382.6009352,690201382.7011213,690201382.8006132,690201382.9009142,690201383.0005112,690201383.1009102,690201383.2005081,690201383.3010123,690201383.4005923,690201383.5009692,690201383.6004891,690201383.7008853,690201383.8005042,690201383.9009511,690201384.0005193,690201384.1009772,690201384.2006862,690201384.3010433,690201384.4005322,690201384.5009923,690201384.6005883,690201384.7010853,690201384.8005362,690201384.9010303,690201385.0006411,690201385.1010532,690201385.2006001,690201385.3010662,690201385.4006102,690201385.5010152,690201385.6006303,690201385.7010381,690201385.8008661,690201385.9011462,690201386.0006802,690201386.1010602,690201386.2006671,690201386.3011441,690201386.4006581,690201386.5010881,690201386.6007452,690201386.7011452,690201386.8006532,690201386.901147,690201387.000686,690201387.1011051,690201387.200734,690201387.3011972,690201387.4007832,690201387.5011872,690201387.600747,690201387.7011622,690201387.8007251,690201387.9011792,690201388.0007602,690201388.1012081,690201388.2008182,690201388.3012551,690201388.4008032,690201388.5012511,690201388.600788,690201388.701203,690201388.800896,690201388.9012221,690201389.000851,690201389.1012791,690201389.200796,690201389.301267],"kernels":{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"]}}}
        ```

    === "Python"

        ```py
        ([690201375.8001044, 690201375.9005225, 690201376.0001376, 690201376.1005514, 690201376.2003593, 690201376.3007555, 690201376.4001434, 690201376.5005605, 690201376.6001616, 690201376.7006094, 690201376.8001995, 690201376.9005914, 690201377.0002506, 690201377.1006265, 690201377.2001615, 690201377.3006384, 690201377.4002154, 690201377.5006325, 690201377.6001914, 690201377.7006304, 690201377.8002934, 690201377.9007006, 690201378.0002494, 690201378.1006765, 690201378.2002484, 690201378.3007184, 690201378.4002284, 690201378.5006794, 690201378.6003283, 690201378.7007493, 690201378.8002504, 690201378.9007055, 690201379.0002974, 690201379.1006984, 690201379.2002794, 690201379.3007773, 690201379.4004143, 690201379.5007674, 690201379.6002804, 690201379.7012802, 690201379.8006243, 690201379.9007763, 690201380.0003043, 690201380.1007553, 690201380.2004362, 690201380.3008415, 690201380.4003323, 690201380.5007504, 690201380.6003684, 690201380.7007734, 690201380.8003484, 690201380.9007963, 690201381.0004884, 690201381.1008502, 690201381.2003893, 690201381.3008813, 690201381.4004093, 690201381.5008324, 690201381.6003863, 690201381.7008892, 690201381.8004864, 690201381.9009064, 690201382.0004803, 690201382.1008643, 690201382.2004443, 690201382.3009053, 690201382.4004704, 690201382.5008882, 690201382.6009352, 690201382.7011213, 690201382.8006132, 690201382.9009142, 690201383.0005112, 690201383.1009102, 690201383.2005081, 690201383.3010123, 690201383.4005923, 690201383.5009692, 690201383.6004891, 690201383.7008853, 690201383.8005042, 690201383.9009511, 690201384.0005193, 690201384.1009772, 690201384.2006862, 690201384.3010433, 690201384.4005322, 690201384.5009923, 690201384.6005883, 690201384.7010853, 690201384.8005362, 690201384.9010303, 690201385.0006411, 690201385.1010532, 690201385.2006001, 690201385.3010662, 690201385.4006102, 690201385.5010152, 690201385.6006303, 690201385.7010381, 690201385.8008661, 690201385.9011462, 690201386.0006802, 690201386.1010602, 690201386.2006671, 690201386.3011441, 690201386.4006581, 690201386.5010881, 690201386.6007452, 690201386.7011452, 690201386.8006532, 690201386.901147, 690201387.000686, 690201387.1011051, 690201387.200734, 690201387.3011972, 690201387.4007832, 690201387.5011872, 690201387.600747, 690201387.7011622, 690201387.8007251, 690201387.9011792, 690201388.0007602, 690201388.1012081, 690201388.2008182, 690201388.3012551, 690201388.4008032, 690201388.5012511, 690201388.600788, 690201388.701203, 690201388.800896, 690201388.9012221, 690201389.000851, 690201389.1012791, 690201389.200796, 690201389.301267], {'ck': ['/mro/kernels/ck/mro_sc_psp_211109_211115.bc'], 'ctx_ck_quality': 'reconstructed', 'lsk': ['/base/kernels/lsk/naif0012.tls'], 'sclk': ['/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc', '/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc']})
        ```

    === "C++"

        ```c++
        {{690201375.8001044,690201375.9005225,690201376.0001376,690201376.1005514,690201376.2003593,690201376.3007555,690201376.4001434,690201376.5005605,690201376.6001616,690201376.7006094,690201376.8001995,690201376.9005914,690201377.0002506,690201377.1006265,690201377.2001615,690201377.3006384,690201377.4002154,690201377.5006325,690201377.6001914,690201377.7006304,690201377.8002934,690201377.9007006,690201378.0002494,690201378.1006765,690201378.2002484,690201378.3007184,690201378.4002284,690201378.5006794,690201378.6003283,690201378.7007493,690201378.8002504,690201378.9007055,690201379.0002974,690201379.1006984,690201379.2002794,690201379.3007773,690201379.4004143,690201379.5007674,690201379.6002804,690201379.7012802,690201379.8006243,690201379.9007763,690201380.0003043,690201380.1007553,690201380.2004362,690201380.3008415,690201380.4003323,690201380.5007504,690201380.6003684,690201380.7007734,690201380.8003484,690201380.9007963,690201381.0004884,690201381.1008502,690201381.2003893,690201381.3008813,690201381.4004093,690201381.5008324,690201381.6003863,690201381.7008892,690201381.8004864,690201381.9009064,690201382.0004803,690201382.1008643,690201382.2004443,690201382.3009053,690201382.4004704,690201382.5008882,690201382.6009352,690201382.7011213,690201382.8006132,690201382.9009142,690201383.0005112,690201383.1009102,690201383.2005081,690201383.3010123,690201383.4005923,690201383.5009692,690201383.6004891,690201383.7008853,690201383.8005042,690201383.9009511,690201384.0005193,690201384.1009772,690201384.2006862,690201384.3010433,690201384.4005322,690201384.5009923,690201384.6005883,690201384.7010853,690201384.8005362,690201384.9010303,690201385.0006411,690201385.1010532,690201385.2006001,690201385.3010662,690201385.4006102,690201385.5010152,690201385.6006303,690201385.7010381,690201385.8008661,690201385.9011462,690201386.0006802,690201386.1010602,690201386.2006671,690201386.3011441,690201386.4006581,690201386.5010881,690201386.6007452,690201386.7011452,690201386.8006532,690201386.901147,690201387.000686,690201387.1011051,690201387.200734,690201387.3011972,690201387.4007832,690201387.5011872,690201387.600747,690201387.7011622,690201387.8007251,690201387.9011792,690201388.0007602,690201388.1012081,690201388.2008182,690201388.3012551,690201388.4008032,690201388.5012511,690201388.600788,690201388.701203,690201388.800896,690201388.9012221,690201389.000851,690201389.1012791,690201389.200796,690201389.301267},{"ck":["/mro/kernels/ck/mro_sc_psp_211109_211115.bc"],"ctx_ck_quality":"reconstructed","lsk":["/base/kernels/lsk/naif0012.tls"],"sclk":["/mro/kernels/sclk/MRO_SCLKSCET.00112.65536.tsc","/mro/kernels/sclk/MRO_SCLKSCET.00112.tsc"]}}
        ```

 
### Passing in a list of kernels

??? abstract "Parameter `kernelList` usage"

    === "REST"

        ```bash
        curl -GET "https://astrogeology.usgs.gov/apis/spiceql/latest/getTargetStates?ets=[690201375.8323615,690201389.2866975]&target=sun&observer=moon&frame=MOON_ME&abcorr=LT%2BS&mission=lroc&ckQualities=[reconstructed]&spkQualities=[reconstructed]&searchKernels=false&kernelList=[/moon/tspk/moon_pa_de421_1900-2050.bpc,/lro/tspk/de421.bsp,/base/pck/pck[0-9]{5}.tpc,/moon/pck/moon_080317.tf,/moon/pck/moon_assoc_me.tf]"
        ```

    === "Python"

        ```py
        pql.getTargetStates(
            ets=[690201375.8323615,690201389.2866975], 
            target="sun", 
            observer="moon", 
            frame="MOON_ME", 
            abcorr="LT+S", 
            mission="lroc", 
            ckQualities=["reconstructed"], 
            spkQualities=["reconstructed"], 
            useWeb=True, 
            searchKernels=False, 
            kernelList=[
                "/moon/tspk/moon_pa_de421_1900-2050.bpc",
                "/lro/tspk/de421.bsp",
                "/base/pck/pck[0-9]{5}.tpc",
                "/moon/pck/moon_080317.tf",
                "/moon/pck/moon_assoc_me.tf"
            ]
        )
        ```

    === "C++"

        ```c++
        std::vector<std::string> kernels_to_use = {"/moon/tspk/moon_pa_de421_1900-2050.bpc", "/lro/tspk/de421.bsp", "/base/pck/pck[0-9]{5}.tpc", "/moon/pck/moon_080317.tf", "/moon/pck/moon_assoc_me.tf"};
        auto [result, kernels] = SpiceQL::getTargetStates(etStartVec, "sun", "moon", "MOON_ME", "LT+S", "lroc", {"reconstructed"}, {"reconstructed"}, false, true, kernels_to_use);
        ```

    The `kernelList` is a list of kernel paths relative to your `ISISDATA`.


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

    Generating your database over a full `ISISDATA` area may take *a few hours*. We recommend targeting missions specific to your use case for a faster generation time. You can find acceptable mission names at https://astrogeology.usgs.gov/apis/spiceql/latest/ and under the [repo's db/ folder](https://github.com/DOI-USGS/SpiceQL/tree/main/SpiceQL/db) with the format being "<mission\>.json". Mission instrument names can be found in each "<mission\>.json" file as JSON keys. Supplemental names like planetary bodies can be found in the [db/base.json](https://github.com/DOI-USGS/SpiceQL/blob/main/SpiceQL/db/base.json) file as JSON keys.

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

