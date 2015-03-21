context("URL encoding tests")

test_that("Check decoding handles spaces",{
  expect_equal(decode_url("foo%20bar"),"foo bar")
})

test_that("Check decoding handles double quotes",{
  expect_equal(decode_url("foo%22bar"),"foo\"bar")
})

test_that("Check decoding handles ASCII NULs", {
  expect_equal(decode_url("0;%20@%gIL"), "0; @")
})