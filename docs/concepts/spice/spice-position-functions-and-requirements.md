# Spice Functions and Requirements
This document outlines the critical components of the SpicePosition class. This will help guide our refactor efforts by defining the limitations imposed by the rest of the ISIS code base.

## Compute Position and Velocity
This is the core functionality of SpicePosition. It is a part of the stateful ISIS camera model, so when the position and velocity are computed at a time, all three are stored internally. There are three accessors for the stored values.

### Data sources
SpicePosition needs to be able to use several different data sources.

#### SPICE Kernels
SpicePosition is the part of ISIS that reads from SPKs. 99% of the time this only happens during spiceinit because it is immediately cached and saved to the cube file.

#### Position and Velocity Cache
This is the data source most often used by ISIS. The data is interpolated by either a linear method or a cubic hermite spline.

#### Polynomials
This is the data source used during and after bundle adjustment.

#### Combination of Cache and Polynomial
This is used for bundle adjustment of very jittery images. Mechanically, this is the sum of a low degree polynomial and a cubic hermite spline cache.
### Relevant public methods
* SetEphemerisTime(double et)
* EphemerisTime()
* Coordinate()
* Velocity()

## Create a Cache from SPICE Data for an Image

This is both a big part of regular ISIS usage and how the spice server works. The spice server creates the cache and then ships it back over the wire.

### Reducing Cache Size
For large push broom images, a data point for every line can be a huge amount of data to store and work with. So, SpicePosition must able to reduce the cache size based on a given tolerance.
### Relevant public methods
* LoadCache(double startTime, double endTime, int size)
* LoadCache(double time)
* ReloadCache()
* Memcache2HermiteCache(double tolerance)

## Write/Read Polynomial or Cached Data From/To a Cube
Currently this is performed via an ISIS Table object, but it could be a generic BLOB.
### Relevant public methods
* LoadCache(Table &table)
* ReloadCache(Table &table)
* Cache(const QString &tableName)
* LineCache(const QString &tableName)
* LoadHermiteCache(const QString &tableName)

## Fit Polynomial Coefficients over Cached Data
This is how the polynomial coefficients are initialized at the beginning of bundle adjustment.
### Relevant public methods
* SetPolynomial(const Source type)

## Provide Access to Polynomial Coefficients
The bundle adjustment needs access to these values in order to properly construct the normal equations.
### Relevant public methods
* GetPolynomial(std::vector<double>& XC, std::vector<double>& YC, std::vector<double>& ZC)

## Take Adjustments to Polynomial Coefficients
This is how the BundleAdjust applies its corrects each iteration.
### Relevant public methods
* SetPolynomial(const std::vector<double>& XC, const std::vector<double>& YC, const std::vector<double>& ZC, const Source type)

## Compute the Partial Derivatives with Respect to a Polynomial Coefficient
Mathematically these are something like d/db(at^2 + bt + c). These are needed for the bundle adjustment.
### Relevant public methods
* CoordinatePartial(SpicePosition::PartialType partialVar, int coeffIndex)
* VelocityPartial(SpicePosition::PartialType partialVar, int coeffIndex)


## Methods

### Time Bias (**Candidate For Removal**)
* GetTimeBias() const
    * Only used within `SpicePosition`! We could potentially eliminate this from the API, as it is only used within `SpicePosition`. 

### LightTime and Aberration Correction
* SetAberrationCorrection(const QString &correction)
    * Used by `SpacecraftPosition`, `Spice`, `gllssical/main`, `LoHighCamera`, `LoMediumCamera`, `Mariner10Camera`
* QString GetAberrationCorrection()
    * Not used anywhere (`SpacecraftPosition` has something similar and should probably use it but doesn't)
* GetLightTime()
    * Not used anywhere (`SpacecraftPosition` has something similar and should probably use it but doesn't)

### GetCenterCoordinate
* GetCenterCoordinate()
    * Used by `BundleObservation`
    * Gets the gets the mid point in time between the start and end of the cached position data, and returns that coordinate
    * Used to get the center position of the instrument when looking at a section of ephemeris data

### HasVelocity (Candidate For Removal)
* HasVelocity()
    * Not used, the private variable is getting accessed directly from within `SpicePosition`
    * Returns the private variable p_hasVelocity from a SpicePosition object
    * Doesn't provide any functionality at the moment

### IsCached
* IsCached()
    * Used by `Spice`
    * Checks if there is something stored within the cache
    * Used to determine whether or not to read/write from and to cache

### SetPolynomialDegree
* SetPolynomialDegree(int degree)
    * Used by `BundleObservation`
    * Sets the degree of the internal polynomial state
    * Used to set and change the polynomials degree, consequently expanding or reducing the polynomial if the polynomials have been "applied"(?)

### GetSource
* GetSource()
    * Used by `Spice`
    * Returns the private variable p_source from a `SpicePosition` object
    * Used to determine how the data in `SpicePosition` is stored

### Base Time and Time Scaling
* ComputeBaseTime()
    * Only used within `SpicePosition`
    * Computes the base time based on the private variable p_override
    * Adjust the p_basetime and p_timescale variables in SpicePosition when SetPolynomial is run or when memcache2hermitecache is run
* GetBaseTime()
    * Used in `BundleObservation`
    * Returns the private variable p_basetime
    * Used to get the current base time for fit equations
* SetOverrideBaseTime(double baseTime, double timeScale)
    * Used in `BundleObservation`
    * Sets the p_overrideBaseTime to the given baseTime, sets p_overrideTimeScale to the given time scale, and sets p_override to timeScale
    * Used in LoadCache to set the above variables if p_source is not a PolyFunction
* GetTimeScale()
    * Used in `BundleObservation`
    * Returns the private variable p_timeScale
    * Used to set a variable in `BundleObservation::initializeExteriorOrientation`

### DPolynomial 
* DPolynomial(const int coeffIndex)
    * Only used within `SpicePosition`
    * Takes the derivative of a polynomial in respect to a given coefficient index
    * Used to compute partial derivatives in `SpicePosition`

### Extrapolate
* Extrapolate(double timeEt)
    * Used in `SpkSegment`
    * Extrapolate position for a given time assuming a constant velocity (From doc string)
    * Used to extrapolate a new position based on a known position and assumed constant velocity

### HermiteCoordinate()
* HermiteCoordinate
    * Not used