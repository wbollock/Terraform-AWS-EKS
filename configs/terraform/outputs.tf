output "database_endpoint" {
  value = module.database.this_db_instance_address
}

output "cluster_endpoint" {
  value = module.wordpress-prod.cluster_endpoint
}

