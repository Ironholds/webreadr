context("Test file readers and splitters")

test_that("Common Log Format files can be read, and split_clf can split the requests",{
  data <- read_clf(system.file("extdata/log.clf", package = "webreadr"))
  expect_equal(ncol(data), 7)
  expect_equal(nrow(data), 2)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
  split_data <- split_clf(data$request)
  expect_equal(ncol(split_data), 3)
  expect_equal(nrow(split_data), 2)
})

test_that("Combined Log Format files can be read, and split_clf can split the requests",{
  data <- read_combined(system.file("extdata/combined_log.clf", package = "webreadr"))
  expect_equal(ncol(data), 9)
  expect_equal(nrow(data), 12)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
  split_data <- split_clf(data$request)
  expect_equal(ncol(split_data), 3)
  expect_equal(nrow(split_data), 12)
  
})

test_that("Combined Log Format files can be read",{
  data <- read_squid(system.file("extdata/log.squid", package = "webreadr"))
  expect_equal(ncol(data), 9)
  expect_equal(nrow(data), 121)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
  split_data <- split_squid(data$status_code)
  expect_equal(ncol(split_data), 2)
  expect_equal(nrow(split_data), 121)
})

test_that("AWS files can be read",{
  data <- read_aws(system.file("extdata/log.aws", package = "webreadr"))
  expect_equal(ncol(data), 18)
  expect_equal(nrow(data), 2)
  expect_equal(class(data$date), c("POSIXct","POSIXt"))
})



test_that("S3 files can be read",{
  data <- read_s3(system.file("extdata/s3.log", package = "webreadr"))
  expect_equal(ncol(data), 18)
  expect_equal(nrow(data), 6)
  expect_equal(class(data$request_time), c("POSIXct","POSIXt"))
})