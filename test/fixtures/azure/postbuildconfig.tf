module "postbuild-config-do" {
  count            = length(var.azs)
  source           = "mjmenger/postbuild-config/bigip//do"
  version          = "0.3.3"
  bigip_user       = module.bigip[count.index].f5_username
  bigip_password   = module.bigip[count.index].bigip_password
  bigip_address    = module.bigip[count.index].mgmtPublicIP
  bigip_do_payload = templatefile("${path.module}/../../../do.json", { 
    nameserver     = var.nameserver,
    bigiq_hostname = var.bigiq_hostname, #"20.109.161.203"
    bigiq_username = var.bigiq_username, #"admin"
    bigiq_password = var.bigiq_password, #"3WL_lzySMoechDB1cp33e4s"
    licensePool    = var.bigiq_license_pool, #"F5-BIG-MSP-LOADV4-LIC",
    skuKeyword1    = var.bigiq_sku, #"F5-BIG-MSP-BR-5G",
    unitOfMeasure  = "yearly",
    reachable      = var.bigiq_bigip_reachable, #false,
    bigIpUsername  = module.bigip[count.index].f5_username,
    bigIpPassword  = module.bigip[count.index].bigip_password,
    hypervisor     = "azure"
    })
  depends_on = [
    module.bigip
  ]
}

variable bigiq_hostname {}
variable bigiq_username {}
variable bigiq_password {}
variable bigiq_license_pool {}
variable bigiq_sku {}
variable bigiq_bigip_reachable {
  default = false
}