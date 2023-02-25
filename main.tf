# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_details.cidr_block
  enable_dns_support   = var.vpc_details.enable_dns_support
  enable_dns_hostnames = var.vpc_details.enable_dns_hostnames
  tags = merge(
    { "Name" = "${var.tags.Name}-vpc" },
    { "ManagedBy" = var.tags.ManagedBy },
    var.vpc_details.tags,
  )
}
# Creating IGW 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = "${var.tags.Name}-igw" },
    { "ManagedBy" = var.tags.ManagedBy },
    var.igw_tags,
  )
}
# Elastic IP for NAT gateway
resource "aws_eip" "aza_nat_eip" {
  vpc = true
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.eip_tags,
  )
}
# NAT Gateway1
resource "aws_nat_gateway" "aza_nat" {
  allocation_id = aws_eip.aza_nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.nat_tags,
  )
}
resource "aws_eip" "azb_nat_eip" {
  vpc = true
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.eip_tags,
  )
}
# NAT Gateway2
resource "aws_nat_gateway" "azb_nat" {
  allocation_id = aws_eip.azb_nat_eip.id
  subnet_id     = aws_subnet.public_subnet[1].id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.nat_tags,
  )
}
# Public Route Table
resource "aws_route_table" "public_aza" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.route_table_tags,
  )
}
# Public routes
resource "aws_route" "public_aza" {
  route_table_id         = aws_route_table.public_aza.id
  destination_cidr_block = var.public_route_dest_cidr
  gateway_id             = aws_internet_gateway.igw.id
}
# Public Route Table
resource "aws_route_table" "public_azb" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.route_table_tags,
  )
}
# Public routes
resource "aws_route" "public_azb" {
  route_table_id         = aws_route_table.public_azb.id
  destination_cidr_block = var.public_route_dest_cidr
  gateway_id             = aws_internet_gateway.igw.id
}
# Private Route Table
resource "aws_route_table" "private_aza" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.route_table_tags,
  )
}
# Private Routes
resource "aws_route" "private_aza" {
  route_table_id         = aws_route_table.private_aza.id
  destination_cidr_block = var.public_route_dest_cidr
  nat_gateway_id         = aws_nat_gateway.aza_nat.id
}
resource "aws_route_table" "private_azb" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.route_table_tags,
  )
}
# Private Routes
resource "aws_route" "private_azb" {
  route_table_id         = aws_route_table.private_azb.id
  destination_cidr_block = var.public_route_dest_cidr
  nat_gateway_id         = aws_nat_gateway.azb_nat.id
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_details.cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_details.cidr_block[count.index]
  availability_zone = var.public_subnet_details.availability_zone[count.index]
  tags = merge(
    { "Name" = "${var.tags.Name}-pub" },
    { "ManagedBy" = var.tags.ManagedBy },
    var.public_subnet_details.tags,
  )
}
# Public Subnet Route Associations
resource "aws_route_table_association" "public_aza" {
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_aza.id
}
resource "aws_route_table_association" "public_azb" {
  subnet_id      = aws_subnet.public_subnet[1].id
  route_table_id = aws_route_table.public_azb.id
}
# Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_details.cidr_block)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_details.cidr_block[count.index]
  availability_zone = var.private_subnet_details.availability_zone[count.index]
  tags = merge(
    { "Name" = "${var.tags.Name}-pvt" },
    { "ManagedBy" = var.tags.ManagedBy },
    var.private_subnet_details.tags,
  )
}
# Private Subnet Route Associations
resource "aws_route_table_association" "private_aza" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_aza.id
}
resource "aws_route_table_association" "private_azb" {
  subnet_id      = aws_subnet.private_subnet[1].id
  route_table_id = aws_route_table.private_azb.id
}
# Web application security group
resource "aws_security_group" "web_app_sg" {
  name        = "${var.tags.Name}-web-app-sg"
  description = "Security Group for all web application"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.web_app_sg_tags,
  )
}
resource "aws_security_group_rule" "web_app_sg_rule" {
  security_group_id = aws_security_group.web_app_sg.id
  type              = "ingress"
  count             = length(var.web_app_sg_rule_ingress.port)
  protocol          = "tcp"
  from_port         = var.web_app_sg_rule_ingress.port[count.index]
  to_port           = var.web_app_sg_rule_ingress.port[count.index]
  cidr_blocks       = var.web_app_sg_rule_ingress.cidr_blocks
  description       = "sg for lb"
}

