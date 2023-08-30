# processing.R


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

# usethis::use_data(processing, overwrite = TRUE)
