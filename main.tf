provider "google" {
  credentials = file("service-account-key.json")
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance_template" "instance_template" {
  name_prefix = "${var.name}-template"
  machine_type = var.machine_type
  region       = var.region

  tags = ["web-server"]

  disk {
    auto_delete = true
    boot        = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network    = "default"
    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = file("./startup.sh")
}

resource "google_compute_region_instance_group_manager" "mig" {
  name                  = "${var.name}-mig"
  base_instance_name    = "${var.name}-instance"
  region                = var.region
  version {
    instance_template = google_compute_instance_template.instance_template.self_link
  }
  target_size = 2

  auto_healing_policies {
    health_check      = google_compute_region_health_check.health_check.self_link
    initial_delay_sec = 300
  }

  depends_on = [google_compute_instance_template.instance_template]
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name = "${lower(var.name)}-autoscaler"
  region  = var.region
  target  = google_compute_region_instance_group_manager.mig.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cpu_utilization {
      target = 0.6
    }
  }

  depends_on = [google_compute_region_instance_group_manager.mig]
}

resource "google_compute_region_health_check" "health_check" {
  name                = "${var.name}-health-check"
  region              = var.region
  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_firewall" "health_check_firewall" {
  name = "${lower(var.name)}-hc-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}