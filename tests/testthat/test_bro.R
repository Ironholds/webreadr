
context("Test reading Bro file formats")

test_that("Bro app logs can be read", {
  
  file <- system.file("extdata/app_stats.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 1)
  expect_equal(ncol(data), 6)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
})

test_that("Bro conn logs can be read", {
  
  file <- system.file("extdata/conn.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 23)
  expect_equal(ncol(data), 20)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
})

test_that("Bro DHCP logs can be read", {
  
  file <- system.file("extdata/dhcp.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 2)
  expect_equal(ncol(data), 10)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
})

test_that("Bro DNS logs can be read", {
  
  file <- system.file("extdata/dns.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 9)
  expect_equal(ncol(data), 23)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
})

test_that("Bro FTP logs can be read", {
  
  file <- system.file("extdata/ftp.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 17)
  expect_equal(ncol(data), 19)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
})

test_that("Bro file logs can be read", {
  
  file <- system.file("extdata/files.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 17)
  expect_equal(ncol(data), 23)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
})

test_that("Bro HTTP logs can be read", {
  
  file <- system.file("extdata/http.log", package = "webreadr")
  data <- read_bro(file)
  
  expect_equal(nrow(data), 91)
  expect_equal(ncol(data), 27)
  expect_equal(class(data$timestamp), c("POSIXct","POSIXt"))
  
})
