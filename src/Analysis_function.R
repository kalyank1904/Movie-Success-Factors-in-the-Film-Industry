# ============================================
# ANALYSIS FUNCTIONS
# File: src/analysis_functions.R
# ============================================

library(ggplot2)
library(dplyr)
# ----- Function 1: Top N Table -----

get_top_n <- function(data, sort_column, n = 10) {
  data %>%
    arrange(desc(.data[[sort_column]])) %>%
    slice(1:n)
}

# ----- Function 2: Group Summary -----
summarise_by_group <- function(data, group_column, value_column) {
  data %>%
    group_by(.data[[group_column]]) %>%
    summarise(
      avg_value = mean(.data[[value_column]], na.rm = TRUE),
      count = n()
    ) %>%
    ungroup() %>%
    arrange(desc(avg_value))
}

# ----- Function 3: Split Comma-Separated Column -----
split_comma_column <- function(data, column) {
  data %>%
    filter(!is.na(.data[[column]]), .data[[column]] != "") %>%
    separate_rows(!!sym(column), sep = ",") %>%
    mutate(!!column := str_trim(.data[[column]]))
}

# ----- Function 4: Ranked Bar Chart -----
plot_ranked_bar <- function(data, x_var, y_var, title, x_label, y_label) {
  p <- ggplot(data, aes(x = reorder(.data[[x_var]], .data[[y_var]]), y = .data[[y_var]])) +
    geom_col() +
    coord_flip() +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal()
  return(p)
}

cat("Analysis functions loaded!\n")

setwd("/Users/kalyankankanala/MovieAnalysis")
