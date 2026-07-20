# varibales 
movies <- movies %>%
  mutate(
    budget  = ifelse(budget < 0, NA, budget),
    revenue = ifelse(revenue < 0, NA, revenue),
    runtime = ifelse(runtime <= 0, NA, runtime)
  )

movies <- movies %>%
  mutate(
    release_year  = year(release_date),
    release_month = month(release_date, label = TRUE),
    release_day   = day(release_date),
    profit = revenue - budget,
    roi = ifelse(!is.na(budget) & budget > 0, revenue / budget, NA),
    revenue_success = case_when(
      is.na(revenue)     ~ "Unknown",
      revenue == 0        ~ "No Revenue Data / Zero",
      revenue < 1e7        ~ "Low Revenue",
      revenue < 1e8        ~ "Medium Revenue",
      TRUE                 ~ "High Revenue"
    ),
    rating_group = case_when(
      is.na(vote_average) ~ "Unknown",
      vote_average < 5     ~ "Low Rated",
      vote_average < 7     ~ "Moderately Rated",
      TRUE                  ~ "Highly Rated"
    )
  )


missing_summary <- sapply(movies, function(x) sum(is.na(x)))
missing_summary <- sort(missing_summary, decreasing = TRUE)
print(missing_summary)

movies <- movies %>%
  filter(release_year >= 2000 & release_year <= 2024)

ProjectTemplate::cache("movies")
ProjectTemplate::cache("missing_summary")









