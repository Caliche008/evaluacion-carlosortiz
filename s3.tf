# =====================================================
# RECURSO: BUCKET S3
# Crea el contenedor donde se almacenarán los archivos del sitio web
# =====================================================
resource "aws_s3_bucket" "sitio_web" {
  bucket = var.bucket_name # El nombre del bucket viene de variable para hacerlo dinámico

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
    key = "index.html" # Si hay un error (ej: 404), redirige al index.html
  }
}
