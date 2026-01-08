output "fqdn" {
  description = "Fully qualified domain name of the record."
  value = coalesce(
    try(aws_route53_record.alias_a[0].fqdn, null),
    try(aws_route53_record.simple[0].fqdn, null)
  )
}

output "name" {
  description = "Name of the record."
  value = coalesce(
    try(aws_route53_record.alias_a[0].name, null),
    try(aws_route53_record.simple[0].name, null)
  )
}

output "type" {
  description = "Type of the record."
  value = coalesce(
    try(aws_route53_record.alias_a[0].type, null),
    try(aws_route53_record.simple[0].type, null)
  )
}

output "zone_id" {
  description = "Hosted zone ID containing the record."
  value = coalesce(
    try(aws_route53_record.alias_a[0].zone_id, null),
    try(aws_route53_record.simple[0].zone_id, null)
  )
}

output "alias_a_fqdn" {
  description = "FQDN of the A alias record (if created)."
  value       = try(aws_route53_record.alias_a[0].fqdn, null)
}

output "alias_aaaa_fqdn" {
  description = "FQDN of the AAAA alias record (if created)."
  value       = try(aws_route53_record.alias_aaaa[0].fqdn, null)
}
