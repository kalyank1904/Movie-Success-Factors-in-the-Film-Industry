year_object_names <- ls(envir = .GlobalEnv, pattern = "^movies_20[0-9]{2}$")

year_dfs <- mget(year_object_names, envir = .GlobalEnv)

movies_raw <- dplyr::bind_rows(year_dfs, .id = "source_file_id")

raw_row_count <- nrow(movies_raw)
raw_col_count <- ncol(movies_raw)

cat("Number of rows after merging:", raw_row_count, "\n")
cat("Number of columns:", raw_col_count, "\n")

rm(list = year_object_names, envir = .GlobalEnv)
rm(year_object_names)

ProjectTemplate::cache("movies_raw")
ProjectTemplate::cache("raw_row_count")
ProjectTemplate::cache("raw_col_count")
