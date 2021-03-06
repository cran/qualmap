context("test cluster validate")

# test data ------------------------------------------------

test_clusterE <- qm_define(118600, 119101, 800000)
test_clusterE2 <- qm_define("118600", "119101", "800000")
test_clusterV <- qm_define(118600, 119101, 119300)

test_sf <- stLouis
test_sf <- dplyr::mutate(test_sf, TRACTCE = as.numeric(TRACTCE))

test_tbl <- dplyr::as_tibble(data.frame(
  x = c(1,2,3),
  y = c("a", "b", "a")
))

# test inputs ------------------------------------------------

# test missing ref parameter
expect_error(qm_validate(key = "TRACTCE", value = test_clusterV),
             "A reference, consisting of a simple features object, must be specified.")

# test ambiguous ref parameter
expect_error(qm_validate("TRACTCE", test_clusterV),
             "The reference object must be a simple features object.")

# test no sf ref parameter
expect_error(qm_validate(ref = test_tbl, key = "TRACTCE", value = test_clusterV),
             "The reference object must be a simple features object.")

# test missing key parameter
expect_error(qm_validate(ref = test_sf, value = test_clusterV),
             "A key identification variable must be specified.")

# test incorrect key parameter
expect_error(qm_validate(ref = test_sf, key = "test", value = test_clusterV),
             "The specified key test cannot be found in the reference data.")
expect_error(qm_validate(ref = test_sf, key = test, value = test_clusterV),
             "The specified key test cannot be found in the reference data.")

# test missing value parameter
expect_error(qm_validate(ref = test_sf, key = "TRACTCE"),
             "A vector containing feature ids must be specified.")

expect_error(qm_validate(test_sf, "TRACTCE"),
             "A vector containing feature ids must be specified.")

# test mismatch between key and value
expect_error(qm_validate(ref = test_sf, key = "TRACTCE", value = test_clusterE2),
             "Mismatch in class between TRACTCE (numeric) and test_clusterE2 (character). These must be the same class to create cluster object.", fixed = TRUE)

# test results ------------------------------------------------

resultE2 <- qm_validate(ref = test_sf, key = "TRACTCE", value = test_clusterE)
resultV1 <- qm_validate(ref = test_sf, key = "TRACTCE", value = test_clusterV)
resultV2 <- qm_validate(ref = test_sf, key = TRACTCE, value = test_clusterV)

test_that("returns FALSE - value not in key", {
  expect_equal(resultE2, FALSE)
})

test_that("returns TRUE - value is in key", {
  expect_equal(resultV1, TRUE)
})

test_that("returns TRUE - value is in key with unquoted input", {
  expect_equal(resultV2, TRUE)
})
