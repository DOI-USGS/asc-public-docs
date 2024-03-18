*[Adjusted]: The term, Adjusted, refers to the output pixel coordinate or output geographic location within a control network. Applications such as pointreg or jigsaw report and update the "Adjusted" output pixel coordinate (pointreg) or geographic location (jigsaw) in the output control network. 
*[Band]: A 3rd dimensional layer of pixels in an image, typically representing spectral information. The number of bands indicates the depth of an image in terms of these layers. 
*[Bit]: Short for binary digit, which in a computer is the smallest unit of storage. Bits are either "0" or "1". 
*[Byte]: Short for binary term. A byte is a collection of computer bits. On most modern computers, a byte is a group of eight bits. Typically, computers handle and store information in binary (base-2), and a group of eight bits represents an eight digit binary number.
*[CSM]: Community Sensor Model. A standard for sensor models USGS uses for interoperability.
*[DN]: Digital Number. The numeric value of a single pixel in an image. The value can represent a measurement in various units, such as reflectance (I/F), radiance, elevation, or radius. Digital Numbers can be discrete integers or floating point values.
*[EMCAscript]: A standard for scripting languages. C++'s standard library uses the EMCAscript standard for regular expressions.  
*[SPICE]: Spacecraft & Planetary ephemerides, Instrument C-matrix and Event kernels. SPICE refers to all the information required by ISIS in order to compute and map each image pixel onto a surface with reference to spacecraft position, sun position, instrument, and mission activities. ISIS uses software (ToolKit) supplied by the Navigation and Ancillary Information Facility (NAIF) for SPICE access and kernel management (Refer to spiceinit). 
*[NAIF]: Navigation and Ancillary Information Facility. They engineered and support the SPICE observation geometry information system. 
*[NULL]: NULL is a Special Pixel value that is tracked and reported to the user. NULL represents "No Data". NULL is set in all 8, 16, 32-bit type image data. 
*[LRS]: LRS [Low Representation Saturation] is a representation special pixel value that is tracked and reported to the user. LRS is set when an ISIS application causes the output DN pixel to fall 'below' the possible range of valid values. 
*[HRS]: HRS [High Representation Saturation] is a representation special pixel value that is tracked and reported to the user. HRS is set when an ISIS application causes the output DN pixel to fall 'above' the possible range of valid values. 
*[LIS]: LIS [Low Instrument Saturation] is an instrument special pixel value that is tracked and reported to the user. LIS is set during the ingestion of the image data into ISIS. The input image sensor acquired a value too low to be measured accurately. 
*[HIS]: HIS [High Instrument Saturation] is an instrument special pixel value that is tracked and reported to the user. HIS is set during the ingestion of the image data into ISIS. The input image sensor acquired a value too high to be measured accurately. 
*[Cube]: A cube is a 3-dimensional image with axis: samples, lines, and bands. The physical dimensions of a cube are called the number of samples (NS), number of lines (NL), and number of bands (NB). 
*[Line]: A row of pixels in an image, typically representing spatial information. The number of lines indicates the total height of an image in pixels. 
*[Sample]: A column of pixels in an image, typically representing spatial information. The number of samples indicates the total width of an image in pixels. 
*[Level0]: Level0 is a standard cartographic processing phase that describes an image has been ingested into ISIS (PDS EDR) and will often have SPICE information loaded on the ISIS cube labels (spiceinit). Level0 image cubes are often the input to mission specific radiometric calibration applications if supported in ISIS. 
*[Level1]: Level1 is a standard cartographic processing phase that describes an image has been radiometrically calibrated (PDS CDR or the ISIS output of a mission specific calibration application) with SPICE information loaded on the ISIS cube labels. 
*[Level2]: Level2 is a standard cartographic processing phase that describes an image has been map projected (PDS RDR). The Level2 image cube labels contain Mapping keywords that describe the projection and all associated map characteristics. 
*[Elevation]: The height above or below a fixed point on the surface of a body. 
*[Albedo]: Reflectivity of a surface or particle. Commonly in I/F units for radiometrically calibrated data. 
*[Emissivity]: A measure describing a substance's ability to absorb and radiate electromagnetic energy. 
*[Radiance]: A measurement describing the amount of electromagnetic energy emitted from an area of a planet. 
*[Reflectance]: The ratio of reflected energy to incoming energy. 
*[Radius]: The distance (vector) value between the center of and a point on a circle, sphere, ellipse or ellipsoid. Refer to qview, camstats, or campt as examples of applications that report radius value at every image pixel location. 
*[I/F]: Irradiance/SolarFlux. Unit of DN values for a reference distance of target body from the Sun (5.2 AU). The valid values range between 0.0 and 1.0. 
*[Azimuth]: A clockwise angle from a point of origin to a point of interest. 
*[Declination]: Declination (Dec) is one of two angles of the North Pole of a target body as a function of time. 
*[Latitude]: Latitude represents a geographic position and is measured from the equator, with positive longitudes going North and negative values going South. 
*[Longitude]: Longitude represents a geographic position and is measured from a specified Prime Meridian (default is IAU) for the target body. 
*[UTC]: Coordinated Universal Time (UTC) is a system of time keeping that gives an understandable name to each instant of time. The names are formed from the calendar date and time of day. UTC format consists of year, month, day, hour, minutes and seconds. 
*[PVL]: Parameter Value Language (PVL) is used extensively by ISIS as a standard keyword value type language for naming and expressing data values. PVL format in ISIS is compatible with syntax used by the Planetary Data System. 
*[MAP]: A representation of a three dimensional target such as a sphere, ellipsoid or an irregular shaped body onto a plane 
*[IAU]: The International Astronomical Union 
*[Scale]: The map resolution measured in pixels per degree 
*[ISD]: Image Support Data. The interior and exterior orientation data used to instantiate a camera model.