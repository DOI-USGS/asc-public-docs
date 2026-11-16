??? warning "LRO Coordinate Accuracy and Smithed Kernel Availability"

    In 2018, the Miniature Inertial Measurement Unit (MIMU) was turned off. 
    The lack of MIMU data can affect accuracy. 
    For the most accurate coordinates, use LRO images from before the 2018 MIMU shutoff. 
    See [Where Is That Crater? Best Practices for Obtaining Accurate Coordinates from LROC NAC Data](https://iopscience.iop.org/article/10.3847/PSJ/ad54c6).
    
    Smithed kernels are [produced manually by Intuitive Machines](https://github.com/DOI-USGS/ISIS3/issues/5944#issuecomment-5198810015), 
    and may not be available for the most recent images. 
    Reconstructed kernels can be used as a fallback.
    But, for the most accurate LRO data, using images from 2018 or earlier is recommended.

    ```sh title="Using Smithed vs Reconstructed Kernels"
    // This may fail:
    spiceinit from=<lro-recent-image.cub> SPKSMITHED=TRUE SPKRECON=FALSE 

    // Use reconstructed kernels as a fallback:
    spiceinit from=<lro-recent-image.cub> SPKSMITHED=TRUE SPKRECON=TRUE
    ```
