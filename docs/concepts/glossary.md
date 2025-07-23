
## A

### Adjusted
The term, Adjusted, refers to the output pixel coordinate or output geographic location within a control network. Applications such as pointreg or jigsaw report and update the "Adjusted" output pixel coordinate (pointreg) or geographic location (jigsaw) in the output control network. 
### Albedo
Reflectivity of a surface or particle. Commonly in I/F units for radiometrically calibrated data. 
### A Priori
The term, "A Priori", refers to the initial or original value of a pixel coordinate or geographic location within a control network. Applications such as pointreg or jigsaw refer to the a priori values for an input pixel coordinate (pointreg) or geographic location (jigsaw) in an input control network. 
### Azimuth
A clockwise angle from a point of origin to a point of interest. 

## B

### Band
A 3rd dimensional layer of pixels in an image, typically representing spectral information. The number of bands indicates the depth of an image in terms of these layers.
### Binning
Process of sacrificing resolution for noise removal, where pixels are grouped together and averaged out.
### Bit
Short for binary digit, which in a computer is the smallest unit of storage. Bits are either "0" or "1". 
### Bit Type
Refers to how many bits there are per single meaningful value in an image cube file. 
### Body Fixed Coordinate
A planetary coordinate system where the coordinates are not time varying. 
### Body-Fixed Coordinate System
A body-fixed coordinate system is used to determine positions and directions of objects and vectors with respect to a target body. The origin is at the center of mass for the target and the axes rotate and move through space with the body. These systems are non-inertial, meaning the velocity of the origin is non-constant. Many body-fixed coordinate systems, or reference frames, are defined in NAIF PCK files. 
### Byte
Short for binary term. A byte is a collection of computer bits. On most modern computers, a byte is a group of eight bits. Typically, computers handle and store information in binary (base-2), and a group of eight bits represents an eight digit binary number. 

## C

### Camera Coordinate System
A camera coordinate system is used to determine positions and directions of objects and vectors with respect to a sensor (i.e. camera). The origin is at the center of the sensor and the axes rotate and move through space with the sensor. These systems are non-inertial, meaning the velocity of the origin is non-constant. The location of the center of a spacecraft and its instruments at a given time are defined in NAIF SPK files. Generally, one or more frames are associated with a particular instrument. 
### Control Island
Ideally a control network will represent a single island of a list of overlapping images all tied together through a network of control points and image measures (Refer to Control Measures). 
### Control Measure
The sample and line pixel coordinate (measurement) within a single image cube that has been measured and associated with a Control Point and other overlapping image cubes. 
### Control Network
A network of Control Points. Within the ISIS environment, the control network file is binary file. The network contains multiple fields of information for control points and measures collected between any number of image cubes. 
### Control Point
One or more measurements (image coordinates) that identify the same feature or location in different overlapping images. 
### CT Position Bias
"Cross Track Position Bias" - a constant shift in the spacecraft's position perpendicular to the flight path
### CT Velocity Bias
"Cross Track Velocity Bias" - a time-dependent linear shift in the spacecraft's position perpendicular to the flight path
### Cube
A cube is a 3-dimensional image with axis: samples, lines, and bands. The physical dimensions of a cube are called the number of samples (NS), number of lines (NL), and number of bands (NB). 

## D

### Declination
Declination (Dec) is one of two angles of the North Pole of a target body as a function of time. 
### Detector Resolution
The ground distance in meters from the left edge to the right edge of a detector. If the lines and samples are not being summed and averaged, this value is equal to the pixel resolution. The formula for estimating this value works well if the image is taken near nadir, but the accuracy falls off rapidly the farther off-nadir the image is taken. For an estimate that handles off-nadir images with higher accuracy, one should use 
### Digital Number
(or DN) The numeric value of a single pixel in an image. The value can represent a measurement in various units, such as reflectance (I/F), radiance, elevation, or radius. Digital Numbers can be discrete integers or floating point values.
### DN
Digital Number. The numeric value of a single pixel in an image. The value can represent a measurement in various units, such as reflectance (I/F), radiance, elevation, or radius. Digital Numbers can be discrete integers or floating point values.

## E

### Elevation
The height above or below a fixed point on the surface of a body. 
### Ephemeris Time
Ephemeris Time (ET) as defined by NAIF (Toolkit used by ISIS), is the uniform scale represented by the independent variable in the differential equations that describe the motions of the planets, sun and moon. Ephemeris time is described as a count of ephemeris seconds past the ephemeris reference epoch (J2000). 
### Emission Angle
The emission angle (EMA) is the angle between the spacecraft and a vector drawn perpendicular to the planet's surface (surface normal). Using SPICE, ISIS applications compute this angle from the ellipsoid. Emission Angle is in degrees. The valid range is between 0 and 90. 
### Emissivity
A measure describing a substance's ability to absorb and radiate electromagnetic energy. 
### Equatorial Radius
The distance from the geometric center of an ellipsoid to its equator. 
### Euler Angles
All the NAIF orientation models use three Euler angles to describe body orientation. The Euler angles describe the orientation of the coordinate axes of the 'body equator and prime meridian' system with respect to the J2000 system. 

