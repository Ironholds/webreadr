context("URL encoding tests")

test_that("Check decoding handles ASCII NULs", {
  expect_that(url_decode("0;%20@%gIL"), equals("0; @"))
})