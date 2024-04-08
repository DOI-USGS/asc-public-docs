[comment]: <> (Originally translated from https://github.com/DOI-USGS/ISIS3/blob/dev/isis/src/docsys/documents/ControlNetworks/ControlNetworks.xml)

Introduction
------------

### Control Network

A Control Network in ISIS is a structure which holds a network of image correspondences, also known as tie points or control points, which identify common ground points across multiple images of the same body. A Control Network is made up of Control Points (the common tie point) and a Control Point has one or more Control Measures (measurements in image space of the common point in a particular image). There are two file formats for Control Networks in ISIS -- a binary google protocol buffer format and a human-readable pvl format. Both contain the same contents and information. This document describes the keywords present in the PVL format for convenience.

Control Network
---------------

This section describes the keywords associated with the main Control Network object.

          Object = ControlNetwork
          NetworkId    = ExampleNetwork1
          TargetName   = Template
          UserName     = aexample
          Created      = 2012-01-04T12:09:57
          LastModified = 2012-01-04T12:09:57
          Description  = "Example PvlV0005 ControlNetwork template."
          Version      = 5
        
| **Keyword** | **Required** | **Default** | **Description** | **Notes** |
|---|---|---|---|---|
| **NetworkId** |  Yes |  No Default |  A user defined single-word identifier assigned to the control network file.  |  Most programs should copy this from the input cnet with an option to change it if it is entered by the user. If more than one input cnet use the first cnet entered (i.e.,cnetmerge) |
| **TargetName** |  Yes |  "" |  The planetary body to which the control network file applies. This Target Name should appear in all cubes used in the control network. Possible example values are Moon, or Mars. |  Use Cases:  1. cnetmerge should use this to verify the control networks share the same target; 2. cnetadd should use this to verify the control network and images share the same target. |
| **UserName** |  No |  No Default |  Name of the user that created the control network file. |  |
| **CreateId** |  No |  Set automatically |  Initial creation date and time of control net file. Once this is set it should not be modified.  |  For cnetmerge retain the earliest of the input cnets. Report all input creation dates to the log file.  |
| **LastModified** |  No |  None |  Date and time on which the control net file was last modified. All programs which modify the contents of this network must set this keyword. |  |
| **Description** |  No  |  None  | Brief description of the control network file. This is free-form text normally supplied by the person running the application. |  |
| **Version** |  No |  Set to current version on output. |  The Version of the Control Network file. The most recent version is 5. |  |


Control Point
-------------

A control point is one or more measurements that identify the same feature or location in different images. This section contains the information describing a Control Point.

          Object = ControlPoint
            PointType                = "Fixed    # (Fixed, Constrained, Free)"
            PointId                  = I00826010RDR\_ex\_1\_ID
            ChooserName              = aexample
            DateTime                 = 2012-01-04T17:01:32
            EditLock                 = True
            Ignore                   = True
            AprioriXYZSource         = "User # (None, User, AverageOfMeasures, Reference, Basemap, BundleSolution)"
            AprioriXYZSourceFile     = /home/temp/xyzSource.cub
            AprioriRadiusSource      = "User   # (AverageOfMeasures, BundleSolution, Ellipsoid, DEM)"
            AprioriRadiusSourceFile  = /home/temp/radiusSource.cub

            # AprioriLatitude = 1.1 <degrees>
            AprioriX                 = 100 <meters>

            # AprioriLongitude = 2.2 <degrees>
            AprioriY                 = 100 <meters>

            # AprioriRadius = 3.3 <meters>
            AprioriZ                 = 100 <meters>
            AprioriCovarianceMatrix  = (1.1, 2.2, 3.3, 4.4, 5.5, 6.6)
            LatitudeConstrained      = True
            LongitudeConstrained     = True
            RadiusConstrained        = True

            # AdjustedLatitude = 1.1 <degrees>
            AdjustedX                = 100 <meters>

            # AdjustedLongitude = 2.2 <degrees>
            AdjustedY                = 100 <meters>

            # AdjustedRadius = 3.3 <meters>
            AdjustedZ                = 100 <meters>
            AdjustedCovarianceMatrix = (1.1, 2.2, 3.3, 4.4, 5.5, 6.6)
        

| **Keyword** | **Required** | **Default** | **Description** | **Notes** |
|---|---|---|----------------------------|---|
| **PointType** |  Yes |  No Default? |                               Fixed \- A Fixed point is a Control Point whose lat/lon is well                  established and should not be changed\. Some people will refer to this as a truth                  \(i\.e\., ground truth\)\.                 Constrained \- A Constrained point is a Control Point whose                  lat/lon/radius is somewhat established and should not be changed\.                 Free \- A Free point is a Control Point that identifies common                  measurements between two or more cubes\. While it could have a lat/lon, it is not                  necessarily correct and is subject to change\. This is the most common type of                  control point\. This point type floats freely in a bundle adjustment\.                           |               This type of control point is measured image to image\. Each measurement associated              with this point has a              line and sample coordinate indicating the location of this point on that image\. The              coordinates of this              type of control point are assumed to have a known accuracy\. The bundle adjustment will              constrain"Ground"              points accordingly\.              A fixed point can be identified in one or \* more cubes\. Historically this point was              called a "Ground" point\. |
| **PointId** |  Yes  |  No Default  |  String to identify an individual Control Point\. This is a required keyword for all              points and must be unique within a single Control Network\. This keyword is often              generated automatically by applications which create Control Points\. |
| **ChooserName** |  No |  No Default |  The name of the user who manually created a point or the name of the application              which automatically created a point\. | Use cases:                               When qnet is used to create a new point, qnet should set this to the                  user name\.                When autoseed creates points it should set this to "autoseed"\.                            |
| **DateTime** |  No  |  No Default  |  Indicates the date/time a ground Control Point's coordinate was last changed |
| **EditLock** |  No  |  False  |  Indicator to applications that edit the contents of Control Points that all              information about this point \(e\.g\. Latitude, Longitude, Radius\) should not be              modified\. This does not include adding or removing measurements or the contents of              existing measurements, as long as those measures are not locked\.             |  EditLock=True is 'trump'\.\.\.this includes the Ignore flag\.\.\.if an application needs              to set the Ignore=True, it cannot and will need to report the problem to the user\.                              IMPORTANT NOTE: Implicit EditLock of Reference measure if Point EditLock=True will not work\.              ControlMeasure cannot get to ControlPoint EditLock\. The Reference measure EditLock              must be set to True if the ControlPoint EditLock=True\.                              For applications such as              'cnetadd', when the control Point\-EditLock=TRUE, new measures can be still added to              the network\. But, if the AprioriXYZSource=AverageOfMeasures; the a priori xyz values              will remain unchanged because the Point\-EditLock=TRUE \(most likely not the              responsibility to a measure app like cnetadd anyway\)\. There might need to be a new app              that updates 'ControlPoint' Level information allowing the user to "unlock" points and              update a priori xyz values based on current state of measures\.  |
| **Ignore** |  No  |  False  |  Flag \(True/False\) to indicate whether this Control Point should be Ignored\. When a              point is ignored, no data within the point should be used by a program unless the              program is explicitly working with ignored points\.             |
| **AprioriXYZSource** |  No  |  None  |  Set to one of the values below:                 User \- The a priori coordinates for this point were entered by the user\.                AverageOfMeasures \- The a priori coordinates for this point were              calculated by averaging the coordinates for all measures \(e\.g\., Average lat/lon or              x/y/z for all measures\)\.                Reference \- The a priori coordinates for this point were obtained from              the camera associated with the Control Measure marked as "REFERENCE"\.                Basemap \- The a priori coordinates for this point were obtained from              either a controlled mosaic or a single projected image used for a priori coordinates\.                BundleSolution \- The a priori coordinates for this point were obtained              from a previous run of jigsaw\.                           |
| **AprioriXYZSourceFile** |  No  |  ""  |  A string containing the file name of the AprioriLatitude and AprioriLongitude              source\. This keyword will only be used if AprioriLatLonSource == Basemap\.             |  If the AprioriLatLonSource is set to "Reference" set this to the serial number of              the reference measurement\. If the AprioriCoordinateSourceFile is set to              the serial number of the reference measurement and the reference measurement is              modified then all a priori information should be updated\.  |
| **AprioriRadiusSource** |  No |  Doesn't exist in net |  Set to one of the values below:                 User \- The a priori radius was hand entered by the user\.                AverageOfMeasures \- The a priori radius was calculated as the average              radius for all measures\.                Ellipsoid \- The a priori radius was calculated using the Naif PCK body              radii\. The number of radii used depends on the IAU definition of the target body\.                DEM \- Digital Elevation Model used for a priori radius\.                BundleSolution \- Radius output from a previous run of jigsaw\.                           |
| **AprioriRadiusSourceFile** |  No |  "" |  A string containing the file name of the AprioriRadius source\.  If              AprioriiRadiusSource = Ellipsoid, this keyword will be set to the Naif PCK file\.               If AprioriRadiusSource = DEM, this keyword will be set to the file name of the DEM\.  |
| **AprioriX** |  No |  False  |  Internal storage of the '''initial''' position of the point on the target\. Always              stored in body fixed x,y,z coordinates\.             |
| **AprioriY** |  No |  False |  Internal storage of the '''initial''' position of the point on the target\. Always              stored in body fixed x,y,z coordinates\.             |
| **AprioriZ** |  No  |  False  |  Internal storage of the '''initial''' position of the point on the target\. Always              stored in body fixed x,y,z coordinates\.             |               When this information is presented to the person running an application, it should be              displayed in appropriate units\.                             If any a priori coordinate is present without a corresponding a priori sigma, it will              be ignored by bundle adjustment applications, and the a priori information for that              coordinate will be recomputed during the bundle adjustment\. Any a priori coordinate              with a valid value and a valid corresponding sigma, will be used as the a priori              coordinate value in the bundle adjustment as is and not recomputed\.                              For example, a tie              point can have a valid AprioriZ value entered and a valid AprioriSigmaZ without              either the X or Y coordinates set\. The bundle adjustment will compute AprioriX and              AprioriY values, and their corresponding sigmas, but use the AprioriZ and              AprioriSigmaZ from the control net\.                              Additionally the use of the a priori values in a              bundle adjustment is determined by the presence of the constraint flags              \(LatitudeConstrained, LongitudeConstrained, RadiusConstrained, XConstrained,              YConstrained, and ZConstrained\)\. If the constraint flag is true for a particular a              priori values the constraint will be applied during a bundle adjustment, however if              the constraint flag is false, the constraint will not be used in the bundle              adjustment\.              This allows individual a priori sigma values to be turned off and on without loosening              the values\.             |
| **AprioriSigmaX** |  No  |  None  |  Pre\-adjustment standard deviation of XXXXXXX\. An indicator of accuracy that may be              used in the weighting of the XXXXXX point coordinate in the bundle adjustment\. May              originate from a variety of sources; for example a base\-map, a previous bundle              adjustment, or from the assumed or estimated quality of a sensor measurement such as              GPS \(in the case of terrestrial mapping\) or lidar\. Or for other planets accuracy of              the MOLA solution\. Units are meters\.             |
| **AprioriSigmaY** |  No  |  None  |  Pre\-adjustment standard deviation of XXXXXXX\. An indicator of accuracy that may be              used in the weighting of the XXXXXX point coordinate in the bundle adjustment\. May              originate from a variety of sources; for example a base\-map, a previous bundle              adjustment, or from the assumed or estimated quality of a sensor measurement such as              GPS \(in the case of terrestrial mapping\) or lidar\. Or for other planets accuracy of              the MOLA solution\. Units are meters\.             |
| **AprioriSigmaZ** |  No  |  None  |  Pre\-adjustment standard deviation of XXXXXXX\. An indicator of accuracy that may be              used in the weighting of the XXXXXX point coordinate in the bundle adjustment\. May              originate from a variety of sources; for example a base\-map, a previous bundle              adjustment, or from the assumed or estimated quality of a sensor measurement such as              GPS \(in the case of terrestrial mapping\) or lidar\. Or for other planets accuracy of              the MOLA solution\. Units are meters\.             |
| **AprioriCovarianceMatrix** |  No  |  None |  The Sigmas are stored in the binary control net as an 6 element upper triangular              covariance matrix for accuracy\.              See the description under AprioriX, AprioriY, and AprioriZ\.             |
| **LatitudeConstrained ** |  No  |  False  |  Flag that indicates if the Latitude is constrained\.             |               For control nets with AprioriX, AprioriY, and AprioriZ, the default is false\.              Even it a point has both the coordinates and covariance matrix, the a priori              information will not be applied for any of the coordinates unless the appropriate              constraint flags are present\. For old and transitional nets, the default will depend              on the presence a valid value for the coordinate and its corresponding sigma\.             |
| **LongitudeConstrained** |  No  |  False |  Flag that indicates if the longitude is constrained\.             |
| **RadiusConstrained** |  No |  False |  Flag that indicates if the radius is constrained\.             |
| **AdjustedX** |  No  |  None |  Adjusted X coordinate of the Control Point location\. Units are decimal meters\.             | The adjusted coordinates stored in the binary control network will              always be \(X,Y,Z\) meters\. When this information is presented on a terminal window,              graphical display, or log file, these will be converted to a user chosen coordinate              system\. That system may be controlled by the application, user's preference or              something else\.  |
| **AdjustedY** |  No  |  None |  Adjusted Y coordinate of the Control Point location\. Units are decimal meters\.             |
| **AdjustedZ** |  No  |  None |  Adjusted Z coordinate of the Control Point location\. Units are decimal meters\.             |
| **AdjustedCovarianceMatrix** |  No  |  None |  A six element vector corresponding to the upper triangle; elements              \(0,0\), \(0,1\), \(0,2\), \(1,1\), \(1,2\), and \(2,2\); of the 3x3, symmetric              covariance matrix for the rectangular, adjusted ground point\.             |

      

Control Measure
---------------

A Control Measure is a measurement in image space (sample and line coordinates) of a point in one cube that has been associated with a Control Point and other overlapping image cubes. Each ControlMeasure group in a PVL-formatted Control Network contains all information concerning a control measurement. An example follows:

            Group = ControlMeasure
              SerialNumber       = Example/Measure/111.000
              MeasureType        = "Candidate   # (Candidate, Manual, RegisteredPixel, RegisteredSubPixel)"
              ChooserName        = aexample
              DateTime           = 2012-01-04T17:01:32
              EditLock           = True
              Ignore             = True
              Sample             = 180.0
              Line               = 270.0
              Diameter           = 10.0
              AprioriSample      = 50
              AprioriLine        = 50
              SampleSigma        = 10 <pixels>
              LineSigma          = 10 <pixels>
              SampleResidual     = 10 <pixels>
              LineResidual       = -10 <pixels>
              JigsawRejected     = Yes
              MinimumPixelZScore = -6.9339878963865
              MaximumPixelZScore = 7.8509687345151
              GoodnessOfFit      = 0.7774975693515
              Reference          = True
              End\_Group
        

| **Keyword** | **Required** | **Default** | **Description** | **Notes** |
|---|---|---|---|---|
| **SerialNumber** |  Yes  |  No Default  |  A serial number is a unique identifier for a cube\. This value is usually comprised              of a spacecraft name, instrument name, start time, and if needed, other identifying              label values from the cube\. Serial numbers are used within control networks in              conjunction with a cube list to associate cubes and control measures\.             |
| **MeasureType** |  No |  Candidate |                               Candidate \- This Control Measurement is considered a candidate \(i\.e\., the                  location is preliminary or not well know\)\.                Manual \- This Control Measurement was hand measured \(eg\. qnet\)\.                RegisteredPixel \- Automatically registered to whole pixel \(eg\. pointreg\)\.                RegisteredSubPixel \- Automatically registered to sub\-pixel \(eg\. pointreg,                  qnet\)\.                           | Applications such as Autoseed, cnetref should use this setting |
| **ChooserName** |  No  |  Omitted if not set | Indicates the name of the user or application that last changed this Control              Measure's coordinate\. | For qnet use the user name instead of "qnet" |
| **DateTime** |  No  |  Omitted if not set |  Indicates the date/time the Control Measure's line/sample coordinates were last              changed\.             |
| **EditLock** |  No |  False |  Indicates that the measure is not to be edited\. This includes the Ignore and              Reference flag for any measure\. | If the reference measure EditLock=False and the Point\-EditLock=TRUE, then the              reference measure is implicitly Editlock=TRUE\.              If any non\-reference measure is EditLock=True and the Reference measure              EditLock=False, this is an ERROR and the application needs to report to the user\.              There can be more than one measure with EditLock=True \(reference \+ any other              measures\)\.             |
| **Ignore** |  No |  False |  Flag \(True/False\) to indicate whether this Control Measure should be Ignored\. When              a measurement is ignored it should not be used by a program unless the program is              explicitly working with ignored measurements\.             |
| **Sample** |  No |  0\.0? |  Sample coordinate of the Control Measure within the cube\. The value of the keyword              is a floating point number\.             |
| **Line** |  No |  0\.0? |  Line coordinate of the Control Measure within the cube\. The value of the keyword is              a floating point number\.             |
| **Diameter** |  No |  0\.0 |  The diameter of the crater in meters, if the control measure is associated with a              crater\.             |
| **AprioriSample** |  No |  None |  The first identified sample coordinate of the measure by any application\. In this              initial state the a priori keyword values are the same as line/sample keyword values\.             | autoseed, cnetadd, qnet \(for manual movement\), cnetref \(with interest\),mat2cnet \-              set this to the new value\.              pointreg, qnet \(with sub\-pixel\), hijitreg, ALL autoreg apps \- leave this alone\. They              will use it to calculate the pixelshift in the log file  |
| **AprioriLine** |  No |  None |  The first identified line coordinate of the measure by any application\. In this              initial state the a priori keyword values are the same as line/sample keyword values\.             |
| **SampleSigma** |  No |  None |               Standard deviation of sample measurement\. An indicator of precision used in the              weighting of measurements in the bundle adjustment \(i\.e\. Jigsaw\)\. May be determined              from experience \(e\.g\., manual point measurement\) or perhaps estimated within an              automated point measurement technique \(e\.g\., ellipse fitting of crater edges, or              through the use of an interest operator\)\. Units are pixels\.             | Note that the computation of this value by ISIS automated point measurement methods              is yet to be determined\. See LINESIGMA |
| **LineSigma** |  No |  None | Standard deviation of line measurement\. An indicator of precision used in the              weighting of measurements in the bundle adjustment \(i\.e\. Jigsaw\)\. May be determined              from              experience \(e\.g\., manual point measurement\) or perhaps estimated within an automated              point measurement technique \(e\.g\., ellipse fitting of crater edges, or through the use              of an interest operator\)\. Units are pixels\.             |
| **SampleResidual** |  No |  None |  The difference between the 'estimated' sample measurement \(as determined at the end              of each iteration of the bundle adjustment\) and the original sample measurement\. Used              in the determination of outliers throughout the bundle\. Measurement residuals are used              upon convergence to compute the reference variance \(σ02\) which              in turn is used to scale the inverse of the normal equations matrix for error              propagation\. Units are pixels\.  | Make sure warp, translate, coreg type apps output a cnet and set these\. |                 LineResidual               |  No |  None |  The difference between the ''estimated'' line measurement \(as determined at the                end of each iteration of the bundle adjustment\) and the original sample measurement\.                Used in the determination of outliers throughout the bundle\. Measurement residuals                are used upon convergence to compute the reference variance \(σ02\)                which in turn is used to scale the inverse of the normal equations matrix for error                propagation\. Units are pixels\.  | See Sample Residual |
| **JigsawRejected** |  No |  False |  A flag indicating if this measure has been rejected by jigsaw\.               |
| **MinimumPixelZScore** |  No |  None |  Control measures store z\-scores in pairs\. A pair contains the z\-scores of the                minimum and maximum pixels in the pattern chip generated for the given measure                during point registration\. Each z\-score indicates how many standard deviations the                given pixel value is above or below the mean DN\. This is used when using                area\-based\-matching in ISIS\.               |
| **MaximumPixelZScore** |  No |  None |  Control measures store z\-scores in pairs\. A pair contains the z\-scores of the                minimum and maximum pixels in the pattern chip generated for the given measure                during point registration\. Each z\-score indicates how many standard deviations the                given pixel value is above or below the mean DN\. This is used when using                area\-based\-matching in ISIS\.               |
| **GoodnessOfFit** |  No |  None |  This measures how well the computed fit area matches the pattern area when using                applications like pointreg\.               |
| **Reference** |  No |  False\(?\) |  A flag indicating if this measure is the reference measure for its parent Control                Point\.               |                 The computation of this value by ISIS automated point measurement methods                is yet to be determined\. Eventually this should be defined before jigsaw runs such as                pointreg setting it based on how well the measurement coregistered\.  |


