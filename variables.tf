variable "vpc_details" {
  type = object({
    cidr_block           = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    tags                 = optional(map(string))
  })
  default = {
    cidr_block = "10.10.0.0/18"
  }
  description = "For VPC specific parameters"
}
variable "public_subnet_details" {
  type = object({
    cidr_block        = list(string)
    availability_zone = list(string)
    tags              = optional(map(string))
  })
  default = {
    availability_zone = ["us-east-1b", "us-east-1a"]
    cidr_block        = ["10.10.0.0/21", "10.10.8.0/21"]
  }
  description = "For public subnet CIDR block, availability zone and tags"
}
variable "private_subnet_details" {
  type = object({
    cidr_block        = list(string)
    availability_zone = list(string)
    tags              = optional(map(string))
  })
  default = {
    availability_zone = ["us-east-1b", "us-east-1a"]
    cidr_block        = ["10.10.16.0/21", "10.10.24.0/21"]
  }
  description = "Private subnet CIDR, availability zone and tags"
}

variable "tags" {
  type = object({
    Name      = string
    ManagedBy = optional(string, "Terraform")
    Project   = string
    CreatedBy = optional(string, "Network-Skeleton-Module")
    Env       = string
  })
  default = {
    Name    = "OT-Microservices"
    Project = "OT-Microservices"
    Env     = "Dev"
  }
  description = "Module specific tags"
}

variable "igw_tags" {
  type        = map(any)
  default     = {}
  description = "IGW specfic tags"
}
variable "route_table_tags" {
  type        = map(string)
  default     = {}
  description = "Route table specific tags"
}
variable "eip_tags" {
  type        = map(string)
  default     = {}
  description = "Elastic IP specific tags"
}
variable "nat_tags" {
  type        = map(string)
  default     = {}
  description = "NAT gateway specific tags"

}
variable "public_route_dest_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Public route table destination CIDR block"
}
variable "web_app_sg_rule_ingress" {
  type = object({
    port        = list(number)
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  })
  default = {
    port = [80, 443]
  }
  description = "Securitg group for all web application"
}
variable "web_app_sg_tags" {
  type        = map(string)
  default     = {}
  description = "tags for loadbalancer security group"
}
variable "internet_facing_lb_sg_tags" {
  type        = map(string)
  default     = {}
  description = "tags for loadbalancer security group"
}
variable "internet_facing_lb_details" {
  type = object({
    name               = string
    load_balancer_type = string
    idle_timeout       = number
    tags               = optional(map(string))
    access_logs = object({
      enabled = optional(bool, true)
      prefix  = optional(string)
    })
  })
  default = {
    idle_timeout       = 60
    load_balancer_type = "application"
    name               = "OT-Micro-External-alb"
    access_logs        = {}
  }
  description = "For internet facing loadbalancer specfic parameter"
}
variable "internet_facing_tg_details" {
  type = object({
    name_prefix = string
    port        = number
    protocol    = string
    target_type = string
    stickiness = object({
      type             = string
      enabled          = bool
      cookie_duriation = number
    })
    tags = optional(map(string))
  })
  default = {
    name_prefix = "otmic-"
    port        = 3000
    protocol    = "HTTP"
    target_type = "instance"
    stickiness = {
      type             = "lb_cookie"
      enabled          = true
      cookie_duriation = 86400
    }
  }
  description = "For internet facing loadbalancer's target groups"
}
variable "alb_listener_port_protocol_action" {
  type = object({
    port                = number
    protocol            = string
    default_action_type = string
  })
  default = {
    default_action_type = "forward"
    port                = 80
    protocol            = "HTTP"
  }
  description = "For listener application loadbalancer"
}
variable "create_lb" {
  type        = bool
  default     = true
  description = "For creating load balancer use default value true, otherwise use default value false "
}
variable "create_internal_lb" {
  type        = bool
  default     = true
  description = "For creating internal loadbalancer use default true, otherwise use default value false"
}
variable "internal_lb_sg_tags" {
  type        = map(string)
  default     = {}
  description = "tags for internal loadbalancer security group"
}
variable "internal_lb_details" {
  type = object({
    name               = string
    load_balancer_type = string
    idle_timeout       = number
    tags               = optional(map(string))
    access_logs = object({
      bucket  = string
      enabled = optional(bool, true)
      prefix  = optional(string)
    })
  })
  default = {
    idle_timeout       = 60
    load_balancer_type = "application"
    name               = "OT-Micro-Internal-alb"
    access_logs = {
      bucket = "avengers-external-loadbalancer-access-log-1"
    }

  }
  description = "For internal loadbalancer specfic parameter"
}
variable "internal_tg_details" {
  type = object({
    name_prefix = string
    port        = number
    protocol    = string
    target_type = string
    stickiness = object({
      type             = string
      enabled          = bool
      cookie_duriation = number
    })
    tags = optional(map(string))
  })
  default = {
    name_prefix = "otmic-"
    port        = 3000
    protocol    = "HTTP"
    target_type = "instance"
    stickiness = {
      type             = "lb_cookie"
      enabled          = true
      cookie_duriation = 86400
    }
  }
  description = "For internal loadbalancer's target groups"
}

variable "internal_tg_stickness" {
  type = object({
    enabled          = bool
    type             = string
    cookie_duriation = number
  })
  default = {
    cookie_duriation = 86400
    enabled          = true
    type             = "lb_cookie"
  }
}

variable "internal_alb_listener_port_protocol_action" {
  type = object({
    port                = number
    protocol            = string
    default_action_type = string
  })
  default = {
    default_action_type = "forward"
    port                = 80
    protocol            = "HTTP"
  }
  description = "For listener internal application loadbalancer"
}
variable "open_vpn_details" {
  type = object({
    ami           = string
    instance_type = string
    key_name      = string
    tags          = optional(map(string))
  })
  default = {
    ami           = "ami-06878d265978313ca"
    instance_type = "t2.micro"
    key_name      = "aws-key"

  }
  description = "Here ami should be of vpn server"
}
variable "create_vpn_server" {
  type    = bool
  default = true
}
variable "route53_zone_name_tags" {
  type = object({
    name = string
    tags = optional(map(string))
  })
  default = {
    name = "avengers.com"
  }
}

# Loadbalancer additional variables
variable "internet_facing_lb_enable_delete_protect" {
  type        = bool
  default     = false
  description = "Protection for loadbalancer from deletion"
}
variable "lb_sticky_policy" {
  type = object({
    name                     = string
    lb_port                  = number
    cookie_expiration_period = number
  })
  default = {
    cookie_expiration_period = 600
    lb_port                  = 80
    name                     = "net_face_sticky_policy"
  }
}

variable "internal_lb_delete_protection" {
  type        = bool
  default     = false
  description = "Protect from deletion of loadbalancer"
}

variable "internal_lb_sticky_policy" {
  type = object({
    name                     = string
    lb_port                  = number
    cookie_expiration_period = number
  })
  default = {
    cookie_expiration_period = 600
    lb_port                  = 80
    name                     = "internal_sticky_policy"
  }
}

variable "openvpn_sg_name" {
  type    = string
  default = "OpenVPN-sg"
}

variable "openvpn_ingress" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = {
    "22" = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all traffic for port 22"
      port        = 22
      protocol    = "tcp"
    }
  }
}

variable "lb_access_logs_bucket_name" {
  type    = string
  default = "snaatak-avengers-external-loadbalancer-access-log"
}
