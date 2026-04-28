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
# Cualquiera en internet puede leer los archivos del sitio web
# =====================================================
resource "aws_s3_bucket_policy" "sitio_web" {
  bucket = aws_s3_bucket.sitio_web.id # Aplica esta política al bucket del sitio web

  depends_on = [aws_s3_bucket_public_access_block.sitio_web] # Espera a que se deshabilite el bloqueo público primero

  policy = jsonencode({
    Version = "2012-10-17" # Versión del lenguaje de políticas de AWS
    Statement = [
      {
        Sid       = "PublicReadGetObject"               # Identificador descriptivo de esta regla
        Effect    = "Allow"                             # Permite la acción
        Principal = "*"                                 # Aplica a cualquier usuario en internet
        Action    = "s3:GetObject"                      # Solo permite leer objetos, no subir ni borrar
        Resource  = "${aws_s3_bucket.sitio_web.arn}/*" # Aplica a todos los archivos del bucket
      }
    ]
  })
}
