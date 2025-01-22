variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
}

variable "name" {
  description = "Prefix for instance and resource names"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the instance template"
  type        = string
  default     = "e2-micro" # Default value, can be overridden
}