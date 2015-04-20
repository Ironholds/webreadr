context("Test human-readable IPv4 to numeric IPv4 conversion")

test_that("an IPv4 address can be converted",{
  expect_that(ip_to_numeric("192.168.0.1"), equals(3232235521))
})

test_that("The maximum IPv6 address can be converted",{
  expect_that(ip_to_numeric("255.255.255.255"), equals(4294967295))
})

test_that("Invalid IPs are identified",{
  expect_that(ip_to_numeric("This is a turnip"), equals(0))
})

test_that("IPv6 IPs are identified",{
  expect_that(ip_to_numeric("2001:0db8:3c4d:0015:0000:0000:abcd:ef12"), equals(0))
})