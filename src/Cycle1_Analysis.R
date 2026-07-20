cat("\n===== BASIC SUMMARY =====\n")
cat("Total movies:", nrow(movies), "\n")
cat("Year range:", min(movies$release_year, na.rm = TRUE), "to", max(movies$release_year, na.rm = TRUE), "\n")
cat("Average rating:", mean(movies$vote_average, na.rm = TRUE), "\n")
cat("Average revenue:", mean(movies$revenue, na.rm = TRUE), "\n")
cat("Average budget:", mean(movies$budget, na.rm = TRUE), "\n")
cat("Average runtime:", mean(movies$runtime, na.rm = TRUE), "\n")

# ----- Top 10 Revenue Generating Movies -----
top_revenue_movies <- movies %>%
  arrange(desc(revenue)) %>%
  select(title, release_year, revenue, budget, profit, vote_average, popularity) %>%
  slice(1:10)

# ----- Top 10 Highest Rated Movies -----
top_rated_movies <- movies %>%
  filter(vote_count >= 100) %>%
  arrange(desc(vote_average)) %>%
  select(title, release_year, vote_average, vote_count, revenue, popularity) %>%
  slice(1:10)

# ----- Count of Movies Per Year -----
movies_per_year <- movies %>%
  count(release_year)

# ----- Average Revenue Per Year -----
avg_revenue_per_year <- movies %>%
  group_by(release_year) %>%
  summarise(avg_revenue = mean(revenue, na.rm = TRUE), total_movies = n()) %>%
  ungroup()

# ----- Average Rating Per Year -----
avg_rating_per_year <- movies %>%
  group_by(release_year) %>%
  summarise(avg_rating = mean(vote_average, na.rm = TRUE), n_movies = n()) %>%
  ungroup()

# ----- Genre Breakdown -----
genre_long <- movies %>%
  select(id, title, genres) %>%
  filter(!is.na(genres), genres != "") %>%
  separate_rows(genres, sep = ",") %>%
  mutate(genres = str_trim(genres)) %>%
  filter(genres != "")

genre_summary <- genre_long %>%
  count(genres, sort = TRUE)

top_genres <- genre_summary %>% slice_head(n = 10)

# ----- Plot: Number of Movies Released Per Year -----
p1 <- ggplot(movies_per_year, aes(x = release_year, y = n)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Number of Movies Released Per Year", x = "Release Year", y = "Number of Movies") +
  theme_minimal()

# ----- Plot: Average Movie Rating Per Year -----
p2 <- ggplot(avg_rating_per_year, aes(x = release_year, y = avg_rating)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Average Movie Rating Per Year", x = "Release Year", y = "Average Vote Average") +
  theme_minimal()

# ----- Plot: Movies by Rating Group -----
rating_group_summary <- movies %>% count(rating_group)

p_ratinggroup <- ggplot(rating_group_summary, aes(x = rating_group, y = n)) +
  geom_col() +
  labs(title = "Movies by Rating Group", x = "Rating Group", y = "Movie Count") +
  theme_minimal()

# ----- Plot: Average Revenue Per Year -----
p3 <- ggplot(avg_revenue_per_year, aes(x = release_year, y = avg_revenue)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "Average Revenue Per Year", x = "Release Year", y = "Average Revenue") +
  theme_minimal()

# ----- Plot: Budget vs Revenue (log scale) -----
p5 <- ggplot(movies %>% filter(!is.na(budget), !is.na(revenue), budget > 0, revenue > 0),
             aes(x = budget, y = revenue)) +
  geom_point(alpha = 0.5) +
  scale_x_log10() +
  scale_y_log10() +
  labs(title = "Budget vs Revenue (log scale)", x = "Budget (log scale)", y = "Revenue (log scale)") +
  theme_minimal()

# ----- Plot: Distribution of Movie Runtime -----
p_runtime <- ggplot(movies %>% filter(runtime >= 30, runtime <= 300), aes(x = runtime)) +
  geom_histogram(bins = 30) +
  labs(title = "Distribution of Movie Runtime", x = "Runtime (minutes)", y = "Number of Movies") +
  theme_minimal()

# ----- Plot: Top 10 Genres -----
p6 <- ggplot(top_genres, aes(x = reorder(genres, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Genres", x = "Genre", y = "Number of Movies") +
  theme_minimal()

# ----- Correlation Matrix -----
numeric_data <- movies %>%
  select(vote_average, vote_count, revenue, runtime, budget, popularity, profit, roi)

cor_matrix <- cor(numeric_data, use = "pairwise.complete.obs")



print(p1)
print(p2)
print(p_ratinggroup)
print(p3)
print(p5)
print(p_runtime)
print(p6)

ggsave("graphs/01_movies_per_year.png", p1, width = 7, height = 5)
ggsave("graphs/02_rating_per_year.png", p2, width = 7, height = 5)
ggsave("graphs/03_rating_group.png", p_ratinggroup, width = 7, height = 5)
ggsave("graphs/04_revenue_per_year.png", p3, width = 7, height = 5)
ggsave("graphs/05_budget_vs_revenue.png", p5, width = 7, height = 5)
ggsave("graphs/06_runtime_distribution.png", p_runtime, width = 7, height = 5)
ggsave("graphs/07_top_genres.png", p6, width = 7, height = 5)