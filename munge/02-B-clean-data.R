# Clean 
movies <- movies_raw %>%
  janitor::clean_names()

movies <- movies %>%
  mutate(across(where(is.character), ~na_if(., "")))

glimpse(movies)

movies <- movies %>%
  mutate(
    id                    = as.character(id),
    title                 = as.character(title),
    vote_average          = as.numeric(vote_average),
    vote_count            = as.numeric(vote_count),
    status                = as.character(status),
    release_date          = as.Date(release_date),
    revenue               = as.numeric(revenue),
    runtime               = as.numeric(runtime),
    adult                 = as.logical(adult),
    budget                = as.numeric(budget),
    original_language     = as.character(original_language),
    original_title        = as.character(original_title),
    overview              = as.character(overview),
    popularity            = as.numeric(popularity),
    tagline               = as.character(tagline),
    genres                = as.character(genres),
    production_companies  = as.character(production_companies),
    production_countries  = as.character(production_countries),
    spoken_languages      = as.character(spoken_languages),
    keywords              = as.character(keywords)
  )

movies <- movies %>%
  distinct(id, .keep_all = TRUE)

cat("Rows after removing duplicates:", nrow(movies), "\n")
