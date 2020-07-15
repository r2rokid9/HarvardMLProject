####################
#
# Note: This is the regularization approach. It may take a while thus it
# was saved as a separate script
#
###################

lambdas <- seq(0, 10, 0.25) ## Lambda will be from 0 to 10 inclusively, with increments of .25

rmses <- sapply(lambdas, function(l){
  
  mu <- mean(edx$rating)
  
  b_i <- edx %>% ## Earlier, this was movie_avgs
    group_by(movieId) %>%
    summarize(b_i = sum(rating - mu)/(n()+l)) ## Divide by N + Lambda
  
  b_u <- edx %>% ## Earlier, this was user_effect_avgs
    left_join(b_i, by="movieId") %>%
    group_by(userId) %>%
    summarize(b_u = sum(rating - b_i - mu)/(n()+l)) ## Divide by N + Lambda
  
  b_g <- edx %>%  ## Earlier, this was genre_effect_avgs
    left_join(b_i, by="movieId") %>%
    left_join(b_u, by="userId") %>%
    group_by(genres) %>%
    summarize(b_g = sum(rating - b_i - b_u - mu)/(n()+l)) ## Divide by N + Lambda
  
  predicted_ratings <- 
    validation %>% 
    left_join(b_i, by = "movieId") %>%
    left_join(b_u, by = "userId") %>%
    left_join(b_g, by = c("genres"))  %>%
    mutate(pred = mu + b_i + b_u + b_g) %>%
    pull(pred)
  
  return(RMSE(predicted_ratings, validation$rating))
})