% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/se.R
\docType{data}
\name{se}
\alias{se}
\title{Summarized RNA-seq Data}
\format{
An object of class \code{RangedSummarizedExperiment} with 62266 rows and 32 columns.
}
\usage{
se
}
\description{
RNA was harvested from lung fibroblasts serum starved for 24 h prior to
treatment with TGFβ (2 ng/mL) in combination with MCT1 inhibitor AZD3965
(100 nM), MCT4 inhibitor VB124 (10 μM), or both. DMSO (0.1\%) was the vehicle
control. After 48 h of treatment, RNA was extracted using Qiagen RNeasy kit
and submitted for sequencing by BGI Genomics. The samples were analyzed using
their DNBSEQ platform with 100 bp paired-end sequencing with greater than 20
M clean reads per sample. All samples passed quality control and mapping
checks. Reads were aligned to transcript sequences from GENCODE release 44
using \code{salmon}. Processing details are outlined in the \code{data-raw} folder of
the package source. The cleaned sequences are available from the NIH short
read archive (SRA) as project number PRJNA1011992.
}
\details{
Phenotype data can be accessed with \code{colData(se)}:

\describe{
\item{names}{sample id}
\item{replicate}{biological replicate}
\item{condition}{
\code{Ctl} = Control\cr
\code{TGFβ} = TGFβ 2 ng/mL for 48 h}
\item{treatment}{
\code{Veh} = DMSO 0.1\% \cr
\code{AZD} = AZD3965 100 nM \cr
\code{VB} = VB124 10 μM \cr
\code{AZD/VB} = Both inhibitors together}
}

Gene annotation information can be accessed with \code{rowData(se)}.
}
\keyword{datasets}
