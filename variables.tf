# Variable que define la región de AWS donde se desplegará la infraestructura
variable "region" {
  description = "Región de AWS donde se desplegará el bucket S3"
  type        = string
}

# Variable para el nombre del bucket S3 (debe ser único a nivel global en AWS)
variable "bucket_name" {
  description = "Nombre único del bucket S3 que alojará el sitio web estático"
  type        = string
}

# Variable con el nombre del propietario del proyecto para los tags
variable "owner" {
  description = "Nombre del estudiante o responsable del proyecto"
  type        = string
}

# Variable para el ambiente de despliegue
variable "environment" {
  description = "Ambiente donde se desplegará la infraestructura (dev, staging, prod)"
  type        = string
}

# Variable para el nombre del proyecto
variable "project" {
  description = "Nombre del proyecto al que pertenece la infraestructura"
  type        = string
}
