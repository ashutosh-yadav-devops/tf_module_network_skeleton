locals {
  common_tags = {
    "ManagedBy" = var.tags.ManagedBy
    "Project"   = var.tags.Project
    "CreatedBy" = var.tags.CreatedBy
    "Env"       = var.tags.Env
  }
  vpc_tags = merge(
    { "Name" = "${var.tags.Name}-vpc" },
    local.common_tags,
    var.vpc_details.tags,
  )

  igw_tags = merge(
    { "Name" = "${var.tags.Name}-igw" },
    local.common_tags,
    var.igw_tags,
  )

  aza_eip_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.eip_tags,
  )

  aza_nat_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.nat_tags,
  )

  azb_eip_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.eip_tags,
  )

  azb_nat_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.nat_tags,
  )

  pub_aza_rt_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.route_table_tags,
  )

  pub_azb_rt_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.route_table_tags,
  )

  pvt_aza_rt_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.route_table_tags,
  )

  pvt_azb_rt_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.route_table_tags,
  )

  pub_subnet_tags = merge(
    { "Name" = "${var.tags.Name}-pub" },
    local.common_tags,
    var.public_subnet_details.tags,
  )

  pvt_subnet_tags = merge(
    { "Name" = "${var.tags.Name}-pvt" },
    local.common_tags,
    var.private_subnet_details.tags,
  )

  common_web_sg_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.web_app_sg_tags,
  )

  internet_facing_lb_sg_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.internet_facing_lb_sg_tags,
  )

  internet_facing_alb_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.internet_facing_lb_details.tags,
  )

  internet_facing_tg_tags = merge(
    { "Name" = "${var.tags.Name}" },
    local.common_tags,
    var.internet_facing_tg_details.tags,
  )

  internal_lb_sg_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.internal_lb_sg_tags,
  )

  internal_alb_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.internal_lb_details.tags,
  )

  internal_tg_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.internal_tg_details.tags,
  )

  eip_vpn_server_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.eip_tags,
    var.open_vpn_details.tags
  )

  vpn_server_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.open_vpn_details.tags,
  )

  dns_route53_tags = merge(
    { "Name" = var.tags.Name },
    local.common_tags,
    var.route53_zone_name_tags.tags,
  )
}