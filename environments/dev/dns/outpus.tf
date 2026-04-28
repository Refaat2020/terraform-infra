output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "zone_id" {
  value = module.dns.zone_id
}