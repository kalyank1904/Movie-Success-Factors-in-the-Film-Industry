key_findings <- list(
  cycle1 = list(
    movie_count_change = paste0(
      "Movies released per year grew from ",
      movies_per_year$n[movies_per_year$release_year == 2000],
      " in 2000 to ",
      movies_per_year$n[movies_per_year$release_year == 2023],
      " in 2023, before dropping to ",
      movies_per_year$n[movies_per_year$release_year == 2024],
      " in 2024"
    ),
    rating_decline = paste0(
      "Average rating fell from ",
      round(avg_rating_per_year$avg_rating[avg_rating_per_year$release_year == 2000], 2),
      " in 2000 to ",
      round(avg_rating_per_year$avg_rating[avg_rating_per_year$release_year == 2024], 2),
      " in 2024"
    ),
    budget_revenue_correlation = round(cor_matrix["budget", "revenue"], 3),
    top_revenue_movie = top_revenue_movies$title[1],
    top_rated_movie = top_rated_movies$title[1]
  ),
  cycle2 = list(
    best_revenue_genre = genre_plot$genres[1],
    best_rating_genre = genre_rating_plot$genres[1],
    most_efficient_genre_by_roi = genre_roi$genres[which.max(genre_roi$avg_roi)],
    top_revenue_language = language_plot$original_language[1],
    top_rated_languages = movies %>%
      filter(original_language %in% top_languages) %>%
      group_by(original_language) %>%
      summarise(avg_rating = mean(vote_average, na.rm = TRUE)) %>%
      arrange(desc(avg_rating)) %>%
      slice(1) %>%
      pull(original_language)
  )
)

saveRDS(key_findings, file = "cache/key_findings.rds")

cat("Summary data created and saved to cache/key_findings.rds\n")



write.csv(top_revenue_movies, "outputs/top_revenue_movies.csv", row.names = FALSE)
write.csv(top_rated_movies, "outputs/top_rated_movies.csv", row.names = FALSE)
write.csv(genre_revenue, "outputs/genre_revenue.csv", row.names = FALSE)
write.csv(language_success, "outputs/language_success.csv", row.names = FALSE)
save(key_findings, file = "outputs/key_findings.RData")

cat("Exported outputs.\n")
