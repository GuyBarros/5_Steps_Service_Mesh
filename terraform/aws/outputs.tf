// Primary
output "Primary_Servers_UI" {
  value = module.primary_cluster.servers_ui
}

output "Primary_Workers_UI" {
  value = module.primary_cluster.workers_ui
}

output "Primary_Servers_SSH" {
  value = module.primary_cluster.servers
}

output "Primary_Workers_SSH" {
  value = module.primary_cluster.workers
}

// Secondary
output "Secondary_Servers_UI" {
  value = module.seconday_cluster.servers_ui
}

output "Secondary_Workers_UI" {
  value = module.seconday_cluster.workers_ui
}

output "Secondary_Servers_SSH" {
  value = module.seconday_cluster.servers
}

output "Secondary_Workers_SSH" {
  value = module.seconday_cluster.workers
}