## F
### Focal Bias
An estimate of the error in the focal length of the camera.

## G

### Ground Azimuth
A clockwise angle between one reference point and another reference point. Each pixel location has a latitude and longitude associated with it (ground point). The only information required to calculate a ground azimuth is to form a spherical triangle from three points on the planet (ground point, North Pole, and point of interest). The point of interest is often the sub-spacecraft or sub-solar point. Spherical trigonometry is then used to calculate the angle. 

## H

### HIS
High Instrument Saturation. An instrument special pixel value set during the ingestion of the image data into ISIS. The sensor registered a value too high to be measured accurately (oversaturated).
### HRS
HRS [High Representation Saturation] is a representation special pixel value that is tracked and reported to the user. HRS is set when an ISIS application causes the output DN pixel to fall 'above' the possible range of valid values. 

## I 

### IAU
The International Astronomical Union 
### I/F
Irradiance/SolarFlux. Unit of DN values for a reference distance of target body from the Sun (5.2 AU). The valid values range between 0.0 and 1.0. 
### Incidence Angle
The incidence angle (INC) is the angle between the sun and the surface normal. ISIS applications use SPICE to compute this angle from the ellipsoid or the elevation model (e.g., local slopes) at every pixel. 
### IT Position Bias
"In Track Position Bias" - a constant shift in the spacecraft's position parallel to the flight path 
### IT Velocity Bias
"In Track Velocity Bias" - a time-dependent linear shift in the spacecraft's position parallel to the flight path

## J

### J2000 Coordinate System
The J2000 coordinate system (also known as EME2000) is based on the earth mean equator and dynamical equinox at midnight January 1, 2000. The origin is at the solar system barycenter. This system is inertial, since it does not rotate with respect to stars and the origin is not accelerating (i.e it has a constant velocity). This coordinate system is the root reference for NAIF's SPICE files and software. 

## K 
### Kappa Angle
An exterior orientation angle that describes the rotation around the y-axis of the camera.  Analogous to "pitch."

## L
### Latitude
Latitude represents a geographic position and is measured from the equator, with positive longitudes going North and negative values going South. 
### Latitude Type
Latitudes can be represented either in Planetographic or Planetocentric form. Both latitudes are equivalent on a sphere (i.e., the equatorial radius is equal to the polar radius); however they differ on an ellipsoid body (e.g., Mars, Earth). 
### Level0
Level0 is a standard cartographic processing phase that describes an image has been ingested into ISIS (PDS EDR) and will often have SPICE information loaded on the ISIS cube labels (spiceinit). Level0 image cubes are often the input to mission specific radiometric calibration applications if supported in ISIS. 
### Level1
Level1 is a standard cartographic processing phase that describes an image has been radiometrically calibrated (PDS CDR or the ISIS output of a mission specific calibration application) with SPICE information loaded on the ISIS cube labels. 
### Level2
Level2 is a standard cartographic processing phase that describes an image has been map projected (PDS RDR). The Level2 image cube labels contain Mapping keywords that describe the projection and all associated map characteristics. 
### Line
A row of pixels in an image, typically representing spatial information. The number of lines indicates the total height of an image in pixels. 
### Line Resolution
The ground distance (in meters) from the top edge to the bottom edge of a pixel. 
###  LIS
Low Instrument Saturation. An instrument special pixel value set during the ingestion of the image data into ISIS. The image sensor registered a value too low to be measured accurately (undersaturated).
### Local Emission Angle
The local emission angle is the angle between the spacecraft and a vector drawn perpendicular to the planet's surface (surface normal). 
### Local Incidence Angle
The local incidence angle is the angle between the sun and a vector drawn perpendicular to the planet's surface (surface normal). 
### Local Radius
The distance from a point on the surface of a body to its geometric center. 
### Local Solar Time
How high the sun is in the sky as seen from a particular site on the surface of a planet. The local solar time at a site on a body is the angular difference between the planetocentric longitude of the site and the planetocentric longitude of the Sun as seen from the center of the body. 
### Longitude
Longitude represents a geographic position and is measured from a specified Prime Meridian (default is IAU) for the target body. 
### Longitude Direction
Longitude direction of a target body indicates whether longitude increases (positive) to the east or the west. 
### Longitude Domain
Longitude Domain specifies how longitudes should be interpreted and reported for a target body. 
### Look Direction
The look direction is the direction that the instrument is pointing. In ISIS, it is represented as a mathematical unit vector. For images that have a body (i.e. not star fields), this vector is parallel to the line from the sensor to the observed point on the surface of the target. The look direction can be represented in any of several coordinate systems, including: Body-fixed coordinate system, Camera coordinate system, J2000 coordinate system. 
### LRS
LRS [Low Representation Saturation] is a representation special pixel value that is tracked and reported to the user. LRS is set when an ISIS application causes the output DN pixel to fall 'below' the possible range of valid values. 

