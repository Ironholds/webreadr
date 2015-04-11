context("User agent testing")

test_that("Linux UAs can be easily identified",{
  result <- parse_r_agent("R (2.15.2 x86_64-redhat-linux-gnu x86_64 linux-gnu)")
  expect_that(result$r_version, equals("2.15.2"))
  expect_that(result$architecture, equals("x86_64"))
  expect_that(result$platform, equals("linux"))
})

test_that("Windows UAs can be easily identified",{
  result <- parse_r_agent("R (2.15.2 x86_64-w64-mingw32 x86_64 mingw32)")
  expect_that(result$r_version, equals("2.15.2"))
  expect_that(result$architecture, equals("x86_64"))
  expect_that(result$platform, equals("windows"))
})

test_that("Apple UAs can be easily identified",{
  result <- parse_r_agent("R (2.15.2 x86_64-apple-darwin9.8.0 x86_64 darwin9.8.0")
  expect_that(result$r_version, equals("2.15.2"))
  expect_that(result$architecture, equals("x86_64"))
  expect_that(result$platform, equals("apple"))
})