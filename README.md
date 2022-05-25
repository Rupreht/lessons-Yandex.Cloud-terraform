# Yandex.Cloud & Terraform

## Prepare

export var from .env file

```sh
export $(grep -v '^#' .env | xargs -0)
```

## Yandex Compute Cloud

### доступ к серийной консоли

```sh
ssh -t -p 9600 -o IdentitiesOnly=yes -i ~/.ssh/<имя закрытого ключа> <ID виртуальной машины>.<имя пользователя>@serialssh.cloud.yandex.net
```

```sh
ssh -t -p 9600 epd49m92tes9nd5ut6g5.rupreht@serialssh.cloud.yandex.net
```
