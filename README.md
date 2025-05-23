[![Static Badge](https://img.shields.io/badge/docs-USGS%20Astro-blue?style=flat-square&link=https%3A%2F%2Fastrogeology.usgs.gov%2Fdocs%2F)](https://astrogeology.usgs.gov/docs/)

## Getting started

### Cloning and Rendering the Docs Locally

```bash
# 1. Create a fork of the repository (the fork button is on the upper right corner on GitHub)

# 2. Clone the repository to your local machine, replace <fork url> with your own fork.   
git clone <fork url>
cd asc-public-docs/

# 3. Create a branch to track your work
git checkout -b your-branch-name 

# 4. install dependencies 
pip install -r requirements.txt

# 5. Make your changes to the code
# See "Adding Your Files" in the readme for details
# ...

# 6. Preview your changes, in the root of the repo run
mkdocs serve
```

To contribute changes back in: 

```bash
# 1. push changes back into your fork
git push origin your-branch-name

# Create a PR on this repository 
```

### Adding Your Files

> See [mkdocs material docs](https://squidfunk.github.io/mkdocs-material/getting-started/) for information on how to work with mkdoc's material theme and it's features. 

1. Determine what category your docs belong to by reading [the summary on the README](#understanding-the-doc-system). 
2. Write your either in Markdown or as a Jupyter notebook and add it under the directory for that category. 
3. Update `mkdocs.yml`, add a new file somewhere appropriate under `nav:` 
4. Run `mkdocs serve` to check if your file(s) rendered correctly.

### Getting Your Changes Reviewed

1. On the merge requests tab of the repository in GitLab, you will see a "New merge request" button. Click on it.
1. Select your branch (feature/your-feature-branch) from the Source branch dropdown.
1. Specify the target branch (e.g., master) in the Target branch field.
1. Fill in the necessary information about your changes, including a descriptive title and a description of what your MR proposes.
1. Submit the merge request.
1. Assign reviewers if there isn't any traction for your MR by adding them as reviewers or pinging them in the MR.
1. Address any feedback or comments provided by the reviewers.
1. Once all the reviewers have approved your changes, one of the maintainers will merge your MR into the main branch.
1. The continuous deployment system should automatically deploy your new changes. 
1. Celebrate your contribution! :tada:

## Understanding The Doc System

Contributors should consider writing new docs under one of our four categories:
 
1. Getting Started Tutorials
1. How-To Guides 
1. Concepts 
1. Software Manuals

We use these four categories to cover the range of potential docs while clarifying to authors and readers for what kind of documentation goes where. 

|                 | Getting Started       | How-Tos                        | Concepts                   | Manuals                                               |
|-----------------|-----------------------|--------------------------------|----------------------------|-------------------------------------------------------|
| **Oriented To**     | Learning              | Achieving a Goal               | Understanding              | Referencing                                           |
| **Composed As**     | Step-by-Step Jupyter or Similar Tutorial | General Purpose Guide          | Written Summary            | Generated Sphinx/Doxygen Site                         |
| **Has the Goal of** | Enabling Beginners    | Showing How To Solve A Problem | Give Detailed Written Explanations | Give Dry Descriptions of Libraries, Services and Apps |
| **Example**  | Jupyter notebook with toy data on how to ingest and project images | A breakdown of quirks working with Themis Images  |   Write-up on how ISIS defines projections | ISIS library Doxygen reference |
 
This website structure borrows from the [Divio documentation system](https://documentation.divio.com/), except adapted to more specifically adhere to how our software is already structured, renamed the categories to be more specific, and have more focus on the composition (or mode of writing) of the docs to reduce ambiguity. One can't expect any categorical structure for software documentation to be orthogonal to each other. There will always exist some degree of overlap between categories as the quantity of documentation grows. Documentation in one category can easily have overlapping information with those in others. However, composition of the doc (e.g., jupyter notebook with an explicit starting and end point, short how-to guide with code examples but ambiguous starting point and end point, written explanation without code, doxygen API reference) is less ambiguous that whether or not your docs can be considered a guide or a tutorial.    


### Getting Started Tutorials

These are longer "learn by doing" exercises that users can follow to learn some extended process using the libraries. These should have the user execute code or run commands from the library to complete a task.

Good getting started docs should: 

1. Have a clear and specific goal
1. Can be followed verbatim by the user
    * Include software versions used when creating the tutorial
   * Use Jupyter notebooks when possible 
    * Avoid dead data links; try using data generated by the tutorial or include data relative to the repo
1. Make sure users see results immediately 
    * Data should not be so large it takes a long time to download or process.
1. Include minimum explanation; the focus is on "learning by doing"
1. Focus on the steps required to complete the goal. 

Concrete things your tutorial needs: 

- If your tutorial requires installing software, list what software and their versions and clear instructions on how to install them. Feel free to point to other points of the doc that already have boilerplate info like "Go here to read on how to set up a custom ISISPreferences file". 
- If your tutorial has data, use generative data or data that is in the repo. Avoid external data dependencies. Before data is committed into the repo, check if [existing data can be reused](./data/). If new data needs to be committed, make sure it is small so as not to increase the data burden.   
- Make sure to make the lesson clear in the title. Also, make it clear in the tutorial with something like "Lessons learned in this tutorial:". 


Examples: 
* Getting Started: ISIS image ingestion to map projected image, ingesting, bundling, and projecting an image list 
* Getting Started: Generating an ISD and CSM camera model
* Getting Started: Generate a control network with an image matcher 

### How-to Guides 

How-to guides are much like recipes in a recipe book. Write how-to docs to solve specific problems quickly, sometimes copy-pastable. Think of how-to guides as preemptive StackOverflow-like problems.

Similar to getting started guides in that they explain to users how to perform some valuable tasks with the software, but distinct in that they:

1. Solve practical problems for more experienced users
1. Offer more ambiguous starting points; they should be reusable in many different contexts 
1. Can be much shorter than getting started docs

Examples: 
* How-to: Generate an ISD via loads with specific kernels
* How-to: Get GEOJSON from ISIS footprints

### Concepts 

Concept docs are understanding-oriented docs. The focus is on explaining a topic. These expand the user's understanding of a topic without elaborating on particulars of code while providing context or descriptions. Information from concept docs might be among other docs, but getting started docs, how-to guides, or software manuals can reference concept docs that go in-depth on the topic. 

Good concept docs have: 

1. A clear and specific topic of discussion   
1. Little to no instruction 
1. Context or descriptions of: 
    * Historical background of the software and/or why it exists
    * Engineering of a software tool or component thereof 
    * Concepts commonly found across software 

Examples:
* Dictionaries or Glossary of terms
* Explanation of what control networks are and why we use them
* History and explanation of ALE's architecture 
* Differences between CSM and ISIS camera models 

### Software Manuals 

Software manuals centered on the code of the library. These are generally links to the library's programmatically generated API docs. Think Sphinx docs and/or Doxygen-generated docs. 

Examples: 
* Programmatically Generated Python/C++ API docs from inline doc strings
* RESTful API docs from an OpenAPI spec file 
