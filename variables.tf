variable "zone_id" {
  description = "ID of the Route 53 hosted zone."
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.zone_id))
    error_message = "zone_id must be a valid Route 53 hosted zone ID (e.g., Z0123456789ABC)."
  }
}

variable "name" {
  description = "DNS record name (e.g., 'app' for app.example.com or 'app.example.com' for absolute)."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "type" {
  description = "DNS record type."
  type        = string
  default     = "A"

  validation {
    condition     = contains(["A", "AAAA", "CNAME", "MX", "TXT", "PTR", "SRV", "SPF", "NAPTR", "CAA", "NS", "SOA", "DS"], var.type)
    error_message = "type must be a valid DNS record type (A, AAAA, CNAME, MX, TXT, PTR, SRV, SPF, NAPTR, CAA, NS, SOA, DS)."
  }
}

# Simple record mode
variable "records" {
  description = "List of record values. Required for simple (non-alias) records."
  type        = list(string)
  default     = null
}

variable "ttl" {
  description = "TTL in seconds for simple records. Required for simple mode."
  type        = number
  default     = null

  validation {
    condition     = var.ttl == null || (var.ttl >= 0 && var.ttl <= 2147483647)
    error_message = "ttl must be between 0 and 2147483647 seconds."
  }
}

# Alias mode
variable "alias_name" {
  description = "DNS name of the alias target (e.g., ALB DNS name). Required for alias mode."
  type        = string
  default     = null
}

variable "alias_zone_id" {
  description = "Hosted zone ID of the alias target. Required for alias mode."
  type        = string
  default     = null
}

variable "evaluate_target_health" {
  description = "Whether Route 53 should evaluate the health of the alias target."
  type        = bool
  default     = true
}

variable "create_aaaa" {
  description = "Create an AAAA alias record alongside the A record (alias mode only)."
  type        = bool
  default     = false
}

# Routing policies
variable "routing_policy" {
  description = "Routing policy type: simple, weighted, latency, geolocation, failover, or multivalue."
  type        = string
  default     = "simple"

  validation {
    condition     = contains(["simple", "weighted", "latency", "geolocation", "failover", "multivalue"], var.routing_policy)
    error_message = "routing_policy must be one of: simple, weighted, latency, geolocation, failover, multivalue."
  }
}

variable "set_identifier" {
  description = "Unique identifier for routing policies (required for non-simple policies)."
  type        = string
  default     = null
}

variable "weight" {
  description = "Weight for weighted routing policy (0-255)."
  type        = number
  default     = null

  validation {
    condition     = var.weight == null || (var.weight >= 0 && var.weight <= 255)
    error_message = "weight must be between 0 and 255."
  }
}

variable "latency_region" {
  description = "AWS region for latency-based routing."
  type        = string
  default     = null
}

variable "geolocation_continent" {
  description = "Continent code for geolocation routing (AF, AN, AS, EU, OC, NA, SA)."
  type        = string
  default     = null

  validation {
    condition     = var.geolocation_continent == null || contains(["AF", "AN", "AS", "EU", "OC", "NA", "SA"], var.geolocation_continent)
    error_message = "geolocation_continent must be one of: AF, AN, AS, EU, OC, NA, SA."
  }
}

variable "geolocation_country" {
  description = "Country code for geolocation routing (ISO 3166-1 alpha-2)."
  type        = string
  default     = null
}

variable "geolocation_subdivision" {
  description = "Subdivision code for geolocation routing (US states, CA provinces)."
  type        = string
  default     = null
}

variable "failover_type" {
  description = "Failover record type: PRIMARY or SECONDARY."
  type        = string
  default     = null

  validation {
    condition     = var.failover_type == null || contains(["PRIMARY", "SECONDARY"], var.failover_type)
    error_message = "failover_type must be PRIMARY or SECONDARY."
  }
}

variable "multivalue_answer" {
  description = "Enable multivalue answer routing."
  type        = bool
  default     = false
}

# Health check
variable "health_check_id" {
  description = "Health check ID to associate with the record."
  type        = string
  default     = null
}

# Options
variable "allow_overwrite" {
  description = "Allow overwriting existing records."
  type        = bool
  default     = false
}
