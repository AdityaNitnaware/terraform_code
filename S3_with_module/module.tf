


module "s3_module" {
  source         = "./s3"
  s3_bucket_name = "my-tf-test-bucket-dev-demo"
  status         = "Enabled"
  expiry_days    = 180
}

