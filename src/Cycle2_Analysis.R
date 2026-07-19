# ============================================
# CYCLE 2 ANALYSIS - GENRE AND LANGUAGE INSIGHTS
# File: src/cycle2_interesting_insights.R
# ============================================

# ----- Influence of Genre on Movie Success -----
genre_revenue <- movies %>%
  select(id, title, revenue, vote_average, genres) %>%
  filter(!is.na(genres), genres != "") %>%
  separate_rows(genres, sep = ",") %>%
  mutate(genres = str_trim(genres)) %>%
  group_by(genres) %>%
  summarise(
    avg_revenue = mean(revenue, na.rm = TRUE),
    avg_rating = mean(vote_average, na.rm = TRUE),
    movie_count = n()
  ) %>%
  arrange(desc(avg_revenue))

genre_plot <- genre_revenue %>% slice_head(n = 10)

p_genre_revenue <- ggplot(genre_plot, aes(x = reorder(genres, avg_revenue), y = avg_revenue)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Genres by Average Revenue", x = "Genre", y = "Average Revenue") +
  theme_minimal()

# ----- Influence of Language on Movie Success -----
language_success <- movies %>%
  group_by(original_language) %>%
  summarise(
    avg_revenue = mean(revenue, na.rm = TRUE),
    avg_rating = mean(vote_average, na.rm = TRUE),
    movie_count = n()
  ) %>%
  arrange(desc(movie_count))

language_plot <- language_success %>% slice_head(n = 10)

p_language_revenue <- ggplot(language_plot, aes(x = reorder(original_language, avg_revenue), y = avg_revenue)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top Languages by Average Revenue", x = "Language", y = "Average Revenue") +
  theme_minimal()

# ----- Connection Between Language and Ratings -----
top_languages <- movies %>%
  count(original_language, sort = TRUE) %>%
  slice_head(n = 10) %>%
  pull(original_language)

p_language_ratings <- movies %>%
  filter(original_language %in% top_languages) %>%
  ggplot(aes(x = reorder(original_language, vote_average, median), y = vote_average)) +
  geom_boxplot() +
  coord_flip() +
  labs(title = "Distribution of Movie Ratings by Language", x = "Language", y = "Movie Rating") +
  theme_minimal()

# -----Top Genres by Average Rating -----
genre_rating_plot <- genre_revenue %>%
  arrange(desc(avg_rating)) %>%
  slice_head(n = 10)

p_genre_rating <- ggplot(genre_rating_plot, aes(x = reorder(genres, avg_rating), y = avg_rating)) +
  geom_segment(aes(xend = genres, y = 0, yend = avg_rating)) +
  geom_point(size = 3) +
  coord_flip() +
  labs(title = "Top 10 Genres by Average Rating", x = "Genre", y = "Average Rating") +
  theme_minimal()

# ----- Genre ROI Efficiency -----
genre_roi <- movies %>%
  select(id, genres, budget, revenue, roi) %>%
  filter(!is.na(genres), genres != "", !is.na(roi), budget > 0) %>%
  separate_rows(genres, sep = ",") %>%
  mutate(genres = str_trim(genres)) %>%
  group_by(genres) %>%
  summarise(
    avg_roi = mean(roi, na.rm = TRUE),
    movie_count = n()
  ) %>%
  filter(movie_count >= 100) %>%
  arrange(desc(avg_roi)) %>%
  slice_head(n = 10)

p_roi_distribution <- movies %>%
  filter(!is.na(roi), roi > 0, roi < 50) %>%
  ggplot(aes(x = roi)) +
  geom_histogram(bins = 40) +
  labs(title = "Distribution of Return on Investment (ROI)", x = "ROI (Revenue / Budget)", y = "Number of Movies") +
  theme_minimal()

# plots
show_and_save_plot(p_genre_revenue, "genre_revenue.png")
show_and_save_plot(p_language_revenue, "language_revenue.png")
show_and_save_plot(p_language_ratings, "language_ratings.png")
show_and_save_plot(p_genre_rating, "genre_rating.png")
show_and_save_plot(p_genre_roi, "genre_roi.png")