# Deprecation

*Guidelines for the deprecation process.*

## 1. Deprecation Proposal
Those who wish to deprecate functionality should propose the deprecation via an issue on the software's repository of record.  This allows for discussion among the developers and the user community.  If a consensus is met that the functionality should be deprecated, then a deprecation warning should be written.

## 2. Deprecation Warning
A deprecation warning should be presented to the user whenever the deprecated functionality is used.  Check below for procedures for particular software.  There is not yet a standard procedure for deprecation across all Astro software.  Previous deprecation warnings have taken the form of a simple message printed via `cout`.  In addition to creating the deprecation warning message, the deprecated functionality should also be noted in the repository's changelog.  This warning should include a link to the issue that proposed the deprecation.

### Deprecation Warnings in ISIS

In ISIS:

- Deprecation warnings can be **enabled** (On), or **hidden** (Off), by the `ErrorFacility > ShowDeprecated` switch in the [IsisPreferences](../../concepts/isis-fundamentals/preference-dictionary.md) file.
    - This preference setting must be checked before printing a deprecation warning.
- Deprecation warnings are printed to `std::cerr`.


```cpp
#include "Preference.h"
// ...
void MyIsisObject::deprecatedMethod() {
    
    if (Preference::Preferences().getShowDeprecatedPref()) {
        QString msg = "This function (MyIsisObject::deprecatedMethod) will be deprecated "
                      "in ISIS [version], in favor of someIsisObject::replacementMethod.";

        std::cerr << msg << std::endl;
    }

// The rest of the method
};
```

## 3. Removal of Deprecated Functionality
No less than 6 months after the release that includes the deprecation notice, a commit containing the removal of the deprecated functionality should be PR'd into the development branch.  This change should also be captured in the changelog.