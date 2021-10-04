module "postbuild-config-do" {
  source  = "mjmenger/postbuild-config/bigip//do"
  version = "0.3.3"
  bigip_user       = module.bigip[0].f5_username
  bigip_password   = module.bigip[0].bigip_password
  bigip_address    = module.bigip[0].mgmtPublicIP
  bigip_do_payload = templatefile("${path.module}/../../../do.json", { nameserver = var.nameserver })
  depends_on = [
    module.bigip
  ]
}

