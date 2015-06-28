## ModelUtils

[![Build Status](https://travis-ci.org/geraudster/modelUtils.svg?branch=master)](https://travis-ci.org/geraudster/modelUtils)

An R package for manipulating predictive models.

## Installation

You need the _devtools_ package to be installed before, then in R:

```r
devtools::install_github('geraudster/modelUtils')
```
  
## Usage

Generate a model:
```r
library(modelUtils)
data(iris)
inTrain <- createDataPartition(y=iris$Species, p=0.80, list=FALSE)
training <- na.omit(iris[inTrain,])
testing <- na.omit(iris[-inTrain,])
model <- testModel(Species ~ ., training, testing, 'Species', 'rpart')
```

Then to write the predictions:
```r
submission <- writeSubmission(model, data.frame(id = rownames(testing), testing), 'id', 'Species', 'test')
```

Will create a file with:
```csv
id,Species
14,setosa
21,setosa
30,setosa
31,setosa
32,setosa
...
```
