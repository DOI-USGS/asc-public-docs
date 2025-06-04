# Use Web SpiceQL in ISIS and ALE

## ISIS

Update your *IsisPreferences* under `$CONDA_PREFIX` to enable the web SpiceQL feature.

```
Group = WebSpice
  UseWebSpice = "true"
EndGroup
```

!!! tip "spiceinit"
    The ISIS app *spiceinit* has two driver engines: ISIS and ALE. Setting `web=yes` will use the [old ISIS SPICE webserver](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/isis-data-area/#isis-spice-web-service). If your *IsisPreferences* has the web SpiceQL feature enabled, *spiceinit* will use SpiceQL via the ALE engine to load kernels.


## ALE

Set the `props` param to use web SpiceQL by setting the `web` property to `True`.

!!! example "Generate an ISD"
    ```py
    import ale

    ale.load("<path-to-lbl>.cub", props={"web": True}, formatter='ale', verbose=False, only_isis_spice=False, only_naif_spice=True)
    ```

??? info "For developers"
    Additional environment variables that can be set:  
    - `SPICEQL_REST_URL` - Point to a custom SpiceQL instance URL  
    - `ALESPICEQL_LOG_LEVEL` - Turn on debugging with `debug`
