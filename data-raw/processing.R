# processing.R


# setup -------------------------------------------------------------------

library(org.Hs.eg.db)

# samples -----------------------------------------------------------------

replicate <- rep(1:4, each = 8)
condition <- rep(rep(c("Ctl", "TGFb"), each = 4), 4)
treatment <- rep(c("AZD", "DMSO", "VB", "Dual"), 8)
ids <- stringr::str_c("R", replicate, condition, treatment)

samples <-
  tibble::tibble(
    id = ids,
    replicate = replicate,
    condition = condition,
    treatment = treatment
  ) |>
  dplyr::mutate(
    condition = factor(
      condition,
      levels = c("Ctl", "TGFb"),
      labels = c("Ctl", "TGFβ"),
      ordered = TRUE
    ),
    treatment = factor(
      treatment,
      levels = c("DMSO", "AZD", "VB", "Dual"),
      labels = c("Veh", "AZD", "VB", "AZD/VB"),
      ordered = TRUE
    )
  )


# merge -------------------------------------------------------------------

fasta_files <-
  list.files(
    path = "/Volumes/LaCie/rnaseq/rnaseq_lf_tgfb_mcti_BGI_2022/",
    pattern = "*.fq.gz",
    full.names = TRUE,
    recursive = TRUE
  )

fasta_c <- function(files, sample) {
  pairs <- c("_1.fq.gz", "_2.fq.gz")
  for (p in pairs) {
    filename <- stringr::str_c(sample, p)
    vec <- files[stringr::str_detect(files, sample) & stringr::str_detect(files, p)]
    system(
      sprintf(
        "cat %s > %s",
        paste(unlist(vec), collapse = " "),
        stringr::str_c("data-raw/merge/", filename)
      )
    )
  }
}

dir.create("data-raw/merge")
purrr::walk(samples$id, \(x) fasta_c(fasta_files, x))


# salmon ------------------------------------------------------------------

system("snakemake --use-conda -c 1")


# annotate ----------------------------------------------------------------

quant_files <-
  list.files(
    "data-raw/quants",
    "quant.sf",
    full.names = TRUE,
    recursive = TRUE
  )

coldata <-
  tibble::tibble(files = quant_files) |>
  dplyr::mutate(
    names = stringr::str_extract(.data$files, "(?<=quants/).*(?=/quant.sf)")
  ) |>
  dplyr::left_join(samples, by = c("names" = "id"))

se <-
  tximeta::tximeta(coldata) |>
  tximeta::summarizeToGene() |>
  tximeta::addIds("ENTREZID", gene = TRUE, multiVals = "first") |>
  tximeta::addIds("SYMBOL", gene = TRUE, multiVals = "first")

names(SummarizedExperiment::rowData(se)) <-
  tolower(names(SummarizedExperiment::rowData(se)))


# save --------------------------------------------------------------------

usethis::use_data(se, overwrite = TRUE, compress = "xz", version = 3)
