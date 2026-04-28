# =====================================================
# RECURSO: SUBIR index.html AL BUCKET
# Carga el archivo HTML al bucket para que sea servido como página web
# =====================================================
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.sitio_web.id          # Bucket destino donde se sube el archivo
  key          = "index.html"                         # Nombre con el que quedará guardado en S3
  source       = "${path.module}/index.html"          # Ruta local del archivo HTML en el proyecto
  content_type = "text/html"                          # Le indica al navegador que interprete el archivo como HTML
  etag         = filemd5("${path.module}/index.html") # Detecta cambios en el archivo para re-subirlo si fue modificado

  tags = local.tags_comunes # Aplica los tags obligatorios también al objeto S3
}
