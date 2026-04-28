# =====================================================
# RECURSO: BLOQUEO DE ACCESO PÚBLICO A NIVEL DE CUENTA
# Desactiva el bloqueo de acceso público para toda la cuenta AWS
# Necesario para que el sitio web estático sea accesible desde internet
# =====================================================
resource "aws_s3_account_public_access_block" "cuenta" {
  block_public_acls       = false # Permite ACLs públicas en todos los buckets de la cuenta
  block_public_policy     = false # Permite políticas públicas en todos los buckets de la cuenta
  ignore_public_acls      = false # No ignora las ACLs públicas existentes
  restrict_public_buckets = false # No restringe el acceso público a los buckets
}
