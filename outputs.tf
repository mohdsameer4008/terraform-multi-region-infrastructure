output "east_vpc_id" {
  description = "VPC ID created in us-east-1"
  value       = module.vpc_east.vpc_id
}

output "west_vpc_id" {
  description = "VPC ID created in us-west-2"
  value       = module.vpc_west.vpc_id
}

output "east_public_subnet_ids" {
  description = "Public subnet IDs in us-east-1"
  value       = module.vpc_east.public_subnet_ids
}

output "west_public_subnet_ids" {
  description = "Public subnet IDs in us-west-2"
  value       = module.vpc_west.public_subnet_ids
}

output "east_private_subnet_ids" {
  description = "Private subnet IDs in us-east-1"
  value       = module.vpc_east.private_subnet_ids
}

output "west_private_subnet_ids" {
  description = "Private subnet IDs in us-west-2"
  value       = module.vpc_west.private_subnet_ids
}
