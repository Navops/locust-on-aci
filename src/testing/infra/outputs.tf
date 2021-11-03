output "locust_webui_fqdn" {
  value = length(azurerm_container_group.master)==0?"":"http://locust:${random_password.locustsecret.result}@${azurerm_container_group.master.0.fqdn}:8089/"
}
