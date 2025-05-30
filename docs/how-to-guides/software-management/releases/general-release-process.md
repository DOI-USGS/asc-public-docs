# Astro Software General Release Process

!!! info "ISIS has [its own release process :octicons-arrow-right-16:](isis-release-process.md)"

    The process below applies to most other Astro software (ALE, Plio, Knoten, USGSCSM), but not ISIS.

### 1. Update the Changelog 

Label any currently unreleased changes as part of the new release. 

### 2. Add new entry to code.json 

Update `code.json` by adding a new entry with the new version number and the date last modified.

### 3. Update Version 

Depending on the software, the version must be updated in one or more of:

- `setup.py`
- `CMakeLists.txt`
- `recipe/meta.yaml`

### 4. Submit a Pull Request

Submit a pull request with the changes from steps 1-3.

### 5. Create a Github Release 

Once your pull request as been approved and merged, draft a new github release. Tag the release with the new version. Name the release with the version number and include the changelog information in the description.

### 6. Merge PR to conda-forge feedstock

Within about 24 hours, a PR to the conda-forge feedstock for the software will be automatically created.  Merge that PR to complete the release on conda-forge.

Feedstocks for select Astro software:

[[ALE](https://github.com/conda-forge/ale-feedstock/pulls)] 
[[Plio](https://github.com/conda-forge/plio-feedstock/pulls)] 
[[Knoten](https://github.com/conda-forge/knoten-feedstock/pulls)] 
[[USGSCSM](https://github.com/conda-forge/usgscsm-feedstock/pulls)]

-----

!!! success "Release Complete"