---
hide:
  - navigation
  - toc
---

# Where to Look 

If looking for something specific, you can use the search function.

These docs use a simple system of defining software documentation in four categories based on the composition and goal of a particular piece of documentation: 

<div class="grid cards" markdown>

-   **[:material-clock-fast: Getting Started](getting-started/index.md)**
    
    -----
    
    First stop for learning about USGS Astrogeology's software: ISIS, the CSM Stack (ALE, Knoten), and SpiceQL.

-   **[:material-check-all: How-To Guides](how-to-guides/index.md)**

    -----

    Examples on how-to complete common software tasks; for intermediate to advanced users who want examples on how to accomplish a particular task.

-   **[:material-text-long: Concepts](concepts/index.md)**

    -----

    Write-ups that define and explain concepts that apply to our software; this is for anyone who wants a better understanding of particular higher-level concepts.

-   **[:material-book-open-variant-outline: Software Manuals](manuals/index.md)**

    -----

    Links to in-depth software manuals; contains in-depth references to a particular software project's apps and APIs.

</div>


## Documentation System 

We use these four categories to cover the range of potential docs, while clarifying to authors and readers for what kind of documentation goes where. 

|                 | Getting Started Tutorials       | How-Tos                        | Concepts                   | Manuals                                               |
|-----------------|-----------------------|--------------------------------|----------------------------|-------------------------------------------------------|
| **Oriented To**     | Learning              | Achieving a Goal               | Understanding              | Referencing                                           |
| **Composed As**     | Step-by-Step Jupyter or Similar Tutorial | General Purpose Guide          | Written Summary            | Generated Sphinx/Doxygen Site                         |
| **Has the Goal of** | Enabling Beginners    | Showing How To Solve A Problem | Give Detailed Written Explanations | Give Dry Descriptions of Libraries, Services and Apps |
| **Example**  | Jupyter notebook with toy data on how to ingest and project images | A breakdown of quirks working with Themis Images  |   Write-up on how ISIS defines projections | ISIS library Doxygen reference |
 
This website structure borrows from the [Divio documentation system](https://documentation.divio.com/), except adapted to more specifically adhere to how our software is already structured, renamed the categories to be more specific, and have more focus on the composition (or mode of writing) of the docs to reduce ambiguity. One can't expect any categorical structure for software documentation to be orthogonal to each other. There will always exist some degree of overlap between categories as the quantity of documentation grows. Documentation in one category can easily have overlapping information with those in others. However, composition of the doc (e.g., Jupyter notebook with an explicit starting and end point, short how-to guide with code examples but ambiguous starting point and end point, written explanation without code, doxygen API reference) is less ambiguous than whether your docs can be considered a guide or a tutorial.    

## Contributing New Docs and Submitting Issues 

Before you consider contributing new documentation, ask yourself what category it belongs in. [Getting-started tutorial](getting-started/index.md), [how-to guide](how-to-guides/index.md), [concepts write-up](concepts/index.md), or a [software manual](manuals/index.md). The page for each category has a more in-depth explanation of what each category entails. Contributors can also reference the above table for a TLDR. New contributions need a merge request (MR) into the website's [git repository](https://code.usgs.gov/astrogeology/asc-public-docs) and go through a review by other contributors before it can get merged and deployed. 

Regarding software manuals, issues or contributions should be addressed to the repository for that specific project. The software manuals should have links to their repositories. 

You can submit any issues (e.g., addressing grammar errors, factual inacuracies) and find more info on how to contribute new docs through the site's [git repository](https://github.com/DOI-USGS/asc-public-docs.git). If you find an issue somewhere in the repo, we strongly encourage users to also submit a change to the git repository to be reviewed, merged, and deployed. 

