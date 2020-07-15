###Data analysis
if(!require(data.table))
  install.packages("data.table", repos = "http://cran.us.r-project.org")
if(!require(dplyr))
  install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(dtplyr))
  install.packages("dtplyr", repos = "http://cran.us.r-project.org")
if(!require(caret))
  install.packages("caret", repos = "http://cran.us.r-project.org")
if(!require(foreach))
  install.packages("foreach", repos = "http://cran.us.r-project.org")
if(!require(doSNOW))
  install.packages("doSNOW", repos = "http://cran.us.r-project.org")
if(!require(recosystem))
  install.packages("recosystem", repos = "http://cran.us.r-project.org")

if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")
if(!require(ggthemes)) 
  install.packages("ggthemes", repos = "http://cran.us.r-project.org")
###############################################SECTION 1.0 Data Analysis#########################################

#######
# Pre-analysis - We can see that it's in tidyverse
#######
edx 

#######
# Analyze the edx dataset even further. We can see that there are (as of this writing)
# 9000055 rows 6 columns
#######
dim(edx)


#########
# Let's take a look at what those 6 columns are:
#
# The dataset is in tidy format, and the following are the columns headers:
#
# userID - numeric (denotes the a distinct user entry)
# movieId - numeric (denotes a distinct movie entry)
# rating - numeric (denotes the rating userId gave to movieId)
# timestamp - numeric (denotes the date the rating was made in seconds)
# title - character (denotes the title of the movie with ID movieId)
# genres - character (denotes the genre label of the specific movie)
#########

head(edx) %>%
  print.data.frame()


#######
# Count the distinct number of users and movies
# We can see that we have
# 
# 69878 distinct users
# 10677 distinct movies
#######

edx %>%
  summarize(n_users = n_distinct(userId), 
            n_movies = n_distinct(movieId))

#######
#
# The next part should give us an idea on what we're dealing with:
# Now that we know how many users are in the dataset, and how many movies, we can then see if we
# are dealing with a sparse matrix
# ...it looks like we are
# Only 1.21% of all possible combinations
#######

edx %>%
  summarize(total_complete_ratings = n_distinct(userId) * n_distinct(movieId),
            available_ratings = nrow(edx),
            percentage = available_ratings / total_complete_ratings)

#######
# To give us a better idea of the picture, let's
# generate a heatmap showing the user x movie
# matrix taken from a sample of the dataset. From this image, we can see that we
# are dealing with a sparse matrix
#######

user_matrix <- sample(unique(edx$userId), 100)
edx %>% filter(userId %in% user_matrix) %>% select(userId, movieId, rating) %>% mutate(rating = 1) %>%
  spread(movieId, rating) %>%  select(sample(ncol(.), 100)) %>%  as.matrix() %>% t(.) %>%
  image(1:100, 1:100,. , xlab="Movies", ylab="Users")
abline(h=0:100+0.5, v=0:100+0.5)
title("User Movie Ratings Matrix")

#######
# Histogram of ratings per movie
#
# Let's have a look at our histogram of movie ratings.
# We can see that some movies are rated more frequently than others
######
histogram_movies <- edx %>%
  group_by(movieId) %>%
  summarise(n=n()) %>%
  ggplot(aes(n)) +
  geom_histogram(color = "steelblue") +
  scale_x_log10() + 
  labs(
    title = "Ratings per movie Histogram",
    x = "No. of Ratings", y = "No. of Movies", fill = element_blank()
  ) +
  theme_classic()

histogram_movies

######
# Histogram of ratings per user
#
# Likewise, let's examine the users histogram. Our histogram indicates
# that there are some users who give more ratings than other users
# However, majority of the users tend to give relatively few ratings
#####

histogram_users <- edx %>%
  group_by(userId) %>%
  summarise(n=n()) %>%
  ggplot(aes(n)) +
  geom_histogram(color = "steelblue") + 
  scale_x_log10() +
  labs(title = "Ratings per user Histogram",
       x = "No. of Ratings", y = "No. of Users", fill = element_blank()) +
  theme_classic()

histogram_users

#########
#
# What type of ratings were provided by the user?
# We can see it in the following image
#
########

rating_summary <- edx %>% group_by(rating) %>%
  summarize(count = n())

rating_summary

rating_freq <- rating_summary %>% mutate(rating = factor(rating)) %>%
  ggplot(aes(rating, count)) +
  geom_col(fill = "steel blue", color = "white") +
  theme_classic() + 
  labs(x = "Rating Value", y = "Frequency",
       title = "Frequency of Ratings")

