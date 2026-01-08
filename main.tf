locals {
  is_alias  = var.alias_name != null && var.alias_zone_id != null
  is_simple = var.records != null && var.ttl != null
}

# Alias A record
resource "aws_route53_record" "alias_a" {
  count = local.is_alias ? 1 : 0

  zone_id         = var.zone_id
  name            = var.name
  type            = "A"
  allow_overwrite = var.allow_overwrite

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }

  # Routing policies
  set_identifier = var.routing_policy != "simple" ? var.set_identifier : null

  dynamic "weighted_routing_policy" {
    for_each = var.routing_policy == "weighted" ? [1] : []
    content {
      weight = var.weight
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.routing_policy == "latency" ? [1] : []
    content {
      region = var.latency_region
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = var.routing_policy == "geolocation" ? [1] : []
    content {
      continent   = var.geolocation_continent
      country     = var.geolocation_country
      subdivision = var.geolocation_subdivision
    }
  }

  dynamic "failover_routing_policy" {
    for_each = var.routing_policy == "failover" ? [1] : []
    content {
      type = var.failover_type
    }
  }

  health_check_id                  = var.health_check_id
  multivalue_answer_routing_policy = var.routing_policy == "multivalue" ? var.multivalue_answer : null
}

# Alias AAAA record
resource "aws_route53_record" "alias_aaaa" {
  count = local.is_alias && var.create_aaaa ? 1 : 0

  zone_id         = var.zone_id
  name            = var.name
  type            = "AAAA"
  allow_overwrite = var.allow_overwrite

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }

  # Routing policies
  set_identifier = var.routing_policy != "simple" ? var.set_identifier : null

  dynamic "weighted_routing_policy" {
    for_each = var.routing_policy == "weighted" ? [1] : []
    content {
      weight = var.weight
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.routing_policy == "latency" ? [1] : []
    content {
      region = var.latency_region
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = var.routing_policy == "geolocation" ? [1] : []
    content {
      continent   = var.geolocation_continent
      country     = var.geolocation_country
      subdivision = var.geolocation_subdivision
    }
  }

  dynamic "failover_routing_policy" {
    for_each = var.routing_policy == "failover" ? [1] : []
    content {
      type = var.failover_type
    }
  }

  health_check_id                  = var.health_check_id
  multivalue_answer_routing_policy = var.routing_policy == "multivalue" ? var.multivalue_answer : null
}

# Simple record (non-alias)
resource "aws_route53_record" "simple" {
  count = local.is_simple && !local.is_alias ? 1 : 0

  zone_id         = var.zone_id
  name            = var.name
  type            = var.type
  ttl             = var.ttl
  records         = var.records
  allow_overwrite = var.allow_overwrite

  # Routing policies
  set_identifier = var.routing_policy != "simple" ? var.set_identifier : null

  dynamic "weighted_routing_policy" {
    for_each = var.routing_policy == "weighted" ? [1] : []
    content {
      weight = var.weight
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.routing_policy == "latency" ? [1] : []
    content {
      region = var.latency_region
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = var.routing_policy == "geolocation" ? [1] : []
    content {
      continent   = var.geolocation_continent
      country     = var.geolocation_country
      subdivision = var.geolocation_subdivision
    }
  }

  dynamic "failover_routing_policy" {
    for_each = var.routing_policy == "failover" ? [1] : []
    content {
      type = var.failover_type
    }
  }

  health_check_id                  = var.health_check_id
  multivalue_answer_routing_policy = var.routing_policy == "multivalue" ? var.multivalue_answer : null
}
