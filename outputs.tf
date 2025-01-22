output "instance_template_id" {
  description = "ID of the instance template"
  value       = google_compute_instance_template.instance_template.id
}

output "instance_group_manager_name" {
  description = "Name of the managed instance group"
  value       = google_compute_region_instance_group_manager.mig.name
}

output "autoscaler_name" {
  description = "Name of the autoscaler"
  value       = google_compute_region_autoscaler.autoscaler.name
}

output "health_check_name" {
  description = "Name of the health check"
  value       = google_compute_region_health_check.health_check.name
}

output "firewall_name" {
  description = "Name of the health check firewall rule"
  value       = google_compute_firewall.health_check_firewall.name
}