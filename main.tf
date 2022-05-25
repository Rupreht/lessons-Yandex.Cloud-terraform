// Use keys to create bucket
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.bucket
}

# data "yandex_compute_image" "ubuntu-2004-lts" {
#   family = "ubuntu-2004-lts"
# }

# resource "yandex_compute_instance" "vm-1" {
#   name = "terraform1"

#   resources {
#     cores         = 2
#     memory        = 2
#     core_fraction = 20
#   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu-2004-lts.id
#       size     = 20
#     }
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.local.id
#     nat       = true
#   }

#   metadata = {
#     user-data = "${file("./meta.yml")}"
#   }
# }

resource "yandex_vpc_network" "local" {
  name        = "localnet"
  description = "Localnet for test"
}

resource "yandex_vpc_subnet" "local-a" {
  name           = "local-ru-central1-a"
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.local.id
}

resource "yandex_vpc_subnet" "local-b" {
  name           = "local-ru-central1-b"
  v4_cidr_blocks = ["10.3.0.0/16"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.local.id
}

resource "yandex_vpc_subnet" "local-c" {
  name           = "local-ru-central1-c"
  v4_cidr_blocks = ["10.4.0.0/16"]
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.local.id
}
