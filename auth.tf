// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "tf-test-sa"
}

# // Grant permissions
# resource "yandex_resourcemanager_folder_iam_member" "test-editor" {
#   folder_id = var.folder_id
#   role      = "storage.admin"
#   member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
# }

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}
