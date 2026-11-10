# polling error 1998-2026.R
# two panels from the polling error dataset ("polling error dataset
# 1998-2026.R"): the weighted average absolute error of polls in the final 21
# days, all races, by cycle; and the weighted average bias, democrat-vs-
# republican races only, drawn as republicans underrated up (red), democrats
# underrated down (blue). 2026 is shaded as preliminary (results still being
# counted). output: figures/polling error 1998-2026.pdf and .png

library(tidyverse)
library(magrittr)
library(patchwork)
library(showtext)

font_add(
  family = "GT American",
  regular = "C:\\Dropbox\\fonts\\GT America\\GT America Regular.otf",
  bold = "C:\\Dropbox\\fonts\\GT America\\GT America Bold.otf",
  italic = "C:\\Dropbox\\fonts\\GT America\\GT America Regular Italic.otf",
  bolditalic = "C:\\Dropbox\\fonts\\GT America\\GT America Bold Italic.otf"
  )

col_d <- "#00aef3"
col_r <- "#D8171E"
pal <- c(D = col_d, R = col_r)

pe <- "data/polling error/"
polls <- read_rds(str_c(pe, "polling_error_polls_1998_2026.rds"))
cyc <- read_csv(str_c(pe, "polling_error_by_cycle_1998_2026.csv"), show_col_types = F) %>%
  filter(type == "All")
last <- max(cyc$cycle)

# the long-run average error, 1998 through the last complete cycle, every poll
# weighted as in its own cycle's average
avg <- polls %>%
  filter(cycle < last) %>%
  group_by(cycle, coalesce(pollster_rating_id, pollster)) %>%
  mutate(w = 1 / sqrt(n())) %>%
  ungroup %>%
  summarise(error = weighted.mean(error, w)) %>%
  pull

cyc %<>% mutate(
  side = if_else(bias >= 0, "R", "D"),
  lab_err = sprintf("%.1f", error),
  lab_bias = str_c(side, "+", sprintf("%.1f", abs(bias)))
  )

prelim <- annotate("rect", xmin = last - 1, xmax = last + 1, ymin = -Inf, ymax = Inf, fill = "grey88")

# the house time-series theme ("house national vote by cycle 1926-2026.R"),
# with the stacked panels' titles drawn like facet titles
th <- theme_minimal(base_family = "GT American", base_size = 9) +
  theme(
    panel.background = element_rect(color = "grey95", fill = "grey95"),
    panel.grid = element_blank(),
    axis.text = element_text(size = rel(.75), color = "grey40"),
    axis.title.y = element_text(size = rel(.8), color = "grey30"),
    plot.title = element_text(face = "plain", size = rel(.8), hjust = .5),
    plot.title.position = "panel"
    )

# the same x range in both panels, so the years line up
x_sc <- scale_x_continuous(breaks = cyc$cycle, limits = range(cyc$cycle) + c(-1.2, 1.2), expand = expansion(0))

# error: thin line, labelled bubbles (house idiom), the long-run average dashed
p1 <- ggplot(cyc, aes(cycle, error)) +
  prelim +
  annotate("text", x = last, y = Inf, label = "Preliminary", vjust = 1.6, size = 2.5, color = "grey30", family = "GT American") +
  geom_hline(yintercept = avg, linewidth = .25, linetype = "dashed", color = "grey40") +
  # the average's key, in the empty top left
  annotate("segment", x = min(cyc$cycle) + 2.6, xend = min(cyc$cycle) + 3.8, y = 8.2, yend = 8.2, linewidth = .25, linetype = "dashed", color = "grey40") +
  annotate("text", x = min(cyc$cycle) + 4, y = 8.2, label = str_c("Average, ", min(cyc$cycle), "–", last - 2, ": ", sprintf("%.1f", avg)), hjust = 0, size = 2.5, color = "grey30", family = "GT American") +
  geom_line(linewidth = .35, color = "grey30") +
  # bubbles: all outlines, then all white discs, then all labels
  geom_point(shape = 21, fill = "white", color = "grey30", size = 6.5, stroke = .4) +
  geom_point(shape = 21, fill = "white", color = "white", size = 6, stroke = 0) +
  geom_text(aes(label = lab_err), size = 1.75, color = "grey20", family = "GT American") +
  x_sc +
  scale_y_continuous(limits = c(3.5, 8.5), breaks = 4:8) +
  labs(x = NULL, y = "Points of margin", title = "Average absolute error") +
  th

# bias: bars from zero (house bar style), the value at the bar's end
b_lim <- max(abs(cyc$bias)) + 1.6

p2 <- ggplot(cyc, aes(cycle, bias)) +
  prelim +
  geom_hline(yintercept = 0, linewidth = .3, color = "grey40") +
  geom_col(aes(fill = side), alpha = .6, color = "grey35", linewidth = .15, width = 1.3) +
  geom_text(aes(label = lab_bias, color = side, vjust = if_else(bias >= 0, -.5, 1.5)), size = 2.2, fontface = "bold", family = "GT American") +
  annotate("text", x = min(cyc$cycle) - .5, y = b_lim, label = "Republicans underrated", hjust = 0, vjust = 1, color = col_r, size = 2.5, fontface = "bold.italic", family = "GT American") +
  annotate("text", x = min(cyc$cycle) - .5, y = -b_lim, label = "Democrats underrated", hjust = 0, vjust = 0, color = col_d, size = 2.5, fontface = "bold.italic", family = "GT American") +
  scale_fill_manual(values = pal, guide = "none") +
  scale_color_manual(values = pal, guide = "none") +
  x_sc +
  scale_y_continuous(
    limits = c(-b_lim, b_lim),
    breaks = seq(-6, 6, 2),
    labels = \(y) case_when(y > 0 ~ str_c("R+", y), y < 0 ~ str_c("D+", -y), T ~ "0")
    ) +
  labs(x = NULL, y = "Points of margin", title = "Average bias, Democrat-vs-Republican races") +
  th

p <- (p1 / p2) +
  plot_annotation(
    title = str_c("Polling error in U.S. elections, ", min(cyc$cycle), "–", last),
    caption = "Source: FiveThirtyEight; New York Times; Wikipedia. Plot: @thomasjwood",
    theme = theme_minimal(base_family = "GT American", base_size = 9) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0),
        plot.title.position = "plot",
        plot.caption = element_text(face = "italic", size = rel(.75)),
        plot.margin = margin(.15, .25, .1, .15, "cm")
        )
    )

showtext_auto()
showtext_opts(dpi = 300)

for (ext in c(".pdf", ".png")) {
  ggsave(
    plot = p,
    str_c(getOption("ep_fig_dir", "figures/"), "polling error ", min(cyc$cycle), "-", last, ext),
    width = 10, height = 6.25, dpi = 300, bg = "white"
    )
}
