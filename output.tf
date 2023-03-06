output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "It is for VPC id"
}
output "public_aza_subnet_id" {
  value       = aws_subnet.public_subnet[0].id
  description = "Public subnet id of availability zone a"
}
output "public_azb_subnet_id" {
  value       = aws_subnet.public_subnet[1].id
  description = "Public subnet id for availability zone b"
}
output "private_aza_subnet_id" {
  value       = aws_subnet.private_subnet[0].id
  description = "Private subnet id of availability zone a"
}
output "private_azb_subnet_id" {
  value       = aws_subnet.private_subnet[1].id
  description = "Private subnet id for availability zone b"
}
output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "Internet gateway Id "
}
output "public_aza_route_table_id" {
  value       = aws_route_table.public_aza.id
  description = "Public route table for availability zone a"
}
output "public_azb_route_table_id" {
  value       = aws_route_table.public_azb.id
  description = "Public route table for availability zone b"
}
output "aza_nat_gateway_id" {
  value       = aws_nat_gateway.aza_nat.id
  description = "NAT gateway of availbility zone a"
}
output "azb_nat_gateway_id" {
  value       = aws_nat_gateway.azb_nat.id
  description = "NAT gateway of availbility zone b"
}
output "private_aza_route_table_id" {
  value       = aws_route_table.private_aza.id
  description = "Private route table for availability zone a"
}
output "private_azb_route_table_id" {
  value       = aws_route_table.private_azb.id
  description = "Private route table for availability zone b"
}
output "internet_facing_lb_sg_id" {
  value       = length(aws_security_group.internet_facing_lb_sg) > 0 ? aws_security_group.internet_facing_lb_sg[0].id : ""
  description = "Internet facing loadbalancer security group Id"
}
output "internet_facing_lb_arn" {
  value       = length(aws_lb.internet_facing_lb) > 0 ? aws_lb.internet_facing_lb[0].arn : ""
  description = "Internet facing loadbalancer arn"
}
output "internal_facing_lb_dns" {
  value       = length(aws_lb.internet_facing_lb) > 0 ? aws_lb.internet_facing_lb[0].dns_name : ""
  description = "Internet facing loadbalancer dns name"
}
output "internet_facing_tg_arn" {
  value       = length(aws_lb_target_group.internet_facing_tg) > 0 ? aws_lb_target_group.internet_facing_tg[0].arn : ""
  description = "Internet facing loadbalancer's target groups arn"
}
output "internal_lb_sg_id" {
  value       = length(aws_security_group.internal_lb_sg) > 0 ? aws_security_group.internal_lb_sg[0].id : ""
  description = "Internal loadbalancer security group id"
}
output "internal_lb_arn" {
  value       = length(aws_lb.internal_lb) > 0 ? aws_lb.internal_lb[0].arn : ""
  description = "Internal loadbalancer arn"
}
output "internal_lb_dns" {
  value       = length(aws_lb.internal_lb) > 0 ? aws_lb.internal_lb[0].dns_name : ""
  description = "Internal loadbalancer dns name"
}
output "internal_tg_arn" {
  value       = length(aws_lb_target_group.internal_tg) > 0 ? aws_lb_target_group.internal_tg[0].arn : ""
  description = "Internal loadbalancers target groups"
}
output "vpn_server_id" {
  value       = length(aws_instance.vpn_server) > 0 ? aws_instance.vpn_server[0].id : ""
  description = "vpn server instance Id"
}
output "name_servers" {
  value       = aws_route53_zone.dns.name_servers
  description = "List of name servers"
}