module "postbuild-config-do" {
  source  = "mjmenger/postbuild-config/bigip//do"
  version = "0.3.3"
  bigip_user       = "admin"
  bigip_password   = random_string.password.result
  bigip_address    = module.bigip[0].mgmtPublicIP
  bigip_do_payload = templatefile("${path.module}/../../../do.json",{ nameserver = var.nameserver })
  depends_on = [
    module.bigip
  ]
}

