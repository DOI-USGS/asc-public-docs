# ALE in Python - `load` and `loads`

<div class="grid cards" markdown>

-   [:octicons-arrow-left-24: ALE SPICE Data Setup](../../getting-started/using-ale/ale-naif-spice-data-setup.md)

-   [:octicons-arrow-right-24: ALE on the Command Line](../../getting-started/using-ale/isd-generate.md)

</div>

*See [Getting Started with ALE](../../getting-started/using-ale/index.md) for an overview of ALE Installation, NAIF SPICE Data Setup, and other ALE Topics.*

## Basic Usage

The `ale.load` and `ale.loads` functions are
the main interface for generating ISDs. Simply pass them the path to your image
file/label and they will attempt to generate an ISD for it.

```py
import ale

image_label_path = "/path/to/my/image.lbl"
isd_string = ale.loads(image_label_path)
```

-----

More advanced usage can be seen in the CSM Stack Notebooks:

<div class="grid cards" markdown>

-   [:octicons-arrow-right-24: Instantiating a CSM Camera Model](../../getting-started/csm-stack/image-to-ground-tutorial.ipynb)

-   [:octicons-arrow-right-24: Knoten - Basic Camera Operations](../../getting-started/csm-stack/knoten-camera-tutorial.ipynb)

</div>
  
