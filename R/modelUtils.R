#' Test predictive models
#' 
#' @description This function fits a model and displays information about this model
#' @param formula The formula used to train the model. If NULL, will use the non-formula train method of caret
#' @param trainset The dataset to train the data with
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
    # fit a model and measure its execution time
    model$time <- system.time(
      if(is.null(formula) || is.na(formula)){
        outcomeColumn <- which(colnames(trainset) == outcome)
        model$fit <- train(trainset[,-outcomeColumn],
                           trainset[,outcomeColumn],
                           method=method,
                           ...)        
      } else {
        model$fit <- train(formula,
                           data=trainset,
                           method=method,
                           ...)
      })
    # get predictions
    model$predictions <- predict(model$fit, newdata = testset)

    # try to get probs
    model$predictionsProbs <- extractProb(list(model$fit), testset)
    
    # finally the confusionMatrix
    model$confusionMatrix <- confusionMatrix(model$predictions, testset[[outcome]])
  },
  error = function(cond) {
    message("Error caught, returning incomplete model")
    message(cond)
  },
  finally = return(model))
}


#' Dump predictions in a file, for data science competition
#' 
#' @description This function creates a CSV file with predicted values to be submitted
#' @param model The model used to predict new values
#' @param validationSet
#' @param id
#' @param outcome
#' @param projectName
#' @return a list
#' @export
#' @importFrom caret extractProb
writeSubmission <- function(model,
                            validationSet,
                            id = 'id',
                            outcome = 'outcome',
                            projectName = '') {
  probs <- extractProb(list(model$fit), unkX = validationSet)
  submission <- data.frame(id = validationSet[[id]], outcome = probs$pred)
  colnames(submission) <- c(id, outcome)
  filename <- paste0(projectName, model$fit$method, format(Sys.time(), "%Y%m%d_%H%M%S"), '.csv')
  write.table(submission, 
              filename,
              row.names = FALSE,
              sep=',', quote = FALSE)
  list(probs = probs, filename = filename)
}
