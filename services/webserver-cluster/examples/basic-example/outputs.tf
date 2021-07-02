output "clb_dns_name" {
  value       = module.webserver_cluster.clb_dns_name
  description = "The domain name of the load balancer."
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "The name of the autoscaling group."
}
