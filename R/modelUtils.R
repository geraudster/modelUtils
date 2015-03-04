#' Test predictive models
#' 
#' @description This function fits a model and displays information about this model
#' @param formula The formula used to train the model
#' @param trainset The dataset to trin the data with
#' @param testset The dataset with test data
#' @param outcome The outcome column name
#' @param method The training algorithm to use (eg. glm, rpart, rf, gbm...)
#' @param ... additional parameters as specified by caret train function
#' @return a list
#' @export
#' @importFrom caret train

testModel <- function(formula,
                      trainset,
                      testset,
                      outcome,
                      method,
                      ...) {
  model <- list()
  tryCatch({
    model$time <- system.time(
      model$fit <- train(formula,
                         data=trainset,
                         method=method,
                         ...))
    model$predictions <- predict(model$fit, newdata = testset)

    trControl.classProbs <- c(...)[['trControl.classProbs']]
    if(!is.null(trControl.classProbs)) {
      if(trControl.classProbs)
        model$predictionsProbs <- predict(model$fit, newdata = testset, type = 'prob')
    }
    model$confusionMatrix <- confusionMatrix(model$predictions, testset[[outcome]])
  },
  error = function(cond) {
    message("Error caught, returning incomplete model")
    message(cond)
  },
  finally = return(model))
}