# processing.R


# setup -------------------------------------------------------------------

library(org.Hs.eg.db)


# annotate ----------------------------------------------------------------

quant_files <-
  list.files(
    "~/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/quants",
    "quant.sf",
    full.names = TRUE,
    recursive = TRUE
  )

coldata <-
  tibble::tibble(files = quant_files) |>
  dplyr::mutate(
    names = stringr::str_extract(.data$files, "(?<=quants/).*(?=/quant.sf)"),
    condition = ifelse(stringr::str_detect(names, "(Con|^VB)"), "Ctl", "TGFβ"),
    condition = factor(condition, levels = c("Ctl", "TGFβ")),
    treatment = ifelse(stringr::str_detect(names, "VB"), "VB253", "Veh"),
    treatment = factor(treatment, levels = c("Veh", "VB253")),
    replicate = stringr::str_extract(names, "\\d+$")
  )

se_vb253 <-
  tximeta::tximeta(coldata) |>
  tximeta::summarizeToGene() |>
  tximeta::addIds("ENTREZID", gene = TRUE, multiVals = "first") |>
  tximeta::addIds("SYMBOL", gene = TRUE, multiVals = "first")

names(SummarizedExperiment::rowData(se_vb253)) <-
  tolower(names(SummarizedExperiment::rowData(se_vb253)))


# save --------------------------------------------------------------------

usethis::use_data(se_vb253, overwrite = TRUE, compress = "xz", version = 3)