rating_freq

#######
#
# The average rating is as follows:
# 3.51
#
# The standard deviation is as follows:
# 1.06
#######

summarize(edx,ave_rate = round(mean(edx$rating),2),
          stdev_rate = round(sd(edx$rating),2))

########
# As an added note, we can see that the ratings were collected
# over a time of 14 years between 1995 - 2009
#
# This should give a slight idea on the user demographics we are dealing with
########

tibble('Initial' = date(as_datetime(min(edx$timestamp), origin="1970-01-01")),
       'Final' = date(as_datetime(max(edx$timestamp), origin="1970-01-01"))) %>%
  mutate(Time = duration(max(edx$timestamp) - min(edx$timestamp)))

########
# Let's take a closer look at the movies
# that were rated significantly
# It turns out, the "popular movies"
# and blockbusters normally received quite a lot
#######

edx %>% mutate(date = date(as_datetime(timestamp, origin="1970-01-01"))) %>%
  group_by(date, title) %>%
  summarise(count = n()) %>%
  arrange(-count) %>%
  head(10)

########
# It is important to pay attention to the movie content
# in the dataset as that can affect the recommendation systems
# Here, we can see that the genre labels can be brought down
# to a total of 20 genre labels
########

genre_labels <- str_replace(edx$genres,"\\|.*","")
genre_labels
genre_unique <- genre_labels[!duplicated(genre_labels)]
genre_unique

genre_ratings_count <- edx %>%
  group_by(genres) %>%
  summarise(count = n()) %>%
  top_n(20,count) %>%
  arrange(desc(count))

genre_distribution <- edx %>%
  group_by(genres) %>%
  summarise(count = n()) %>%
  top_n(20,count) %>%
  ggplot(aes(genres, count)) +
  theme_classic()  +
  geom_col(fill = "blue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Number of ratings Per Genre",
       x = "Genre",
       y = "Number of ratings")

genre_ratings_count
genre_distribution

##### 
#
#Let's look at the top 10 highest rated movie genre combinations
#
####

temp <- edx %>%
  group_by(genres) %>%
  summarize(mean_rating_by_genre=mean(rating)) %>%
  arrange(mean_rating_by_genre)

head(temp,10)

##### 
#
#Now the bottom 10
#
####

temp <- edx %>%
  group_by(genres) %>%
  summarize(mean_rating_by_genre=mean(rating)) %>%
  arrange(mean_rating_by_genre)

head(temp,10)

user_matrix <- sample(unique(edx$userId), 200)
edx %>% filter(userId %in% user_matrix) %>% select(userId, movieId, rating) %>% mutate(rating = 1) %>%
  spread(movieId, rating) %>%  select(sample(ncol(.), 200)) %>%  as.matrix() %>% t(.) %>%
  image(1:200, 1:200,. , xlab="Movies", ylab="Users")
title("User Movie Ratings Matrix (50 users & 50 movies")

###############################
# Given all this information, the goal is to be able to come up with an approach
# predict those "missing" values in the ratings column based on:
#
# - the ratings of a particular movieId
# - the ratings a particular user has given other movies
#
################################


############################################################DATA ANALYSIS##################################################

###########
# LOSS FUNCTION
##########

#
# Note that the RMSE that we aim to accomplish is <= 0.87750
#
#

##
#Using the Naive RMSE approach, our rmse = 1.06
##
mu <- mean(edx$rating)
mu

baseline_rmse = RMSE(validation$rating, mu)
baseline_rmse

##
#Using the Movie Effect
##
mu <- mean(edx$rating)
movie_avgs <- edx %>%
  group_by(movieId) %>%
  summarize(b_i = mean(rating - mu))

movie_avgs %>% qplot(b_i, geom ="histogram", bins = 10, data = ., color = I("black"),
                     xlab = "Movie bias (b_i)",ylab = "Number of movies", main = "Movie biases computed")

predicted_movie_effect_ratings <- mu + validation %>%
  left_join(movie_avgs, by='movieId') %>% pull(b_i)

movie_effect_rmse <- RMSE(predicted_movie_effect_ratings, validation$rating)
movie_effect_rmse


predicted_movie_effect_ratings_edx <- mu + edx %>%
  left_join(movie_avgs, by='movieId') %>% pull(b_i)
movie_effect_rmse_edx <- RMSE(predicted_movie_effect_ratings_edx, edx$rating)
movie_effect_rmse_edx
movie_effect_rmse

remove(predicted_movie_effect_ratings_edx)

##
# Considering User Effect
##

