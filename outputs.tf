output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins_public_ip.ip_address
}

output "sonar_public_ip" {
  value = azurerm_public_ip.sonar_public_ip.ip_address
}

