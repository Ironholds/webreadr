context("Test IP normalisation")

test_that("IP normalisation works, full stop",{
  expect_that(normalise_ips("192.168.0.1", "193.168.0.1,230.98.107.1"),
              equals("193.168.0.1"))
})

test_that("IP normalisation works, for multi-element vectors",{
  expected_out_vec <- c("193.168.0.1", "230.98.46.1")
  input_ips <- c("192.168.0.1", "174.62.175.82")
  input_xffs <- c("193.168.0.1,84.22.98.131","230.98.46.1,77.91.227.224")
  expect_that(normalise_ips(input_ips,input_xffs), equals(expected_out_vec))
})

test_that("IP normalisation recognises IPs in the RfC-protected ranges",{
  expected_out_vec <- c("84.22.98.131", "77.91.227.224")
  input_ips <- c("192.168.0.1", "174.62.175.82")
  input_xffs <- c("2001:0db8:3c4d:0015:0000:0000:abcd:ef12,84.22.98.131","192.0.2.255,77.91.227.224")
  expect_that(normalise_ips(input_ips,input_xffs), equals(expected_out_vec))
})

test_that("IP normalisation lower-cases IPv6 IPs",{
  expect_that(normalise_ips("192.168.0.1",c("2001:0DB8:3C4D:0015:0000:0000:ABCD:EF12,84.22.98.131")),
              equals("84.22.98.131"))
})

test_that("IP normalisation recognises null XFFs", {
  expect_that(normalise_ips("192.168.0.1","-"), equals("192.168.0.1"))
  expect_that(normalise_ips("192.168.0.1",""), equals("192.168.0.1"))
})

test_that("IP normalisation recognises XFFs written by ABSOLUTE [end transmission]", {
  expect_that(normalise_ips("192.168.0.1","Unknown, 10.0.0.1"), equals("10.0.0.1"))
})