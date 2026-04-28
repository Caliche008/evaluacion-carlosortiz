# =====================================================
# BLOQUE TERRAFORM
# Define los requisitos mínimos para ejecutar este código
# =====================================================
terraform {
  required_version = ">= 1.5" # Indica que se necesita Terraform 1.5 o superior para correr este proyecto

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Proveedor AWS viene del registro oficial de HashiCorp
      version = "~> 5.0"        # Permite cualquier versión 5.x pero no saltar a la 6.0
    }
  }
}

# =====================================================
# PROVEEDOR AWS
# Le dice a Terraform con qué nube trabajar y en qué región
# =====================================================
provider "aws" {
  region = var.region # Usa la variable 'region' para no tener la región escrita a mano
}

# =====================================================
# LOCALS
# Variables internas reutilizables con los tags obligatorios
# Todos los valores vienen de variables — sin hardcoding
# =====================================================
locals {
  tags_comunes = {
    Environment = var.environment # Ambiente tomado de variable
    Owner       = var.owner       # Nombre del responsable del proyecto
    Project     = var.project     # Nombre del proyecto
  }
}
