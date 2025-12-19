locals {
  alias_mode  = var.alias_name != null && var.alias_zone_id != null && var.records == null && var.ttl == null
  simple_mode = var.alias_name == null && var.alias_zone_id == null && var.records != null && var.ttl != null
}

resource "aws_route53_record" "alias_a" {
  count = local.alias_mode ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

resource "aws_route53_record" "alias_aaaa" {
  count = local.alias_mode && var.create_aaaa ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = "AAAA"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

resource "aws_route53_record" "simple" {
  count = local.simple_mode ? 1 : 0

  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl
  records = var.records
}
