# resource "random_string" "test_password_for_db" {
#   length           = 24
#   special          = true
#   override_special = "!@#$%&"
# }

# resource "yandex_kms_secret_ciphertext" "secret" {
#   name        = "/test/mysql"
#   description = "password for mysql test"
#   type        = "SecureString"
#   value       = random_string.test_password_for_db.result
#   tags = {
#     environment = "test"
#   }
# }
