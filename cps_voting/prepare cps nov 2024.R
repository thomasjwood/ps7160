suppressPackageStartupMessages({library(readr); library(dplyr)})
dl <- "C:/Users/thoma/AppData/Local/Temp/ps7160_dl"; repo <- "C:/Users/thoma/AppData/Local/Temp/ps7160_clone"
lay <- read_csv(file.path(dl, "cps_nov24_layout.csv"), show_col_types = FALSE)
x <- read_fwf(file.path(dl, "cps/nov24pub.dat"), fwf_positions(lay$start, lay$end, lay$name), col_types = cols(.default = col_double(), HRHHID = col_character(), HRHHID2 = col_character()), progress = FALSE)
cat(dim(x), "\n")
# weights are stored with four implied decimals
for (w in grep("WGT$", names(x), value = TRUE)) x[[w]] <- x[[w]] / 1e4
chk <- x %>% filter(PRTAGE >= 18, PRCITSHP %in% 1:4, PRPERTYP == 2, PES1 %in% c(1, 2, -2, -3, -9))
cat("citizen adults with supplement:", nrow(chk), " weighted voted share (Census: 65.3):", round(100 * weighted.mean(chk$PES1 == 1, chk$PWSSWGT), 1), "\n")
cat("registered incl. voters (Census: 73.6):", round(100 * weighted.mean(chk$PES1 == 1 | chk$PES2 == 1, chk$PWSSWGT), 1), "\n")
print(table(x$GESTFIPS)[1:5]); print(table(x$PES1, useNA = "ifany"))
saveRDS(x, file.path(repo, "cps_voting/cps_nov2024_voting_supplement.rds"))
cat("MB:", round(file.size(file.path(repo, "cps_voting/cps_nov2024_voting_supplement.rds"))/1e6, 1), "\n")
