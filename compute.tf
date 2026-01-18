# Get latest Amazon Linux 2023 AMI for Virginia
data "aws_ami" "amazon_linux_va" {
  provider = aws.virginia
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Get latest Amazon Linux 2023 AMI for Oregon
data "aws_ami" "amazon_linux_or" {
  provider = aws.oregon
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# ==========================================
# 1. Virginia Instances (On-Prem)
# ==========================================

# The VPN Gateway Server
resource "aws_instance" "vpn_onprem" {
  provider                    = aws.virginia
  ami                         = data.aws_ami.amazon_linux_va.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_onprem.id
  vpc_security_group_ids      = [aws_security_group.sg_onprem.id]
  key_name                    = "my-vpn-key-va" # <--- SEE NOTE BELOW
  associate_public_ip_address = true
  
  # CRITICAL: Disable Source/Dest Check for Routing
  source_dest_check           = false

  tags = { Name = "On-Prem-VPN-Gateway" }
}

# The Legacy Web Server (To be Migrated)
resource "aws_instance" "web_onprem" {
  provider                    = aws.virginia
  ami                         = data.aws_ami.amazon_linux_va.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_onprem.id
  vpc_security_group_ids      = [aws_security_group.sg_onprem.id]
  key_name                    = "my-vpn-key-va"
  
  tags = { Name = "Legacy-Web-Server" }
}

# ==========================================
# 2. Oregon Instance (Cloud Target)
# ==========================================

# The VPN Gateway Server
resource "aws_instance" "vpn_cloud" {
  provider                    = aws.oregon
  ami                         = data.aws_ami.amazon_linux_or.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_cloud.id
  vpc_security_group_ids      = [aws_security_group.sg_cloud.id]
  key_name                    = "my-vpn-key-or" # <--- SEE NOTE BELOW
  associate_public_ip_address = true
  
  # CRITICAL: Disable Source/Dest Check for Routing
  source_dest_check           = false

  tags = { Name = "Cloud-VPN-Gateway" }
}