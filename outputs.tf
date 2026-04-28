# =====================================================
# OUTPUTS
# Valores que Terraform muestra al terminar el despliegue
# =====================================================

# Muestra la URL pública del sitio web estático alojado en S3
output "url_sitio_web" {
  description = "URL pública para acceder al sitio web estático desde el navegador"
  value       = "http://${aws_s3_bucket_website_configuration.sitio_web.website_endpoint}"
  # Construye la URL completa concatenando el protocolo http:// con el endpoint generado por S3
}

# Muestra el nombre del bucket creado (útil para verificar)
output "nombre_bucket" {
  description = "Nombre del bucket S3 creado"
  value       = aws_s3_bucket.sitio_web.id
}

# Muestra la región donde se desplegó
output "region_desplegada" {
  description = "Región de AWS donde se desplegó el bucket"
  value       = var.region
}
