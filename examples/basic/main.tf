variable "region" {
  description = "AWS region for the provider"
  type        = string
  default     = "us-east-1"
}

variable "hosted_zone_id" {
  description = "Hosted zone ID where the records will be created"
  type        = string
  default     = "Z0000000000000"
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer to target via alias"
  type        = string
  default     = "example-alb-1234567890.us-east-1.elb.amazonaws.com"
}

variable "alb_zone_id" {
  description = "Route 53 hosted zone ID of the ALB"
  type        = string
  default     = "Z35SXDOTRQ7X7K"
}

module "alias_record" {
  source = "../../"

  zone_id       = var.hosted_zone_id
  name          = "alb-alias.example.com"
  alias_name    = var.alb_dns_name
  alias_zone_id = var.alb_zone_id

  evaluate_target_health = true
  create_aaaa            = true
}

module "simple_record" {
  source = "../../"

  zone_id = var.hosted_zone_id
  name    = "simple.example.com"
  ttl     = 300
  type    = "A"
  records = ["203.0.113.10"]
}
