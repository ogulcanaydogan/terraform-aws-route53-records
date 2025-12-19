# terraform-aws-route53-records

Terraform module that manages Route 53 DNS records with first-class support for Application Load Balancer (ALB) alias targets. The module can create alias A/AAAA records or simple records with explicit values.

## Features
- Alias A record to ALB (with optional AAAA alias)
- Simple record mode for non-alias records
- Input validation to prevent ambiguous configurations
- Terraform Registry-ready structure with example usage

## Usage

### Alias record pointing to an ALB
Use outputs from your ALB module (for example, `dns_name` and `zone_id`) to create alias A/AAAA records in your hosted zone.

```hcl
module "alb_alias_record" {
  source = "path/to/module"

  zone_id  = "Z0000000000000"            # Hosted zone receiving the record
  name     = "app.example.com"           # Record name
  alias_name   = module.alb.dns_name      # ALB DNS name
  alias_zone_id = module.alb.zone_id      # ALB hosted zone ID

  evaluate_target_health = true
  create_aaaa            = true
}
```

### Simple A record
Provide record values and TTL for non-alias records.

```hcl
module "simple_record" {
  source = "path/to/module"

  zone_id = "Z0000000000000"
  name    = "simple.example.com"
  ttl     = 300
  type    = "A"
  records = ["203.0.113.10"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `zone_id` | ID of the Route 53 hosted zone in which to create the record | `string` | n/a | yes |
| `name` | Record name (relative or absolute) | `string` | n/a | yes |
| `alias_name` | DNS name of the alias target (e.g., ALB DNS name). Required for alias mode. | `string` | `null` | no |
| `alias_zone_id` | Hosted zone ID of the alias target. Required for alias mode. | `string` | `null` | no |
| `evaluate_target_health` | Whether to evaluate the health of the alias target | `bool` | `true` | no |
| `create_aaaa` | Whether to create an AAAA alias record alongside the A record | `bool` | `false` | no |
| `records` | List of record values for simple (non-alias) records. Required for simple mode. | `list(string)` | `null` | no |
| `ttl` | TTL for simple records. Required for simple mode. | `number` | `null` | no |
| `type` | Record type for simple records | `string` | `"A"` | no |

### Validation rules
- Exactly one mode must be configured: alias (`alias_name` + `alias_zone_id`) **or** simple (`records` + `ttl`).
- `alias_name` and `alias_zone_id` must both be set or both be null.
- `records` and `ttl` must both be set or both be null.

## Outputs

| Name | Description |
|------|-------------|
| `fqdn` | Fully qualified DNS name of the record |
| `record_name` | Record name |
| `zone_id` | Hosted zone ID containing the record |

## Examples

See [`examples/basic`](examples/basic) for a complete configuration demonstrating both alias and simple record modes.
