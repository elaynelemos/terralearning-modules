provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../"

  cluster_name       = "app-cluster-example"
  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
}
