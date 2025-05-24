# ISIS Release Schedule

## Release Types

ISIS has three types of releases:

- LTS
- Production
- Dev

ISIS LTS and Production releases get a major update every 12 months.

ISIS Dev releases are updated bi-weekly/continuously.

Minor and bugfix updates also flow to the Production release.

LTS channels receive only bugfixes between major releases.

| Version    | Supported | RC | Updates           | Versioning | MAJOR (breaking) | MINOR (feature) | PATCH (bugfix) |
|------------|-----------|----|-------------------|------------|------------------|-----------------|----------------|
| LTS        | 18 months | Y  | biweekly (bugfix) | semver     | N                | N               | Y              |
| Production | 12 months | Y  | biweekly (minor)? | semver     | N                | Y               | Y              |
| Dev        | 2 weeks   | N  | biweekly          | date-based | Y                | Y               | Y              |


!!! danger "TODO: Update Cadence"

    Which updates/cadences should be described as biweekly, continuous, or something else?

## Release Candidates

!!! danger "TODO: What goes through the RC process?"

    - only major updates to LTS/Production releases (once per year)?
    - bugfix updates to LTS (skips RC)?
    - minor and bugfix updates to Production (skips RC)?

### RC Feature Freeze

*summarize/port from previous doc*


!!! danger "TODO: Tags... Production vs. Latest Release"

    [Concerning these tags...](https://astrogeology.usgs.gov/docs/how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda/#downloading-isis)

    What does "Latest Release" mean?

    - same as "Production"?
    - does it include dev?
    - should there be a separate production tag?

## Release Schedule Calendar

*port from previous docs, or remove?*