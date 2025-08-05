# Опис структури проєкту

Проєкт організовано для автоматичного розгортання інфраструктури AWS за допомогою Terraform. Основна структура:
- `main.tf` — підключення модулів та їх параметризація.
- `beckend.tf` — налаштування Terraform backend (зберігання стану у S3 та блокування через DynamoDB).
- `outputs.tf` — вивід основних ресурсів.
- `modules/` — власні модулі для S3/DynamoDB, VPC, ECR, EKS.
- `.terraform.lock.hcl` — файл блокування провайдерів.
- `modules/s3-backend/` — модуль для S3-бакета та DynamoDB.
- `modules/vpc/` — модуль для створення VPC, підмереж, маршрутів, Internet Gateway.
- `modules/ecr/` — модуль для створення репозиторію ECR.
- `modules/eks/` — модуль для створення EKS-кластера та Node Group.
- `module/rds/` — модуль для створення RDS або Aurora-кластер
- `modules/jenkins/` — модуль для встановлення Jenkins через Helm.
- `modules/argo_cd/` — модуль для встановлення Argo CD та керування застосунками.
- `charts/django-app/` — Helm-чарт для деплою Django застосунку у Kubernetes (deployment, service, configmap, hpa).
- `argo_cd/charts/` — Helm-чарт для Argo CD Application-ресурсів.

# Команди для ініціалізації та запуску

```sh
terraform init      # Ініціалізація Terraform та завантаження провайдерів
terraform plan      # Перевірка та перегляд змін, які будуть внесені
terraform apply     # Застосування змін та створення інфраструктури
terraform destroy   # Видалення всієї створеної інфраструктури
```

# Пояснення кожного модуля

## s3-backend
Модуль створює S3-бакет для зберігання стану Terraform та DynamoDB-таблицю для блокування стану. Забезпечує версіонування бакета та контроль доступу.

## vpc
Модуль створює VPC з публічними та приватними підмережами, Internet Gateway, маршрутними таблицями та асоціаціями для підключення підмереж до маршрутів.

## ecr
Модуль створює репозиторій AWS ECR для зберігання Docker-образів, налаштовує політику доступу та автоматичне сканування образів при їх завантаженні.

## eks
Модуль створює кластер AWS EKS, IAM-ролі для кластера та вузлів, а також Node Group з параметрами масштабування (desired, min, max size). Дозволяє автоматично розгортати Kubernetes-кластер для запуску контейнеризованих застосунків.

## modules/jenkins/
Встановлює Jenkins через Helm.Налаштовує чарти: ресурси, агент, креденшели. Виводить URL доступу до інтерфейсу та admin пароль через outputs.tf.

## modules/rds/
Підіймає Aurora Cluster або звичайну RDS instance на основі значення use_aurora. Автоматично створює DB Subnet Group, Security Group, Parameter Group для обраного типу БД. Працює з мінімальними змінами змінних і підтримує багаторазове використання.

## modules/argo_cd/
Встановлює Argo CD через Helm. Створює Helm release для самої платформи та для керованих застосунків. Виводить hostname, initial password та інші параметри.

## charts/django-app
Helm-чарт для деплою Django застосунку у кластері Kubernetes. Містить шаблони для Deployment, Service, ConfigMap, HPA та використовує змінні з values.yaml для гнучкого налаштування параметрів розгортання.

## argo_cd/charts/
Включає application.yaml та repository.yaml для керування застосунками. Встановлюється через окремий Helm release.Параметри — через values.yaml.
