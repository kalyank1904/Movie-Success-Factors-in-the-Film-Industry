# Merge data

year_object_names <- ls(envir = .GlobalEnv, pattern = "^movies_20[0-9]{2}$")

year_dfs <- mget(year_object_names, envir = .GlobalEnv)

movies_raw <- dplyr::bind_rows(year_dfs, .id = "source_file_id")

cat("Number of rows after merging:", nrow(movies_raw), "\n")
cat("Number of columns:", ncol(movies_raw), "\n")

rm(list = year_object_names, envir = .GlobalEnv)
rm(year_dfs, year_object_names)