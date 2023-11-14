
# ISIS App Testing Cookbook 


### Main.cpp Templates 

#### Minimum 

This is generally used when no logs are printed and special help GUI functionality is needed.
```C++
#include "Isis.h"

#include "Application.h"
#include "app_func.h" # replace with your new header

using namespace Isis;

void IsisMain() {
  UserInterface &ui = Application::GetUserInterface();
  app_func(ui);
}
```

#### Application with Logs 

When the application expects to print PVL logs to standard output. Most common case. 

```C++
#include "Isis.h"

#include "Application.h"
#include "Pvl.h"
#include "app_func.h" # replace with your new header

using namespace Isis;

void IsisMain() {
  UserInterface &ui = Application::GetUserInterface();
  Pvl appLog;
  try {
    app_func(ui, &appLog);
  }
  catch (...) {
    for (auto grpIt = appLog.beginGroup(); grpIt!= appLog.endGroup(); grpIt++) {
      Application::Log(*grpIt);
    }
    throw;
  }
 
  for (auto grpIt = appLog.beginGroup(); grpIt!= appLog.endGroup(); grpIt++) {
    Application::Log(*grpIt);
  }
}
```
#### Application with GuiLogs 

Logs that are only to be printed to the GUI command line in interactive mode. 

```C++
#include "Isis.h"

#include "Application.h"
#include "SessionLog.h"
#include "app_func.h" # replace with your new header

using namespace Isis;

void IsisMain() {
  UserInterface &ui = Application::GetUserInterface();
  Pvl appLog;
  
  app_func(ui);
  
  // in this case, output data are in a "Results" group.
  PvlGroup results = appLog.findGroup("Results");
  if( ui.WasEntered("TO") && ui.IsInteractive() ) {
    Application::GuiLog(results);
  }
  
  SessionLog::TheLog().AddResults(results);
}
```

#### Application with GUIHELPERS

Some apps require a map with specialized GUIHELPERS, these are GUI tools and shouldn't be co-located with the app function. 

```C++
#define GUIHELPERS
#include "Isis.h"

#include "Application.h"
#include "app_func.h" // replace with your new header

using namespace Isis;
using namespace std;

void helper();

// this map and function definitions are ripped directly from the old main.cpp
map <QString, void *> GuiHelpers() {
  map <QString, void *> helper;
  helper ["Helper"] = (void *) helper;  
  return helper;
}

void IsisMain() {   // this may change depending on whether logs are needed or not
  UserInterface &ui = Application::GetUserInterface();
  app_func(ui);
}

void helper() {
	// whatever
}
```

### Application.h Template 

This almost never changes between applications. 
```C++
#ifndef app_name_h // Change this to your app name in all lower case suffixed with _h (e.g. campt_h, cam2map_h etc.)
#define app_name_h

#include "Cube.h"
#include "UserInterface.h"

namespace Isis{
  extern void app_func(Cube *cube, UserInterface &ui, Pvl *log=nullptr);
  extern void app_func(UserInterface &ui, Pvl *log=nullptr);
}

#endif
```

### GTEST Templates 

```C++

#include "Fixtures.h"
#include "Pvl.h"
#include "PvlGroup.h"
#include "TestUtilities.h"

#include "app.h"

#include "gtest/gtest.h"

using namespace Isis;

static QString APP_XML = FileName("$ISISROOT/bin/xml/app.xml").expanded();

TEST_F(SomeFixture, FunctionalTestAppName) {
  // tempDir exists if the fixture subclasses TempTestingFiles, which most do
  QString outCubeFileName = tempDir.path() + "/outTemp.cub";
  QVector<QString> args = {"from="+ testCube->fileName(),  "to="+outCubeFileName};

  UserInterface options(APP_XML, args);
  try {
    appfoo_func(options);
  }
  catch (IException &e) {
    FAIL() << "Unable to open image: " << e.what() << std::endl;
  }
  
  // Assert some stuff
}
```