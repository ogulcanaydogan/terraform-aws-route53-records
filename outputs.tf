output "fqdn" {
  description = "Fully qualified DNS name of the record"
  value       = local.alias_mode ? aws_route53_record.alias_a[0].fqdn : (local.simple_mode ? aws_route53_record.simple[0].fqdn : null)
}

output "record_name" {
  description = "Record name"
  value       = local.alias_mode ? aws_route53_record.alias_a[0].name : (local.simple_mode ? aws_route53_record.simple[0].name : null)
}

output "zone_id" {
  description = "Hosted zone ID containing the record"
  value       = local.alias_mode ? aws_route53_record.alias_a[0].zone_id : (local.simple_mode ? aws_route53_record.simple[0].zone_id : null)
}
