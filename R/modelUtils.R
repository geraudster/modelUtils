#' Test predictive models
#' 
#' @description This function fits a model and displays information about this model
#' @param formula The formula used to train the model
#' @param trainset The dataset to trin the data with
#' @param testset The dataset with test data
#' @param outcome The outcome column name
#' @param method The training algorithm to use (eg. glm, rpart, rf, gbm...)
#' @param weights Define weights as for the train method
#' @return a list
#' @export
#' @importFrom caret train

testModel <- function(formula, trainset, testset, outcome, method, weights = NULL) {
  model <- list()
  model$time <- system.time(model$fit <- train(formula, data=trainset, method=method, NULL, weights))
  model$predictions <- predict(model$fit, newdata = testset)
  model$confusionMatrix <- confusionMatrix(model$predictions, testset[[outcome]])
  model
}