output "onprem_vpn_public_ip" {
  value = aws_instance.vpn_onprem.public_ip
}

output "cloud_vpn_public_ip" {
  value = aws_instance.vpn_cloud.public_ip
}