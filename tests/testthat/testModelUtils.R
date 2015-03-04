library(caret)
library(modelUtils)

context('Model test')
data(iris)
inTrain <- createDataPartition(y=iris$Species, p=0.80, list=FALSE)
training <- na.omit(iris[inTrain,])
testing <- na.omit(iris[-inTrain,])

test_that('Model is not empty', {
  model <- testModel(Species ~ ., training, testing, 'Species','rpart', weights = rep(1, nrow(training)))
  expect_is(model, 'list')
})

test_that('Model is not empty without weights', {
  model <- testModel(Species ~ ., training, testing, 'Species','rpart')
  expect_is(model, 'list')
})

test_that('Model works with classProbs', {
  model <- testModel(Species ~ ., training, testing, 'Species', 'rpart', classProbs = TRUE)
  expect_is(model$predictionsProbs, 'data.frame')
})

test_that('Model is partially returned on error', {
  expect_message(testModel(Species ~ ., training, testing, 'Undefined', 'rpart', classProbs = TRUE))
})

test_that('Model works with specific trainControl', {
  tc <- trainControl(method = 'repeatedcv', number = 10, repeats = 10)
  model <- testModel(Species ~ ., training, testing, 'Species', 'rpart',
                     trControl = tc)
  expect_is(model, 'list')
})


