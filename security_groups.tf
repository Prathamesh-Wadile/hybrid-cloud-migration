# ==========================================
# 1. Virginia (On-Prem) Security Group
# ==========================================

resource "aws_security_group" "sg_onprem" {
  provider    = aws.virginia
  name        = "vpn-sg-onprem"
  description = "Allow VPN and SSH traffic"
  vpc_id      = aws_vpc.vpc_onprem.id

  # SSH Access (For us to configure the server)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # VPN: IKE (Internet Key Exchange) - CRITICAL FOR TUNNEL
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # VPN: NAT-T (NAT Traversal) - CRITICAL FOR TUNNEL
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (Ping) - For testing connection
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic from the OTHER VPC (The Tunnel Traffic)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"] # Traffic coming from Oregon
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==========================================
# 2. Oregon (Cloud) Security Group
# ==========================================

resource "aws_security_group" "sg_cloud" {
  provider    = aws.oregon
  name        = "vpn-sg-cloud"
  description = "Allow VPN and SSH traffic"
  vpc_id      = aws_vpc.vpc_cloud.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # VPN Ports
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # ICMP
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow traffic from Virginia
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}