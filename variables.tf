variable "zone_id" {
  description = "ID of the Route 53 hosted zone in which to create the record"
  type        = string

  validation {
    condition = (
      (
        var.alias_name != null && var.alias_zone_id != null &&
        var.records == null && var.ttl == null
      ) ||
      (
        var.alias_name == null && var.alias_zone_id == null &&
        var.records != null && var.ttl != null
      )
    )
    error_message = "Exactly one mode must be used: provide alias_name and alias_zone_id (alias mode) or provide records and ttl (simple mode)."
  }
}

variable "name" {
  description = "Record name (relative or absolute)"
  type        = string
}

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
  description = "Whether to evaluate the health of the alias target"
  type        = bool
  default     = true
}

variable "create_aaaa" {
  description = "Whether to create an AAAA alias record alongside the A record"
  type        = bool
  default     = false
}

variable "records" {
  description = "List of record values for simple (non-alias) records. Required for simple mode."
  type        = list(string)
  default     = null
}

variable "ttl" {
  description = "TTL for simple records. Required for simple mode."
  type        = number
  default     = null
}

variable "type" {
  description = "Record type for simple records"
  type        = string
  default     = "A"
}
