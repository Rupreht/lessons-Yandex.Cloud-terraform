locals {
  all_users = distinct(flatten(var.federated_users[*].users))

  service_account_name_to_id = {
    for user in resource.yandex_iam_service_account.users :
    user.name => "serviceAccount:${user.id}"
  }

  map_users_by_group = {
    for group in var.federated_users :
    group.name => [
      for user in group.users :
      lookup(local.service_account_name_to_id, lower(user), "")
    ]
  }

  map_role_by_group = transpose({
    for g in var.federated_users :
    g.name => [
      for role in g.roles : lower(role)
    ]
  })

  join_user_id = {
    for k, v in local.map_role_by_group :
    k => local.map_users_by_group[v[0]]
  }

}

// создадим тдругой тесттовый каталог
resource "yandex_resourcemanager_folder" "test_iam" {
  cloud_id    = var.cloud_id
  name        = "test-iam"
  description = "Test IAM"
}

// создадим сервисные аккаунты для ресурса - каталог
resource "yandex_iam_service_account" "users" {
  count       = length(local.all_users)
  folder_id   = resource.yandex_resourcemanager_folder.test_iam.id
  name        = lower(element(local.all_users, count.index))
  description = "Test user #${count.index + 1}"
}

// назначим роли пользователям
resource "yandex_resourcemanager_folder_iam_binding" "add_roles" {
  for_each  = local.join_user_id
  folder_id = resource.yandex_resourcemanager_folder.test_iam.id
  role      = each.key
  members   = each.value
}

//-------------------------------------

variable "federated_users" {
  type = set(object({
    name        = string
    description = string
    users       = list(string)
    roles       = list(string)
  }))
  default = [
    {
      "name" : "lb",
      "description" : "LB users",
      "users" : [
        # <username>,
        # "federatedUser:<userid>",
        "Alice",
        "Bob",
      ],
      "roles" : [
        "alb.admin",
      ]
    },
    {
      "name" : "monitoring",
      "description" : "Monitoring users",
      "users" : [
        "Cliff",
        "Daniel",
      ],
      "roles" : [
        "logging.viewer",
        "monitoring.admin",
      ]
    },
    {
      "name" : "common",
      "description" : "Common users",
      "users" : [
        "Alice",
        "Cliff",
      ],
      "roles" : [
        "viewer"
      ]
    },
  ]
}
