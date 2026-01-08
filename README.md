# terraform-aws-route53-records

Terraform module that creates Route 53 DNS records with support for alias targets, routing policies, and health checks.

## Features

- **Alias records** - Point to ALB, CloudFront, S3, and other AWS resources
- **Simple records** - Standard DNS records with TTL
- **Routing policies** - Weighted, latency, geolocation, failover, multivalue
- **Health checks** - Associate health checks with records
- **IPv6 support** - Create AAAA alias records alongside A records
- **Comprehensive validation** - Zone ID, record types, routing policy parameters

## Usage

### ALB Alias Record

```hcl
module "app_dns" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id       = "Z0123456789ABC"
  name          = "app.example.com"
  alias_name    = module.alb.dns_name
  alias_zone_id = module.alb.zone_id

  evaluate_target_health = true
  create_aaaa            = true
}
```

### Simple A Record

```hcl
module "server_dns" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id = "Z0123456789ABC"
  name    = "server.example.com"
  type    = "A"
  ttl     = 300
  records = ["203.0.113.10"]
}
```

### CNAME Record

```hcl
module "www_redirect" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id = "Z0123456789ABC"
  name    = "www.example.com"
  type    = "CNAME"
  ttl     = 300
  records = ["example.com"]
}
```

### MX Records

```hcl
module "mail" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id = "Z0123456789ABC"
  name    = "example.com"
  type    = "MX"
  ttl     = 3600
  records = [
    "10 mail1.example.com",
    "20 mail2.example.com"
  ]
}
```

### Weighted Routing

```hcl
module "api_blue" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id        = "Z0123456789ABC"
  name           = "api.example.com"
  type           = "A"
  ttl            = 60
  records        = ["203.0.113.10"]
  routing_policy = "weighted"
  set_identifier = "blue"
  weight         = 70
}

module "api_green" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id        = "Z0123456789ABC"
  name           = "api.example.com"
  type           = "A"
  ttl            = 60
  records        = ["203.0.113.20"]
  routing_policy = "weighted"
  set_identifier = "green"
  weight         = 30
}
```

### Latency-Based Routing

```hcl
module "api_us_east" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id        = "Z0123456789ABC"
  name           = "api.example.com"
  alias_name     = module.alb_us_east.dns_name
  alias_zone_id  = module.alb_us_east.zone_id
  routing_policy = "latency"
  set_identifier = "us-east-1"
  latency_region = "us-east-1"
}

module "api_eu_west" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id        = "Z0123456789ABC"
  name           = "api.example.com"
  alias_name     = module.alb_eu_west.dns_name
  alias_zone_id  = module.alb_eu_west.zone_id
  routing_policy = "latency"
  set_identifier = "eu-west-1"
  latency_region = "eu-west-1"
}
```

### Geolocation Routing

```hcl
module "site_europe" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id               = "Z0123456789ABC"
  name                  = "www.example.com"
  type                  = "A"
  ttl                   = 300
  records               = ["203.0.113.10"]
  routing_policy        = "geolocation"
  set_identifier        = "europe"
  geolocation_continent = "EU"
}

module "site_default" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id              = "Z0123456789ABC"
  name                 = "www.example.com"
  type                 = "A"
  ttl                  = 300
  records              = ["203.0.113.20"]
  routing_policy       = "geolocation"
  set_identifier       = "default"
  geolocation_country  = "*"
}
```

### Failover Routing

```hcl
module "primary" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id         = "Z0123456789ABC"
  name            = "app.example.com"
  alias_name      = module.alb_primary.dns_name
  alias_zone_id   = module.alb_primary.zone_id
  routing_policy  = "failover"
  set_identifier  = "primary"
  failover_type   = "PRIMARY"
  health_check_id = aws_route53_health_check.primary.id
}

module "secondary" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id        = "Z0123456789ABC"
  name           = "app.example.com"
  alias_name     = module.alb_secondary.dns_name
  alias_zone_id  = module.alb_secondary.zone_id
  routing_policy = "failover"
  set_identifier = "secondary"
  failover_type  = "SECONDARY"
}
```

### With Health Check

```hcl
resource "aws_route53_health_check" "app" {
  fqdn              = "app.example.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30
}

module "app_dns" {
  source = "ogulcanaydogan/route53-records/aws"

  zone_id         = "Z0123456789ABC"
  name            = "app.example.com"
  type            = "A"
  ttl             = 60
  records         = ["203.0.113.10"]
  health_check_id = aws_route53_health_check.app.id
}
```

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| `zone_id` | Route 53 hosted zone ID | `string` |
| `name` | DNS record name | `string` |

### Record Values (choose one mode)

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `alias_name` | Alias target DNS name | `string` | `null` |
| `alias_zone_id` | Alias target zone ID | `string` | `null` |
| `records` | Record values (simple mode) | `list(string)` | `null` |
| `ttl` | TTL in seconds (simple mode) | `number` | `null` |

### Record Configuration

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `type` | DNS record type | `string` | `"A"` |
| `evaluate_target_health` | Evaluate alias target health | `bool` | `true` |
| `create_aaaa` | Create AAAA alias record | `bool` | `false` |
| `allow_overwrite` | Allow overwriting existing records | `bool` | `false` |
| `health_check_id` | Health check ID | `string` | `null` |

### Routing Policies

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `routing_policy` | Policy type (simple, weighted, latency, geolocation, failover, multivalue) | `string` | `"simple"` |
| `set_identifier` | Unique identifier (required for non-simple) | `string` | `null` |
| `weight` | Weight (0-255) for weighted routing | `number` | `null` |
| `latency_region` | AWS region for latency routing | `string` | `null` |
| `geolocation_continent` | Continent code (AF, AN, AS, EU, OC, NA, SA) | `string` | `null` |
| `geolocation_country` | Country code (ISO 3166-1 alpha-2) | `string` | `null` |
| `geolocation_subdivision` | Subdivision code (US states, CA provinces) | `string` | `null` |
| `failover_type` | Failover type (PRIMARY, SECONDARY) | `string` | `null` |
| `multivalue_answer` | Enable multivalue answer | `bool` | `false` |

## Outputs

| Name | Description |
|------|-------------|
| `fqdn` | Fully qualified domain name |
| `name` | Record name |
| `type` | Record type |
| `zone_id` | Hosted zone ID |
| `alias_a_fqdn` | FQDN of A alias record |
| `alias_aaaa_fqdn` | FQDN of AAAA alias record |

## Examples

See [`examples/basic`](./examples/basic) for working configurations.
