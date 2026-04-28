# =====================================================
# BLOQUE TERRAFORM
# Define los requisitos mínimos para ejecutar este código
# =====================================================
terraform {
  required_version = ">= 1.5" # Indica que se necesita Terraform 1.5 o superior para correr este proyecto

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Indica que el proveedor AWS viene del registro oficial de HashiCorp
      version = "~> 5.0"        # Permite cualquier versión 5.x pero no saltar a la 6.0 (compatibilidad)
    }
  }
}

# =====================================================
# PROVEEDOR AWS
# Le dice a Terraform con qué nube trabajar y en qué región
# =====================================================
provider "aws" {
  region = var.region # Usa la variable 'region' para no tener la región escrita a mano (buena práctica)
}

# =====================================================
# LOCALS
# Variables internas reutilizables con los tags obligatorios
# Todos los valores vienen de variables — sin hardcoding
# =====================================================
locals {
  tags_comunes = {
    Environment = var.environment # Ambiente tomado de variable (dev, staging, prod)
    Owner       = var.owner       # Nombre del responsable del proyecto, tomado de variable
    Project     = var.project     # Nombre del proyecto, tomado de variable
  }
}

# =====================================================
# RECURSO: BUCKET S3
# Crea el contenedor donde se almacenarán los archivos del sitio web
# =====================================================
resource "aws_s3_bucket" "sitio_web" {
  bucket = var.bucket_name # El nombre del bucket viene de una variable para hacerlo dinámico y reutilizable

  tags = local.tags_comunes # Aplica los tags obligatorios definidos en locals
}

# =====================================================
# RECURSO: CONFIGURACIÓN DE WEBSITE EN S3
# Habilita S3 para que sirva los archivos como un sitio web estático
# =====================================================
resource "aws_s3_bucket_website_configuration" "sitio_web" {
  bucket = aws_s3_bucket.sitio_web.id # Referencia al bucket creado arriba por su ID

  index_document {
    suffix = "index.html" # Archivo que S3 servirá cuando alguien acceda a la raíz del sitio
  }

  error_document {
    key = "index.html" # Si hay un error (ej: 404), también redirige al index.html
  }
}

# =====================================================
# RECURSO: DESHABILITAR BLOQUEO DE ACCESO PÚBLICO
# Por defecto AWS bloquea todo acceso público; aquí lo desactivamos para el sitio web
# =====================================================
resource "aws_s3_bucket_public_access_block" "sitio_web" {
  bucket = aws_s3_bucket.sitio_web.id # Aplica esta configuración al bucket del sitio web

  block_public_acls       = false # Permite que se apliquen ACLs públicas al bucket
  block_public_policy     = false # Permite que se apliquen políticas públicas al bucket
  ignore_public_acls      = false # No ignora las ACLs públicas existentes
  restrict_public_buckets = false # No restringe el acceso público al bucket
}

# =====================================================
# RECURSO: POLÍTICA DEL BUCKET
# Define los permisos de acceso; cualquiera puede leer los archivos del sitio web
# =====================================================
resource "aws_s3_bucket_policy" "sitio_web" {
  bucket = aws_s3_bucket.sitio_web.id # Aplica esta política al bucket del sitio web

  depends_on = [aws_s3_bucket_public_access_block.sitio_web] # Espera a que se deshabilite el bloqueo público

  policy = jsonencode({
    Version = "2012-10-17" # Versión del lenguaje de políticas de AWS (siempre se usa esta)
    Statement = [
      {
        Sid       = "PublicReadGetObject"              # Identificador descriptivo de esta regla
        Effect    = "Allow"                            # Permite la acción (en vez de denegar)
        Principal = "*"                                # Aplica a cualquier usuario en internet
        Action    = "s3:GetObject"                     # Solo permite leer objetos, no subir ni borrar
        Resource  = "${aws_s3_bucket.sitio_web.arn}/*" # Aplica a todos los archivos dentro del bucket
      }
    ]
  })
}

# =====================================================
# RECURSO: SUBIR index.html AL BUCKET
# Carga el archivo HTML al bucket para que sea servido como página web
# =====================================================
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.sitio_web.id           # Bucket destino donde se sube el archivo
  key          = "index.html"                         # Nombre con el que quedará guardado en S3
  source       = "${path.module}/index.html"          # Ruta local del archivo HTML en nuestro proyecto
  content_type = "text/html"                          # Le indica al navegador que interprete el archivo como HTML
  etag         = filemd5("${path.module}/index.html") # Detecta cambios en el archivo para re-subirlo si fue modificado

  tags = local.tags_comunes # Aplica los tags obligatorios también al objeto S3
}
