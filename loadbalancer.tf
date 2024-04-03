# SETUP FORWARDING RULE FOR LOADBALACER
resource "google_compute_global_forwarding_rule" "example_forwarding_rule" {
  name                  = var.lb_forwardingrule_name
  target                = google_compute_target_https_proxy.terraform_target_proxy.self_link
  port_range            = var.portrange
  ip_protocol           = var.fr_protocol
  ip_address = google_compute_global_address.lb_ip.id
}

# SETUP TARGET HTTPS PROXY
resource "google_compute_target_https_proxy" "terraform_target_proxy" {
  name               = var.https_name
  url_map            = google_compute_url_map.example_url_map.self_link
  ssl_certificates   = [var.ssl_link]
}

# SETUP URL MAP
resource "google_compute_url_map" "example_url_map" {
  name            = var.url_name
  default_service = google_compute_backend_service.terraform_backend_service.self_link
}
# SETUP BACKEND SERVICE
resource "google_compute_backend_service" "terraform_backend_service" {
  name             = var.lb_back_service_name
 
  protocol         = var.protocol
  timeout_sec      = var.timeout
  health_checks =[google_compute_health_check.terraform-https-health-check.id]
  backend {
    group = google_compute_region_instance_group_manager.terraform_appserver.instance_group
  } 
}

# SETUP HEALTH CHECK FOR BACKEND SERVICE
resource "google_compute_health_check" "terraform-https-health-check" {
  name = var.health_name
  timeout_sec        = var.health_time
  check_interval_sec = var.health_time
  http_health_check {
    port = var.health_port
    request_path = var.req_path
  }
    log_config {
    enable = var.enable 
  } 
}

# SETUP  INSTANCES GROUP MANAGER
resource "google_compute_region_instance_group_manager" "terraform_appserver" {
  name = var.igm
  base_instance_name = var.base
  version {
    instance_template = google_compute_region_instance_template.terraform-template.self_link
  } 
named_port {
    name = var.namedport
    port = var.health_port
  }
  auto_healing_policies {
    health_check      = google_compute_health_check.terraform-https-health-check.self_link
    initial_delay_sec = var.delay
  }
}

# SETUP  Autoscaler
resource "google_compute_region_autoscaler" "terraform_autoscaler" {
  name               = var.autoscale
  target             = google_compute_region_instance_group_manager.terraform_appserver.id
  autoscaling_policy {
    max_replicas     = var.maxreplica
    min_replicas     = var.minreplica
    cooldown_period  = var.coolperiod
  cpu_utilization {
      target = var.target
    }
  }
}

#SETUP LOADBALANCER GLOBAL ADDRESS
resource "google_compute_global_address" "lb_ip" {
  name = var.ip
}

# OUTPUT FOR LOADBALANCER IP
output "load_balancer_ips" {
  value = google_compute_global_address.lb_ip.address
}

