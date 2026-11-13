library(tidyverse)
library(magrittr)
library(haven)

# Surveys of Consumers microdata, built from the SDA download
# (https://sda.umsurvey.org/sca/, all variables, all months).
# SDA gives a fixed-width data file and an SPSS setup file. This reads the
# setup file's DATA LIST, VARIABLE LABELS, VALUE LABELS and missing-data
# rules and applies them in R, so nothing is retyped by hand.

sps_file <- "raw/sca_sda_setup.sps"
dat_file <- "raw/sca_sda_data.txt.gz"
out_file <- "sca_microdata_1978_2026.rds"

sps <- sps_file %>%
  read_lines

# lines of one syntax block: from its header to the lone "." that closes it
sps_block <- function(header) {
  from <- sps %>%
    str_detect(
      str_c("^", header)
    ) %>%
    which %>%
    min

  to <- sps %>%
    str_detect("^\\s*\\.\\s*$") %>%
    which %>%
    keep(
      \(i)
      i > from
    ) %>%
    min

  sps[(from + 1):(to - 1)]
}


# column positions -------------------------------------------------------

t_cols <- "DATA LIST" %>%
  sps_block %>%
  str_c(collapse = " ") %>%
  str_remove("^.*?/1") %>%
  str_match_all(
    "([A-Z][A-Z0-9_]*)\\s+(\\d+)(?:-(\\d+))?(?:\\s*\\((\\d+)\\))?"
  ) %>%
  extract2(1) %>%
  as_tibble(
    .name_repair = \(i) c("x", "var", "start", "end", "dec")
  ) %>%
  transmute(
    var,
    start = start %>%
      as.integer,
    end = end %>%
      coalesce(
        start %>%
          as.character
      ) %>%
      as.integer,
    dec = dec %>%
      as.integer %>%
      replace_na(0L)
  )


# variable labels --------------------------------------------------------

t_varlab <- "VARIABLE LABELS" %>%
  sps_block %>%
  str_match(
    "^\\s+([A-Z][A-Z0-9_]*)\\s+'(.*)'\\s*/?\\s*$"
  ) %>%
  as_tibble(
    .name_repair = \(i) c("x", "var", "varlab")
  ) %>%
  filter(
    var %>%
      is.na %>%
      not
  ) %>%
  transmute(
    var,
    varlab = varlab %>%
      str_replace_all("''", "'")
  )


# value labels -----------------------------------------------------------
# tokens are either a variable name or a code-'label' pair; quoted labels
# can hold slashes and doubled apostrophes, so the block is tokenized whole

t_vallab <- "VALUE LABELS" %>%
  sps_block %>%
  str_c(collapse = " ") %>%
  str_match_all(
    "(-?[0-9.]+)\\s+'((?:[^']|'')*)'|([A-Z][A-Z0-9_]*)"
  ) %>%
  extract2(1) %>%
  as_tibble(
    .name_repair = \(i) c("x", "code", "lab", "var")
  ) %>%
  fill(var) %>%
  filter(
    code %>%
      is.na %>%
      not
  ) %>%
  transmute(
    var,
    code = code %>%
      as.numeric,
    lab = lab %>%
      str_replace_all("''", "'") %>%
      str_squish
  )


# missing-data rules -----------------------------------------------------
# SDA writes these as IF (X GE 8) X = $SYSMIS. plus MISSING VALUES X (-97).
# Every one becomes NA. SDA leaves DK/NA in the party ID items (POLAFF,
# POLREP, POLDEM, POLCRD) and SHOMRN1-2, so any code labeled "DK" or "NA"
# is added as missing too.

t_miss <- sps %>%
  str_match(
    "^IF \\(([A-Z][A-Z0-9_]*) (GE|GT|LE|LT|EQ) (-?[0-9.]+)\\)"
  ) %>%
  as_tibble(
    .name_repair = \(i) c("x", "var", "op", "val")
  ) %>%
  bind_rows(
    sps %>%
      str_match(
        "^MISSING VALUES\\s+([A-Z][A-Z0-9_]*)\\s+\\((.*)\\)"
      ) %>%
      as_tibble(
        .name_repair = \(i) c("x", "var", "val")
      ) %>%
      mutate(op = "EQ") %>%
      separate_longer_delim(val, delim = ",")
  ) %>%
  bind_rows(
    t_vallab %>%
      filter(lab %in% c("DK", "NA")) %>%
      transmute(
        var,
        op = "EQ",
        val = code %>%
          as.character
      )
  ) %>%
  filter(
    var %>%
      is.na %>%
      not
  ) %>%
  transmute(
    var,
    op,
    val = val %>%
      str_trim %>%
      as.numeric
  )

