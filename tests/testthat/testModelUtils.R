library(caret)
library(modelUtils)

context('Model test')
data(iris)
inTrain <- createDataPartition(y=iris$Species, p=0.80, list=FALSE)
training <- na.omit(iris[inTrain,])
testing <- na.omit(iris[-inTrain,])

model <- testModel(Species ~ ., training, testing, 'Species','rpart', weights = rep(1, nrow(training)))
test_that('Model is not empty', {
  expect_is(model, 'list')
})

model <- testModel(Species ~ ., training, testing, 'Species','rpart')
test_that('Model is not empty without weights', {
  expect_is(model, 'list')
})

model <- testModel(Species ~ ., training, testing, 'Species', 'rpart', classProbs = TRUE)
test_that('Model works with classProbs', {
  expect_is(model$predictionsProbs, 'data.frame')
})
