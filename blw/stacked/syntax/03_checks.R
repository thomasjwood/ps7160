# =============================================================================
# Bright Line Watch stacked files -- quality checks
# Reads build/_intermediate.rds (from 02_build_stacked.R); writes build/qa_*.csv
# and prints a summary. Re-run after any change to the crosswalk or schemes.
# =============================================================================
suppressPackageStartupMessages(library(tidyverse))
source("syntax/00_item_dictionary.R")
b <- readRDS("build/_intermediate.rds")

# 1. crosswalk: grid position vs. variable label ------------------------------
chk <- b$xwalk |> filter(!is.na(label_agrees))
cat("\n[1] Crosswalk rows with a usable label:", nrow(chk), " disagreements:", sum(!chk$label_agrees), "\n")
print(chk |> filter(!label_agrees) |> select(survey, wave, source_var, key, label_key, source_label), n = 50, width = 200)
write_csv(b$xwalk |> filter(!is.na(label_agrees) & !label_agrees), "build/qa_crosswalk_disagreements.csv")

# 2. unmatched text values ------------------------------------------------------
um <- b$unmatched |> group_by(survey, target, source_var, value) |> summarise(waves = paste(sort(unique(wave)), collapse = ","), n = sum(n), .groups = "drop") |> arrange(desc(n))
cat("\n[2] Unmatched non-missing text values:", nrow(um), "distinct\n")
print(um, n = 60, width = 200)
write_csv(um, "build/qa_unmatched_values.csv")

# 3. multiple sources for one item in the same respondent -----------------------
cat("\n[3] Coalesce overlaps (same respondent answered two source variables for one item):\n")
if (nrow(b$coalesce)) print(b$coalesce |> group_by(survey, wave) |> summarise(targets = n(), n_both = sum(n_both), n_disagree = sum(n_disagree), .groups = "drop"), n = 50)

# 4. item means by wave; adjacent-wave correlation of item profiles -------------
item_means <- function(df, sv) {
  df |> select(wave, starts_with("perf_"), starts_with("imp_")) |>
    pivot_longer(-wave, names_to = "item", values_to = "v") |> filter(!is.na(v)) |>
    group_by(wave, item) |> summarise(mean = mean(v), n = n(), .groups = "drop") |> mutate(survey = sv)
}
im <- bind_rows(item_means(b$public, "public"), item_means(b$expert, "expert"))
write_csv(im, "build/qa_item_means_by_wave.csv")
prof <- im |> mutate(bat = str_extract(item, "^[a-z]+")) |> group_by(survey, bat) |> group_modify(\(g, k) {
  ws <- sort(unique(g$wave))
  map_dfr(seq_along(ws)[-1], \(i) {
    a <- g |> filter(wave == ws[i - 1]); c <- g |> filter(wave == ws[i])
    j <- inner_join(a, c, by = "item")
    tibble(wave_prev = ws[i - 1], wave = ws[i], n_items = nrow(j), r = if (nrow(j) > 4) cor(j$mean.x, j$mean.y) else NA_real_)
  })
}) |> ungroup()
cat("\n[4] Correlation of item-mean profiles with the previous wave carrying the battery (low r = suspect mapping):\n")
print(prof |> arrange(r), n = 80)

# 4b. respondent ids: present and unique within wave ---------------------------
ids <- bind_rows(b$public |> select(survey, wave, resp_id), b$expert |> select(survey, wave, resp_id)) |>
  group_by(survey, wave) |> summarise(n = n(), missing = sum(is.na(resp_id) | resp_id == ""),
                                      dup = sum(duplicated(resp_id[!is.na(resp_id)])), .groups = "drop")
cat("\n[4b] Waves with missing or duplicated resp_id:\n"); print(ids |> filter(missing > 0 | dup > 0), n = 60)

# 5. respondent-level core variables -------------------------------------------
cat("\n[5] Core variables by wave (public):\n")
b$public |> group_by(wave) |> summarise(n = n(), wt_mean = mean(weight, na.rm = TRUE), rating = mean(rating_USA, na.rm = TRUE),
  pid7_na = mean(is.na(pid7)), rep_share = mean(pid3_lean == 3, na.rm = TRUE), ideo_cons = mean(ideo7 >= 5, na.rm = TRUE),
  female = mean(gender == 2, na.rm = TRUE), age = mean(age, na.rm = TRUE), ba_plus = mean(educ4 >= 3, na.rm = TRUE),
  white = mean(race5 == 1, na.rm = TRUE), state_na = mean(is.na(state_fips)), approve = mean(approve_pres <= 2, na.rm = TRUE),
  start = min(field_date, na.rm = TRUE)) |> print(n = 40, width = 250)
cat("\n[5b] Core variables by wave (expert):\n")
b$expert |> group_by(wave) |> summarise(n = n(), rating = mean(rating_USA, na.rm = TRUE), rating_n = sum(!is.na(rating_USA)),
  field_n = sum(!is.na(field)), amer = mean(field == 1, na.rm = TRUE), occ_n = sum(!is.na(occupation)), fac = mean(occupation == 4, na.rm = TRUE),
  id_na = mean(is.na(resp_id)), panel_n = sum(!is.na(panel_id)), start = min(field_date, na.rm = TRUE), fin = mean(finished, na.rm = TRUE)) |>
  print(n = 40, width = 250)
