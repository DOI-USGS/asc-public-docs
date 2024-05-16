A new ISIS3 class needs to have the following Doxygen tags filled out just above the class declaration, as in this example below:

```C++
   /**
    * @brief Add map templates to a project
    * Asks the user for a map template and copies it into the project.
    */
    class ImportMapTemplateWorkOrder : public WorkOrder {....
```
Sometimes, classes are declared inside the header files for other classes.  This happens a lot in the $ISISROOT/src/qisis/objs directory, where internal XmlHandler classes are defined to handle object serialization.
These classes need to be documented as well (as in this example from the ImageList header file):
