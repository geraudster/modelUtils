#' This function fits a model and displays information about this model
#' 
#' @param trainset
#' @param testset
#' @param method
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