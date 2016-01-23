context("Test mixed field splitters")

test_that("CLF request fields can be split", {
  data <- read_clf(system.file("extdata/log.clf", package = "webreadr"))
  split_requests <- split_clf(data$request)
  expect_equal(nrow(split_requests), 2)
  expect_equal(ncol(split_requests), 3)
})

test_that("The CLF splitter can handle malformed requests", {
  split_requests <- split_clf(c("foo bar baz qux", "foo bar baz", "foo bar", NA))
  expect_equal(nrow(split_requests), 4)
  expect_equal(ncol(split_requests), 3)
  expect_equal(is.na(unname(unlist(split_requests[4,]))), c(TRUE, TRUE, TRUE))
  expect_equal(is.na(split_requests[3,3]), TRUE)
})

test_that("squid status fields can be split", {
  data <- read_squid(system.file("extdata/log.squid", package = "webreadr"))
  split_requests <- split_squid(data$status_code)
  expect_equal(nrow(split_requests), 121)
  expect_equal(ncol(split_requests), 2)
})

test_that("The squid splitter can handle malformed statuses", {
  split_requests <- split_squid(c("foo bar baz qux", "foo bar baz", "foo", NA))
  expect_equal(nrow(split_requests), 4)
  expect_equal(ncol(split_requests), 2)
  expect_equal(is.na(unname(unlist(split_requests[4,]))), c(TRUE, TRUE))
  expect_equal(is.na(split_requests[3,2]), TRUE)
})