## M

### MAP
A representation of a three dimensional target such as a sphere, ellipsoid or an irregular shaped body onto a plane 
### Map Projection
A map projection is an algorithm or equation for mapping a three dimensional coordinate (latitude, longitude, radius) into a two dimensional coordinate plane (x,y). 

## N
### NAIF
Navigation and Ancillary Information Facility. 
### North Azimuth
A clockwise angle from a point of origin to true North. 
### NULL
NULL is a Special Pixel value that is tracked and reported to the user. NULL represents "No Data". NULL is set in all 8, 16, 32-bit type image data. 

## O

### Oblique Detector Resolution
This provides an improved estimate to the standard detector resolution when the image is taken at an oblique angle. In Figure 1A below, an image of the Dufay X crater that was taken near nadir is displayed. Figure 1B is a color map showing the relative difference between the oblique detector resolution, and the original detector resolution as a function of the emission angle. For small emission angles (near nadir) the relative difference between the two estimates is very small. For larger emission angles (off-nadir), the relative difference between the two estimates increases rapidly. Figure 2A is an image of the Carlini crater group taken at an oblique angle. Figure 2B is a color plot of the relative difference between the two estimates showing a minimum of approximately 120% when the emission angles off-nadir are in the range 64-75 degrees. The traditional approximation is obviously not adequate for a case such as this, and the oblique detector resolution should be used.
### Oblique Line Resolution
The ground distance (in meters) from the top edge to the bottom edge of a pixel. This value is based on the oblique detector resolution estimate, rather than the detector resolution and is more accurate (particularly for off-nadir images).
### Oblique Pixel Resolution
The ground distance (in meters) from the left edge to the right edge of a pixel. This value is based on the oblique detector resolution estimate, rather than the detector resolution and is more accurate (particularly for off-nadir images).
### Oblique Sample Resolution
The ground distance (in meters) from the left edge to the right edge of a pixel. This value is based on the oblique detector resolution estimate, rather than the detector resolution and is more accurate (particularly for off-nadir images).
### Off Nadir Angle
From the spacecraft, the Off Nadir is the angle between the nadir vector (subspacecraft vector) and the look vector. Every pixel in the image will result in a different Off Nadir Angle. 
### Omega Angle
An exterior orientation angle that describes the rotation around the z-axis of the camera.  Analogous to "yaw."


## P

### Phase Angle
The phase angle is the angle between the sun and the spacecraft at a point on the surface. ISIS applications will use SPICE to compute this angle from the ellipsoid or the elevation model (e.g., local slopes) at every pixel. 
### Phi Angle
An exterior orientation angle that describes the rotation around the x-axis of the camera.  Analogous to "roll."
### Pixel Resolution
The ground distance in meters from the left edge to the right edge of a pixel. 
### Planetary Data System
The Planetary Data System (PDS) is an archive of scientific data acquired from NASA planetary missions, astronomical observations, and laboratory measurements. By developing standards for data and archive formats and architectures for use within the archive, the PDS ensures long-term access and usability of NASA planetary data. 
### Planetocentric Latitude
Planetocentric Latitude is the angle between the equatorial plane and a line from the center of the body. 
### Planetographic Latitude
Planetographic Latitude is the angle between the equatorial plane and a line that is normal (perpendicular) to the surface body. 
### Polar Radius
The distance from the geometric center of an ellipsoid to either of its poles. 
### Polygon Thickness
The thickness of a polygon is defined as follows: 
### Positive East Longitude
The reported longitude values for a target body increase positive to the East. 
### Positive West Longitude
The reported longitude values for a target body increase positive to the West.
### Predicted 
"Predicted" kernels are NAIF SPICE kernels that are created during the planning phase of a mission. These contain expected trajectories, but may or may not be close to the actual trajectories like recontructed or smithed kernels are. 
### Prime Meridian
Prime Meridian (W) location is the third Euler angle which is expressed as a rotation about the North Pole as a function of time. The reference frame is J2000. 
### Projection X
Projection X is the x-coordinate (Easting) for a point on a geographic Cartesian coordinate system 
### Projection Y
Projection Y is the y-coordinate (Northing) for a point on a geographic Cartesian coordinate system 
### PVL
Parameter Value Language (PVL) is used extensively by ISIS as a standard keyword value type language for naming and expressing data values. PVL format in ISIS is compatible with syntax used by the Planetary Data System.

