# Movie Success Factors in the Film Industry (2000-2024)

### A CRISP-DM Analysis of Budget, Revenue, Genre, and Language

MAS8505 Resit Project — Newcastle University

**Name:** Kalyan Kankanala  
**Student ID:** 250551284  
**Course Code:** MAS8505 (Resit Project)

## Description

This project analyses a movie dataset covering 25 years of TMDb film data
(2000-2024), applying the CRISP-DM methodology across two iterative cycles
to identify the key factors driving movie commercial success and audience
reception. Cycle 1 explores global trends in revenue, ratings, and budget
over time. Cycle 2 investigates the influence of genre and language on
movie success in more depth.

The project is built as a [ProjectTemplate](http://projecttemplate.net)
R project, with dependency management handled by
[renv](https://rstudio.github.io/renv/).

The full analysis report, including all findings, tables and visualisations,
is available at `reports/movie_analysis_report.pdf` (generated from
`reports/movie_analysis_report.Rmd`).

## Directory Structure

```
MovieAnalysis/
├── MovieAnalysis.Rproj      # RStudio project file - open this to start
├── config/
│   └── global.dcf           # ProjectTemplate configuration (libraries, caching)
├── data/                    # Raw input data: movies_2000.csv ... movies_2024.csv
├── munge/                   # Data preprocessing scripts, run in order by load.project()
│   ├── 01-A-merge-data.R        # Merges all yearly CSVs into movies_raw
│   ├── 02-B-clean-data.R        # Cleans column names, types, removes duplicates
│   └── 03-C-derive-variables.R  # Cleans invalid values, derives profit/ROI/etc.
├── cache/                   # Auto-generated cached data (not tracked in git)
├── src/                     # Analysis scripts
│   ├── Analysis_function.R      # Shared helper functions
│   ├── Cycle1_Analysis.R        # CRISP-DM Cycle 1: global trends analysis
│   ├── Cycle2_Analysis.R        # CRISP-DM Cycle 2: genre & language analysis
│   └── Summary_Analysis.R       # Consolidates key findings, exports outputs
├── graphs/                  # Generated plots (01-12, numbered to match the report)
├── outputs/                 # Exported CSVs and key_findings.RData
├── reports/
│   ├── movie_analysis_report.Rmd   # Main report source
│   └── movie_analysis_report.pdf   # Knitted final report
├── renv.lock                # Locked package versions for reproducibility
├── GitLog.txt               # Full git commit history (git log output)
└── renv/                    # renv package management scaffolding
```

## Setup Instructions

1. **Clone or unzip this project** to your local machine.
2. **Open `MovieAnalysis.Rproj` in RStudio** (File -> Open Project, or
   double-click the file). Opening via the `.Rproj` file is important -
   it ensures `renv` activates automatically and the working directory
   is set correctly.
3. **Restore the exact package versions used in this project:**
   ```r
   renv::restore()
   ```
   This reads `renv.lock` and installs the specific package versions
   (tidyverse, lubridate, janitor, corrplot, and their dependencies)
   into an isolated project library, without affecting your other R projects.

## Execution Instructions

1. **Load the project** (reads config, loads packages, loads/munges data):
   ```r
   library(ProjectTemplate)
   load.project()
   ```
   On first run, or whenever `config/global.dcf` has `munging: TRUE`, this
   re-runs the full data pipeline (merge -> clean -> derive) on the raw CSVs
   in `data/`. Normally `munging` is set to `FALSE`, so this loads instantly
   from the cached, pre-processed `movies` dataset instead.

2. **Run the analysis scripts, in order:**
   ```r
   source("src/Analysis_function.R")
   source("src/Cycle1_Analysis.R")
   source("src/Cycle2_Analysis.R")
   source("src/Summary_Analysis.R")
   ```
   These generate the summary statistics, tables, and plots (saved to
   `graphs/`), and export the final CSVs and key findings (saved to
   `outputs/`).

3. **Knit the full report:**
   ```r
   rmarkdown::render("reports/movie_analysis_report.Rmd")
   ```
   This sources all four scripts above internally and produces
   `reports/movie_analysis_report.pdf`. This is the only step required to
   reproduce the report from scratch - simply open the `.Rmd` in RStudio
   and click **Knit**.

## Notes

- `data/` and `cache/` are intentionally excluded from git version control
  to keep the repository lightweight, but are included in the final
  submission zip. They are fully regenerable by running `load.project()`
  with `munging: TRUE` in `config/global.dcf`.
- All R commands above are run in the RStudio **Console**. Git commands
  (if working from the command line) should be run in the **Terminal**.
