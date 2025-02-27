
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rnaseq.lf.tgfb.mcti

<!-- badges: start -->
<!-- badges: end -->

This package is a repository for lung fibroblast RNA-seq data obtained
from cells treated with TGFβ in combination with lactate transport
inhibitors.

## Installation

You can install this package from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("oldhamlab/rnaseq.lf.tgfb.mcti")
```

## Experiment

Lung fibroblasts were seeded at a density of 250,000 cells per well in
35 mm dishes. The following day, they were serum starved for 24 h prior
to treatment with TGFβ (2 ng/mL) in combination with MCT1 inhibitor
AZD3965 (100 nM), MCT4 inhibitor VB124 (10 μM), or both inhibitors
combined. DMSO (0.1%) was the vehicle control. Cells were incubated for
48 h prior to harvesting RNA. RNA was purified using the Qiagen
mini-prep kit and sent to BGI Genomics for library preparation and
sequencing. The samples were analyzed using their DNBSEQ platform with
100 bp paired end sequencing with greater than 20 M clean reads per
sample. All samples pass quality control and mapping checks. Reads were
aligned to transcript sequences from GENCODE release 44 using `salmon`.
Processing details are outlined in the `data-raw` folder of the package
source. The cleaned sequences will be available from the NIH short read
archive (SRA) as project number PRJNA1011992. The data are available as
a `SummarizedExperiment` object `se`.

In a subsequent experiment, lung fibroblasts were seeded at a density of
250,000 cells per well in 35 mm dishes. The following day, they were
serum starved for 24 h prior to treatment with TGFβ (2 ng/mL) in
combination with MCT4 inhibitor VB253 (10 μM). DMSO (0.1%) was the
vehicle control. Cells were incubated for 48 h prior to harvesting RNA.
RNA was purified using the Qiagen mini-prep kit and sent to Innomics for
library preparation and sequencing. The samples were analyzed using
their DNBSEQ platform with 150 bp paired end sequencing with greater
than 20 M clean reads per sample. All samples pass quality control and
mapping checks. Reads were aligned to transcript sequences from GENCODE
release 47 using `salmon`. Processing details are outlined in the
`data-raw` folder of the package source. The cleaned sequences will be
available from the NIH short read archive (SRA) as project number
PRJNA1011992. The data are available as a `SummarizedExperiment` object
`se_vb253`.
