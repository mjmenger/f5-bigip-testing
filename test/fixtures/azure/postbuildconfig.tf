module "postbuild-config-do" {
  count            = length(var.azs)
  source           = "mjmenger/postbuild-config/bigip//do"
  version          = "0.3.3"
  bigip_user       = module.bigip[count.index].f5_username
  bigip_password   = module.bigip[count.index].bigip_password
  bigip_address    = module.bigip[count.index].mgmtPublicIP
  bigip_do_payload = templatefile("${path.module}/../../../do.json", { 
    nameserver     = var.nameserver
    bigiq_hostname = "20.109.161.203"
    bigiq_username = "admin"
    bigiq_password = "3WL_lzySMoechDB1cp33e4s"
    licensePool    = "F5-BIG-MSP-LOADV4-LIC",
    skuKeyword1    = "F5-BIG-MSP-BR-5G",
    unitOfMeasure  = "yearly",
    reachable      = false,
    bigIpUsername  = module.bigip[count.index].f5_username,
    bigIpPassword  = module.bigip[count.index].bigip_password,
    hypervisor     = "azure"
    })
  depends_on = [
    module.bigip
  ]
}