# TRUE where x is caught by any of a variable's missing rules
is_missing <- function(x, v) {
  rules <- t_miss %>%
    filter(var == v)

  rules %>%
    pmap(
      \(op, val, ...)
      switch(
        op,
        GE = x >= val,
        GT = x > val,
        LE = x <= val,
        LT = x < val,
        EQ = x == val
      ) %>%
        replace_na(FALSE)
    ) %>%
    reduce(
      `|`,
      .init = x %>%
        is.na %>%
        and(FALSE)
    )
}


# read and clean ---------------------------------------------------------

t_raw <- dat_file %>%
  read_fwf(
    col_positions = fwf_positions(
      t_cols$start,
      t_cols$end,
      t_cols$var
    ),
    col_types = cols(.default = col_character()),
    trim_ws = T,
    progress = F
  )

# one variable: numeric with SPSS implied decimals, missing codes to NA,
# variable label, and value labels for the codes still in use. Labels stay
# only on categorical items (every valid value labeled); on numeric items
# (ICS, AGE, PX1) they would turn the column into a factor under as_factor.
clean_var <- function(var, start, end, dec) {
  v <- var
  raw <- t_raw[[v]]

  x <- raw %>%
    as.numeric %>%
    divide_by(
      raw %>%
        str_detect(fixed(".")) %>%
        ifelse(1, 10^dec)
    )

  x[is_missing(x, v)] <- NA

  labs <- t_vallab %>%
    filter(var == v)

  labs <- labs %>%
    filter(
      labs$code %>%
        is_missing(v) %>%
        not
    )

  categorical <- labs %>%
    nrow %>%
    is_greater_than(0) %>%
    and(
      x %>%
        na.omit %>%
        is_in(labs$code) %>%
        all
    )

  if (categorical) {
    x <- x %>%
      labelled(
        labels = labs$code %>%
          set_names(labs$lab)
      )
  }

  attr(x, "label") <- t_varlab %>%
    filter(var == v) %>%
    pull(varlab)

  attr(x, "format.spss") <- str_c(
    "F",
    end %>%
      subtract(start) %>%
      add(1) %>%
      add(dec > 0),
    ".",
    dec
  )

  x
}

t_cs <- t_cols %>%
  pmap(clean_var) %>%
  set_names(t_cols$var) %>%
  as_tibble %>%
  mutate(
    DATE = YYYYMM %>%
      as.character %>%
      ym %>%
      structure(label = "SURVEY MONTH (FIRST OF MONTH)")
  ) %>%
  relocate(DATE, .after = YYYYMM)


# checks -----------------------------------------------------------------

stopifnot(
  t_cs %>%
    nrow %>%
    equals(
      dat_file %>%
        read_lines %>%
        length
    ),
  t_cs$CASEID %>%
    anyDuplicated %>%
    equals(0),
  t_cs$ICS %>%
    range(na.rm = T) %>%
    between(0, 200) %>%
    all
)

# weighted monthly ICS should track the published index
t_cs %>%
  filter(DATE >= max(DATE) %m-% months(5)) %>%
  group_by(DATE) %>%
  summarise(
    n = n(),
    ics = ICS %>%
      weighted.mean(WT, na.rm = T) %>%
      round(1)
  ) %>%
  print

t_cs %>%
  write_rds(
    out_file,
    compress = "xz"
  )

# codebook: one row per variable, with value labels and the months asked
t_cs %>%
  imap(
    \(i, j)
    tibble(
      var = j,
      label = i %>%
        attr("label") %>%
        coalesce(""),
      values = i %>%
        attr("labels") %>%
        {
          if (is.null(.)) "" else str_c(., "=", names(.), collapse = "; ")
        },
      n_valid = i %>%
        is.na %>%
        not %>%
        sum,
      first_month = t_cs$DATE[!is.na(i)] %>%
        min,
      last_month = t_cs$DATE[!is.na(i)] %>%
        max
    )
  ) %>%
  list_rbind %>%
  write_csv("codebook.csv")
