//Variables for Provider
variable "project_id" {
  description = "The id of the project"
  type        = string
}
variable "credentials_file" {
  description = "The GCP credentials file path"
  type        = string
}
variable "region" {
  description = "custom_region"
  type        = string
}
variable "zone" {
  description = "custom_zone"
  type        = string
}

//Variables setting for VPC
variable "vpc_name" {
  description = "customization of VPC"
  type        = string

}
variable "auto_create_subnetworks" {
  type    = bool
  default = false

}
variable "routing_mode" {
  type    = string
  default = "REGIONAL"

}
//Variables for Subnets
variable "subnets" {
  description = "The map of custom subnets"
  type = map(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}
variable "private-ip-access" {
  type    = bool
  default = true
}

//Variables for global address
variable "global_address_name" {
  type = string
}
variable "vpc_purpose" {
  type    = string
  default = "VPC_PEERING"
}
variable "address_type" {
  type    = string
  default = "INTERNAL"
}
variable "prefix" {
  type    = string
  default = "16"
}

//Variables for Routes
variable "routes" {
  description = "The map of custom routes"
  type = map(object({
    name              = string
    dest_range        = string
    next_hop_internet = bool
    description       = string
    tags              = list(string)
    vpc_name          = string
  }))
}

//Variables for Firewall
variable "firewall_vpc" {
  description = "The name of the VPC where firewall rules will be applied"
  type        = string
}
variable "app-allow-name" {
  type = string
}
variable "allow-protocol-name" {
  type = string
}
variable "deny-ssh-Name" {
  type = string
}
variable "source_ranges" {
  type    = string
  default = "0.0.0.0/0"
}
variable "port" {
  type    = string
  default = "22"
}
variable "application_port" {
  description = "The port your application listens to"
  type        = number
}


//Variables for creating Regional compute instances template
variable "template_name" {
  description = "Name of the instance"
  type        = string
}
variable "machine_type" {
  description = "Machine type of the instance"
  type        = string
}
variable "image" {
  description = "Boot disk image of the instance"
  type        = string
}
variable "boot_disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
}
variable "instance_subnet" {
  description = "The name of the subnet for the instance"
  type        = string
}
variable "auto_del" {
  type = bool
  default = true
}
variable "tag_name" {
  type = string
  default = "webapp"
}

//Variables for SQL intances 
variable "sql_instance_name" {
  type = string
}
variable "db_version" {
  type = string
}
variable "ipv4_enable" {
  type    = bool
  default = false
}
variable "del_proctection-rule" {
  type    = bool
  default = false
}
variable "db_machine_type" {
  type = string
}
variable "autoresize" {
  type    = bool
  default = true
}
variable "disktype" {
  type = string
}
variable "disksize" {
  type = string
}

//Variables for Database
variable "dbname" {
  type = string
}
variable "username" {
  type = string
}
variable "passlen" {
  type    = string
  default = "16"
}
variable "spl" {
  type    = bool
  default = false
}

//Variables for DNS-A record
variable "dns-name" {
  type    = string
  default = "poojacloud24.pw."
}
variable "recordtype" {
  type    = string
  default = "A"
}
variable "ttl" {
  type    = string
  default = "300"

}
variable "managedzonename" {
  type    = string
  default = "cloud-demo-pw"
}

//Variables for Service account 
variable "serviceid" {
  type = string
}
variable "serviceaccname" {
  type = string
}
variable "log_name" {
  type = string
  default = "roles/logging.admin"
}
variable "metric_name" {
  type = string
  default = "roles/monitoring.metricWriter"
}
variable "scopes_list" {
  type = list(string)
  default = ["logging-write", "monitoring-write", "pubsub"]
}
variable "pub_role" {
  type = string
  default = "roles/pubsub.publisher"
}
variable "sub_role" {
  type = string
  default = "roles/pubsub.subscriber"
}
//PubSub and cloud fn variables
variable "pub_name" {
  type = string
}
variable "ret_time" {
  type    = string
  default = "604800s"
}
variable "sub_name" {
  type = string
}
variable "ack" {
  type    = string
  default = "20"
}
variable "connector" {
  type    = string
  default = "serverlessvpc"
}
variable "serverlessip" {
  type    = string
  default = "10.0.3.0/28"
}
variable "fun_entrypoint" {
  type    = string
  default = "newUserAccount"
}
variable "mailgun_api_key" {
  type    = string
  default = "c866ff59ac6b06a600bd18469e6a6351-f68a26c9-0e033e20"
}
variable "mydomain_name" {
  type    = string
  default = "poojacloud24.pw"
}
variable "cloudfn" {
  type=string
}
variable "runtime" {
  type = string
  default = "nodejs20"
}
variable "type" {
  type = string
  default = "zip"
}
variable "max" {
  type = string
  default = "1"
}
variable "memory" {
  type = string
  default = "256Mi"
}
variable "settings" {
  type = string
  default = "ALLOW_INTERNAL_ONLY"
}
variable "engress" {
  type = string
  default = "PRIVATE_RANGES_ONLY"
}
variable "event" {
  type = string
  default = "google.cloud.pubsub.topic.v1.messagePublished"
}
variable "retry" {
  type = string
  default = "RETRY_POLICY_DO_NOT_RETRY"
}
variable "role_cloudfn" {
  type = string
  default = "roles/cloudfunctions.invoker"
}
variable "loc" {
  type = string
  default = "US"
}

//Variables for Loadbalancer
variable "lb_forwardingrule_name" {
  type = string
}
variable "portrange" {
  type = string
  default = "443"
}
variable "fr_protocol" {
  type = string
  default = "TCP"
}
variable "https_name" {
  type =string
}
variable "ssl_link" {
  type = string
  default = "projects/dev-imageterraform-testing/global/sslCertificates/cloudsslcertificate"
}
variable "url_name" {
  type = string
}
variable "lb_back_service_name" {
  type = string
}
variable "protocol" {
  type = string
  default = "HTTP"
}
variable "timeout" {
  type = string
  default = "30"
}
variable "health_name" {
  type = string
}
variable "health_port" {
  type = string
  default = "8080"
}
variable "health_time" {
  type = string
  default = "60"
}
variable "req_path" {
  type = string
  default ="/healthz"
}
variable "enable" {
  type=bool
  default = true
}
variable "igm" {
  type = string
}
variable "base" {
  type = string
  default = "app"
}
variable "namedport" {
  type = string
  default = "http"
}
variable "delay" {
  type = string
  default = "300"
}
variable "autoscale" {
  type = string
}
variable "minreplica" {
  type = string
  default = "1"
}
variable "maxreplica" {
  type = string
  default = "5"
}
variable "coolperiod" {
  type = string
  default = "60"
}
variable "target" {
  type = string  
  default = "0.05"
}
variable "ip" {
  type = string
}