## Q

## R

### Radial Position Bias
A constant shift in the spacecraft's "vertical positioning," i.e. distance from the target
### Radial Velocity Bias
A time-dependent linear shift in the spacecraft's "vertical positioning," i.e. distance from the target
### Radiance
A measurement describing the amount of electromagnetic energy emitted from an area of a planet. 
### Radius
The distance (vector) value between the center of and a point on a circle, sphere, ellipse or ellipsoid. Refer to qview, camstats, or campt as examples of applications that report radius value at every image pixel location. 
### Reconstructed 
Kernels that are "Reconstructed" are NAIF SPICE kernels containing trajectories that were obtained during the spacecraft's mission phase. They are created using actual instrument telemetry data, hence the name "reconstructed".  
### Reference Measure
Reference Measure is a fundamental component of the control network. For every point within the network, there is always one and only one associated Reference Measure (Reference=True). The Reference Measure refers to a single image and it's pixel coordinate (measure) that best represents a control point location or feature. 
### Reflectance
The ratio of reflected energy to incoming energy. 
### Right Ascension
Right Ascension (RA) is one of two angles of the North Pole of a target body as a function of time. 



## S
### Sample
A column of pixels in an image, typically representing spatial information. The number of samples indicates the total width of an image in pixels. 
### Sample Resolution
The ground distance (in meters) from the left edgedocs/getting-started/using-spiceql/spiceql-cassini-tutorial.ipynb to the right edge of a pixel. 
### Scale
The map resolution measured in pixels per degree 
### Serial Number
A unique identifier constructed and assigned to each individual image within a control network. The serial number (SN) is constructed by most of the control network applications "in real time" from specific instrument keywords on the image labels (Instrument keywords are populated by mission specific ingestion applications). 
### Slant Distance
The distance from the spacecraft to the point of interest on the surface of the planet. 
### Slew Angle
From the spacecraft, the Slew is the angle between the boresight (i.e., center of framing camera) and the nadir vector (subspacecraft vector). The Slew angle will be a constant value across the image. 
### Smithed 
"Smithed" kernels are SPICE SPICE kernels that have gone through additional processing through a geoditic control process to reduce error and improve alignment. Smithed kernels are generally higher quality than Reconstructed kernels.   
### Solar Longitude
The Solar Longitude is the planetocentric longitude of the sun as seen from a point on a body. It is considered a seasonal angle. 
### Spacecraft Azimuth
A clockwise angle from a point of origin to the direction of the Spacecraft. 
### Spacecraft Position
The Spacecraft Position is the position of the spacecraft (x,y,z) in body-fixed rotating coordinate system. 
### Special Pixels
Special Pixels are defined to distinguish valid pixels from non-valid pixels. 
### SPICE
Spacecraft & Planetary ephemerides, Instrument C-matrix and Event kernels. SPICE refers to all the information required by ISIS in order to compute and map each image pixel onto a surface with reference to spacecraft position, sun position, instrument, and mission activities. ISIS uses software (ToolKit) supplied by the Navigation and Ancillary Information Facility (NAIF) for SPICE access and kernel management (Refer to spiceinit). 
### Subsolar Ground Azimuth
The Ground azimuth to the SubSolar point is obtained by taking true North (90 deg Latitude) and finding the clockwise angle to the subsolar latitude and longitude point. 
### SubSolar Latitude
The latitude of the subsolar point. 
### SubSolar Longitude
The longitude of the subsolar point. 
### SubSolar Point
The subsolar point is the target surface intercept of the line from the Sun and the target body's center. A triaxial ellipsoid is used to model the surface of the target body. 
### SubSpacecraft Ground Azimuth
The Ground azimuth to the SubSpacecraft point (where the look vector from the spacecraft intercepts the target body) is obtained by taking true North (90 deg Latitude) and finding the clockwise angle to the subspacecraft latitude and longitude point. 
### SubSpacecraft Latitude
The latitude value of the Subspacecraft Point 
### SubSpacecraft Longitude
The longitude value Subspacecraft Point 
### SubSpacecraft Point
The point on the surface of the target body which lies directly beneath the spacecraft. 
### Sun Azimuth
A clockwise angle from a point of origin to the direction of the Sun. 

## T

### Target Center Distance
The distance from the spacecraft to the target body center. 

## U

### Universal Coordinate
The ISIS default coordinate system 

### UTC
Coordinated Universal Time (UTC) is a system of time keeping that gives an understandable name to each instant of time. The names are formed from the calendar date and time of day. UTC format consists of year, month, day, hour, minutes and seconds. 

## V
## W
## X
## Y
## Z












