user_biases <- edx %>% 
  left_join(movie_avgs, by='movieId') %>%
  group_by(userId) %>%
  filter(n() >= 100) %>%
  summarize(b_u = mean(rating - mu - b_i))
user_biases%>% qplot(b_u, geom ="histogram", bins = 30, data = ., color = I("black"),
            xlab = "User bias (b_u)",ylab = "Number of Users", main = "User biases computed")

user_effect_avgs <- edx %>%
  left_join(movie_avgs, by='movieId') %>%
  group_by(userId) %>%
  summarize(b_u = mean(rating - mu - b_i))

user_effect_avgs

predicted_user_ratings <- validation%>%
  left_join(movie_avgs, by='movieId') %>%
  left_join(user_effect_avgs, by='userId') %>%
  mutate(pred = mu + b_i + b_u) %>%
  pull(pred)

user_effect_rmse <- RMSE(predicted_user_ratings, validation$rating)
user_effect_rmse

##
# Considering Genre Effect
##

genre_avgs <- edx %>%
  left_join(movie_avgs, by = "movieId") %>%
  left_join(user_effect_avgs, by = "userId") %>%
  group_by(genres) %>%
  summarize(b_g = mean(rating - mu - b_i - b_u))
genre_avgs%>% qplot(b_g, geom ="histogram", bins = 30, data = ., color = I("black"),
                      xlab = "Genre bias (b_g)",ylab = "Number of genres", main = "Genre biases computed")

predicted_genre_effect_ratings <- validation %>%
  left_join(movie_avgs, by = "movieId") %>%
  left_join(user_effect_avgs, by = "userId") %>%
  left_join(genres_avgs, by = c("genres")) %>%
  mutate(pred = mu + b_i + b_u + b_g) %>%
  pull(pred)

genre_effect_rmse <- RMSE(predicted_genre_effect_ratings, validation$rating)
genre_effect_rmse

##
# Applying Regularization
##
#
# NOTE, THIS CODE TAKES A WHILE TO EXECUTE, THUS IT IS COMMENTED OUT. PLEASE SEE "MovieUserGenreRegularization.R" as a stand alone file instead
#
#lambdas <- seq(0, 10, 0.25)
#
#rmses <- sapply(lambdas, function(l){
#  
#  mu <- mean(edx$rating)
#  
#  b_i <- edx %>% 
#    group_by(movieId) %>%
#    summarize(b_i = sum(rating - mu)/(n()+l))
#  
#  b_u <- edx %>% 
#    left_join(b_i, by="movieId") %>%
#    group_by(userId) %>%
#    summarize(b_u = sum(rating - b_i - mu)/(n()+l))
#  
#  b_g <- edx %>% 
#    left_join(b_i, by="movieId") %>%
#    left_join(b_u, by="userId") %>%
#    group_by(genres) %>%
#    summarize(b_g = sum(rating - b_i - b_u - mu)/(n()+l))
#  
#  predicted_ratings <- 
#    validation %>% 
#    left_join(b_i, by = "movieId") %>%
#    left_join(b_u, by = "userId") %>%
#    left_join(b_g, by = c("genres"))  %>%
#    mutate(pred = mu + b_i + b_u + b_g) %>%
#    pull(pred)
#  
#  return(RMSE(predicted_ratings, validation$rating))
#})

##saveRDS(rmses,file = "rmses.RData") <~ Saved to an external file instead
##saveRDS(lambdas,file = "lambdas.RData") <~ Saved to an external file too
rmses <- readRDS("rmses.RData")
lambdas <- readRDS("lambdas.RData")

min(rmses) #lowest value of RMSES
lambdas[which.min(rmses)] # Find the lambda value that produces the lowest RMSE

qplot(lambdas, rmses, xlab = "Lambda Penalty Values", ylab = "RMSES")  


##############################
#
# Results and Analysis Code
#
##############################
rmse_res <- tibble(Model = "Baseline LM", RMSE = baseline_rmse)
rmse_res <- bind_rows(rmse_res,
                       tibble(Model = "LM(M)", RMSE = movie_effect_rmse))
rmse_res <- bind_rows(rmse_res,
                      tibble(Model = "LM(M,U)", RMSE = user_effect_rmse))

rmse_res <- bind_rows(rmse_res,
                       tibble(Model = "LM(M,U,G)", RMSE = genre_effect_rmse))

rmse_res <- bind_rows(rmse_res,
                       tibble(Model = "Regularized LM(M,U,G)", RMSE = min(rmses)))
                      
rmse_res