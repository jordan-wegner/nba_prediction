# PCR Model and Data Comparison 

# No Rookies First

nba <- read.csv("modeling_no_rookies_20212022.csv")

# set year to current (upcoming) season

year <- 2021

suppressMessages(library(dplyr))
suppressMessages(library(stringr))

set_test <- nba %>% filter(season == year)
test <- set_test %>% select(-c(season,tm))
X_test <- test %>% select(-won)
y_test <- test %>% select(won)

set_train <- nba %>% filter(season < year)
train <- set_train %>% select(-c(season,tm))
X_train <- train %>% select(-won)
y_train <- train %>% select(won)

library(pls)

pcr_model <- pcr(won ~ ., 
                 data = train, 
                 scale = TRUE, 
                 validation = "CV")

train_rmse <- NULL

for (i in 1:pcr_model$ncomp){
  train_pred <- predict(pcr_model, train, ncomp = i)
  train_rmse[i] <- mean((train_pred - y_train[,1])^2)
}

num_comp <- which.min(train_rmse)

pcr_pred <- predict(pcr_model, test, ncomp = num_comp)
pcr_rmse <- mean((pcr_pred - y_test[,1])^2)

reportNames <- c("opt_num_comp","train_rmse","test_rmse")
no_rookies <- c(num_comp,min(train_rmse),pcr_rmse)

# Now with rookies

nba <- read.csv("modeling_with_rookies_20212022.csv")

# set year to current (upcoming) season

year <- 2021

suppressMessages(library(dplyr))
suppressMessages(library(stringr))

set_test <- nba %>% filter(season == year)
test <- set_test %>% select(-c(season,tm))
X_test <- test %>% select(-won)
y_test <- test %>% select(won)

set_train <- nba %>% filter(season < year)
train <- set_train %>% select(-c(season,tm))
X_train <- train %>% select(-won)
y_train <- train %>% select(won)

library(pls)

pcr_model <- pcr(won ~ ., 
                 data = train, 
                 scale = TRUE, 
                 validation = "CV")

train_rmse <- NULL

for (i in 1:pcr_model$ncomp){
  train_pred <- predict(pcr_model, train, ncomp = i)
  train_rmse[i] <- mean((train_pred - y_train[,1])^2)
}

num_comp <- which.min(train_rmse)

pcr_pred <- predict(pcr_model, test, ncomp = num_comp)
pcr_rmse <- mean((pcr_pred - y_test[,1])^2)

rookies <- c(num_comp,min(train_rmse),pcr_rmse)

results <- t(data.frame(no_rookies,rookies))

colnames(results) <- reportNames

# using the rookies works out better - 2020-2021 season
# same for 2021-2022 season

full_data <- read.csv("modeling_with_rookies_20212022.csv") %>% filter(!season==2022) %>% select(-c(season,tm))

final_model <- pcr(won ~ ., 
                   data = full_data, 
                   scale = TRUE, 
                   validation = "CV")
saveRDS(final_model, "pcr_model.rds")
