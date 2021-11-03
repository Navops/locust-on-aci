resource "random_password" "locustsecret" {
  length           = 16
  special          = true
  override_special = "_%@"
}

