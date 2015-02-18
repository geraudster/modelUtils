#' This function fits a model and displays information about this model
#' 
#' @param formula The formula used to train the model
#' @param trainset The dataset to trin the data with
#' @param testset The dataset with test data
#' @param outcome The outcome column name
#' @param method The training algorithm to use (eg. glm, rpart, rf, gbm...)
#' @return a list
#' @export
#' @importFrom caret train

testModel <- function(formula, trainset, testset, outcome, method, ...) {
  model <- list()
  model$time <- system.time(model$fit <- train(formula, data=trainset, method=method, ...))
  model$predictions <- predict(model$fit, newdata = testset)
  model$confusionMatrix <- confusionMatrix(model$predictions, testset[[outcome]])
  model
}