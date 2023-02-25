# AWS Network Skeleton Module
Terraform network skeleton module will create following resources
- VPC
- Internet gateway
- Two public subnet(in different availability zone)
- Two private subnet(in different availability zone)
- Two elasticIP
- Two NAT gateway(in different availability zone)
- Two public route table(in different availability zone)
- Two private route table (in different availability zone)
- Web application security group
- Internet facing application loadbalancer with its target group and listener **Optional**
- Security group for internet facing application loadbalancer **Optional**
- Internal application loadbalancer with its target group and listener **Optional**
- Security group for internal application loadbalancer **Optional**
- VPN Server **Optional**
- Route53 zone

## Module should be used in following way
### Following files should be present
.
├── main.tf
├── output.tf
├── provider.tf
├── terraform.tfvars
└── variables.tf

### In main.tf
```
module "network_skeleton" {
  source                = "path of the module"
  vpc                   = var.vpc
  common_tags           = var.common_tags
  public_subnet         = var.public_subnet
  private_subnet        = var.private_subnet
  internet_facing_lb    = var.internet_facing_lb
  internet_facing_tg    = var.internet_facing_tg
  alb_listener          = var.alb_listener
  create_lb             = var.create_lb
  create_internal_lb    = var.create_internal_lb
  internal_lb           = var.internal_lb
  internal_tg           = var.internal_tg
  internal_alb_listener = var.internal_alb_listener
  vpn_server            = var.vpn_server
  create_vpn_server     = var.create_vpn_server
  dns                   = var.dns
}
```
### In variables.tf
```
variable "vpc" {}
variable "common_tags" {}
variable "public_subnet" {}
variable "private_subnet" {}
variable "internet_facing_lb" {}
variable "internet_facing_tg" {}
variable "alb_listener" {}
variable "create_lb" {}
variable "create_internal_lb" {}
variable "internal_lb" {}
variable "internal_tg" {}
variable "internal_alb_listener" {}
variable "vpn_server" {}
variable "create_vpn_server" {}
variable "dns" {}
```
### In terraform.tfvars
```
vpc = {
  cidr_block           = ""
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "key" = "value"
  }
}
public_subnet = {
  availability_zone = []
  cidr_block        = []
}

private_subnet = {
  availability_zone = []
  cidr_block        = []
}

internet_facing_lb = {
  idle_timeout       = 
  load_balancer_type = "application"
  name_prefix        = "" #  name_prefix should not be more than 6 character

}
internet_facing_tg = {
  name_prefix = "" #  name_prefix should not be more than 6 character

  port        = 
  protocol    = ""
  target_type = "instance"
}
alb_listener = {
  default_action_type = "forward"
  port                = 
  protocol            = "HTTP"
}
create_lb          = true
create_internal_lb = true

internal_lb = {
  idle_timeout       = 60
  load_balancer_type = "application"
  name_prefix        = ""

}
internal_tg = {
  name_prefix = "" #  name_prefix should not be more than 6 character

  port        = 
  protocol    = ""
  target_type = "instance"
}
internal_alb_listener = {
  default_action_type = "forward"
  port                = 
  protocol            = ""
}
vpn_server = {
  ami           = ""
  instance_type = ""
  key_name      = ""

}
create_vpn_server = 
common_tags = {
  "" = ""
}
dns = {
  name = ""
}


```