# Load Balancer SG
resource "aws_security_group" "internet_facing_lb_sg" {
  count       = var.create_lb ? 1 : 0
  name        = "${var.tags.Name}-alb-sg"
  description = "Security group for internet facing loadbalancer"
  vpc_id      = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.internet_facing_lb_sg_tags,
  )
}
# Internet facting ALB 
resource "aws_lb" "internet_facing_lb" {
  count              = var.create_lb ? 1 : 0
  name_prefix        = var.internet_facing_lb_details.name_prefix
  load_balancer_type = var.internet_facing_lb_details.load_balancer_type
  security_groups    = [aws_security_group.internet_facing_lb_sg[0].id, aws_security_group.web_app_sg.id]
  subnets            = aws_subnet.public_subnet.*.id
  idle_timeout       = var.internet_facing_lb_details.idle_timeout
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.internet_facing_lb_details.tags,
  )
}
# Target Group
resource "aws_lb_target_group" "internet_facing_tg" {
  count       = var.create_lb ? 1 : 0
  name_prefix = var.internet_facing_tg_details.name_prefix
  port        = var.internet_facing_tg_details.port
  protocol    = var.internet_facing_tg_details.protocol
  vpc_id      = aws_vpc.vpc.id
  target_type = var.internet_facing_tg_details.target_type
  tags = merge(
    { "Name" = "${var.tags.Name}" },
    { "ManagedBy" = var.tags.ManagedBy },
    var.internet_facing_tg_details.tags,
  )
}
# listener target
resource "aws_lb_listener" "alb_listener" {
  count             = var.create_lb ? 1 : 0
  load_balancer_arn = aws_lb.internet_facing_lb[0].arn
  port              = var.alb_listener_port_protocol_action.port
  protocol          = var.alb_listener_port_protocol_action.protocol
  default_action {
    type             = var.alb_listener_port_protocol_action.default_action_type
    target_group_arn = aws_lb_target_group.internet_facing_tg[0].arn
  }
}
# Internal loadbalancer
# Load Balancer SG
resource "aws_security_group" "internal_lb_sg" {
  count       = var.create_internal_lb ? 1 : 0
  name        = "${var.tags.Name}-internal-alb"
  description = "Security group for internal facing loadbalancer"
  vpc_id      = aws_vpc.vpc.id
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.internal_lb_sg_tags,
  )
}

# Internet facting ALB 
resource "aws_lb" "internal_lb" {
  count              = var.create_internal_lb ? 1 : 0
  name_prefix        = var.internal_lb_details.name_prefix
  load_balancer_type = var.internal_lb_details.load_balancer_type
  internal           = true
  security_groups    = [aws_security_group.internal_lb_sg[0].id]
  subnets            = aws_subnet.private_subnet.*.id
  idle_timeout       = var.internal_lb_details.idle_timeout
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.internal_lb_details.tags,
  )
}
# Target Group
resource "aws_lb_target_group" "internal_tg" {
  count       = var.create_internal_lb ? 1 : 0
  name_prefix = var.internal_tg_details.name_prefix
  port        = var.internal_tg_details.port
  protocol    = var.internal_tg_details.protocol
  vpc_id      = aws_vpc.vpc.id
  target_type = var.internal_tg_details.target_type
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.internal_tg_details.tags,
  )
}
# listener target
resource "aws_lb_listener" "internal_alb_listener" {
  count             = var.create_internal_lb ? 1 : 0
  load_balancer_arn = aws_lb.internal_lb[0].arn
  port              = var.internal_alb_listener_port_protocol_action.port
  protocol          = var.internal_alb_listener_port_protocol_action.protocol
  default_action {
    type             = var.internal_alb_listener_port_protocol_action.default_action_type
    target_group_arn = aws_lb_target_group.internal_tg[0].arn
  }
}

# Elastic IP for VPN server
resource "aws_eip" "eip_vpn_server" {
  vpc = true
  count  = var.create_vpn_server ? 1 : 0
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.eip_tags,
    var.open_vpn_details.tags
  )
}
# VPN server
resource "aws_instance" "vpn_server" {
  count                  = var.create_vpn_server ? 1 : 0
  ami                    = var.open_vpn_details.ami
  instance_type          = var.open_vpn_details.instance_type
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]
  subnet_id              = aws_subnet.public_subnet[0].id
  key_name               = var.open_vpn_details.key_name
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.open_vpn_details.tags,
  )
}
# Associate elastic ip to vpn server
resource "aws_eip_association" "eip_assoc_vpn_server" {
  count                  = var.create_vpn_server ? 1 : 0
  instance_id   = aws_instance.vpn_server[0].id
  allocation_id = aws_eip.eip_vpn_server[0].id
}
# Domain
resource "aws_route53_zone" "dns" {
  name = var.route53_zone_name_tags.name
  tags = merge(
    { "Name" = var.tags.Name },
    { "ManagedBy" = var.tags.ManagedBy },
    var.route53_zone_name_tags.tags,
  )
}



