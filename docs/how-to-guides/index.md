# How-To Guides

[comment]: <> (These cards are a good place to highlight specific docs with high value, or ones readers commonly want to see)

<div class="grid cards" markdown>

-   :octicons-download-24:{ .lg .middle } __Use our script to install ISIS__

    ---

    ```sh
    bash <(curl https://raw.githubusercontent.com/DOI-USGS/ISIS3/refs/heads/dev/isis/scripts/install_isis.sh)
    ```

    [:octicons-arrow-right-24: More on Installing ISIS](../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md)

-   :material-data-matrix-edit:{ .lg .middle } __Image Processing__

    ---

    Manipulate pixels, remove noise, and align multiple images together.

    [:octicons-arrow-right-24: Work on Images in ISIS](../how-to-guides/image-processing/index.md)

-   :octicons-code-square-24:{ .lg .middle } __ISIS Development Guides__

    ---

    Learn how to build, write code for, and contribute to ISIS.

    [:octicons-arrow-right-24: Develop in ISIS](../how-to-guides/isis-developer-guides/developing-isis3-with-cmake.md)

-   :octicons-comment-discussion-24:{ .lg .middle } __I have an Issue!__

    ---

    Learn how to report issues with ISIS and how the maintainers respond to issues.

    [:octicons-arrow-right-24: Report an Issue](../how-to-guides/software-management/guidelines-for-reporting-issues.md)

</div>

-----

How-to guides are much like recipes in a recipe book. Write how-to docs to solve specific problems quickly, sometimes copy-pastable. Think of how-to guides as preemptive StackOverflow-like problems.

[comment]: <> (This is a good place to mention any places for someone to start looking in. Highlight specific docs with high value or we identify readers commonly want to see)

Use the table of contents on the left to start browsing guides. Check out the above cards if you aren't sure where to start.  Use the search bar if you're looking for something specific.

-----

??? quote "Want to write a how-to guide?"

    When contributing documentation, consider what category it should should go in.  Docs in the **how-to guides** category should: 

    1. Solve practical problems for more experienced users
    1. Offer more ambiguous starting points; they should be reusable in many different contexts 
    1. Can be much shorter than getting-started docs
    1. Some examples:
        - How-to: generate an ISD via loads with specific kernels
        - How-to: get GEOJSON from ISIS footprints
        - Cookbook of common operations in a library

    On the other hand, docs in the **getting started** category detail specific tasks for users who may not have much experience; docs in the **concepts** category provide an understanding of a topic without necessarily going into detail on how to carry out specific tasks. 
 
    
