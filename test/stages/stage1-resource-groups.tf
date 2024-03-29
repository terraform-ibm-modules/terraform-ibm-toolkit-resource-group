module "existing_resource_group" {
  source = "./module"

  resource_group_name = "Default"
  ibmcloud_api_key    = var.ibmcloud_api_key
}

module "resource_group1" {
  source = "./module"

  resource_group_name = "test-resource-group1"
  ibmcloud_api_key    = var.ibmcloud_api_key
  sync                = module.existing_resource_group.sync
  purge_volumes = true
}

module "resource_group2" {
  source = "./module"

  resource_group_name = "test-resource-group2a"
  sync                = module.resource_group1.sync
  ibmcloud_api_key    = var.ibmcloud_api_key
  purge_volumes = true
}

module "resource_group2-parallel" {
  source = "./module"

  resource_group_name = "test-resource-group2"
  sync                = module.resource_group1.sync
  ibmcloud_api_key    = var.ibmcloud_api_key
}

resource local_file tags {
  filename = "${path.cwd}/.tags"

  content = jsonencode(module.resource_group2.tags)
}

resource local_file provision_flag {
  filename = "${path.cwd}/.provision"

  content = module.resource_group2.provision
}

resource local_file resource_group_name {
  filename = "${path.cwd}/.rg_name"

  content = module.resource_group2.name
}
