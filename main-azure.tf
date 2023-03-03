resource "azuread_user" "user-ibrahim" {
  user_principal_name   = "IOz@hashicorp.com"
  display_name          = "Ibrahim"
  mail_nickname         = "IOz"
  force_password_change = true
  depends_on = [
    azurerm_resource_group.rg1-DEV-22
  ]
}
resource "azuread_user" "user-mimi" {
  user_principal_name = "MDib@hashicorp.com"
  display_name        = "Mimi Dib"
  mail_nickname       = "MDib"
  depends_on = [
    azurerm_resource_group.rg1-DEV-22
  ]
}

resource "azurerm_resource_group" "rg1-DEV-22" {
  name     = "rg1-DEV-22"
  location = "West Europe"
}

resource "azurerm_virtual_network" "az-vm-DEV-22" {
  name                = "vm-linux-DEV-22"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1-DEV-22.location
  resource_group_name = azurerm_resource_group.rg1-DEV-22.name
}

resource "azurerm_storage_account" "storage-DEV-22" {
  name                     = "devopsdev22"
  resource_group_name      = azurerm_resource_group.rg1-DEV-22.name
  location                 = azurerm_resource_group.rg1-DEV-22.location
  account_tier             = "Standard"
  account_replication_type = "LRS" #cus we on a budget

  tags = {
    environment = "staging"
  }

  depends_on = [
    aws_iam_user.user-classmates
  ]
}


resource "azurerm_linux_virtual_machine" "vm-linux-DEV-22" {
  name                = "linux-dev22"
  resource_group_name = azurerm_resource_group.rg1-DEV-22.name
  location            = azurerm_resource_group.rg1-DEV-22.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  license_type        = "RHEL_BYOS"

  network_interface_ids = [
    azurerm_network_interface.az-network-int.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_storage_account.storage-DEV-22
  ]
}

resource "azurerm_subnet" "az-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg1-DEV-22.name
  virtual_network_name = azurerm_virtual_network.az-vm-DEV-22.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "az-network-int" {
  name                = "example-nic"
  resource_group_name = azurerm_resource_group.rg1-DEV-22.name
  location            = azurerm_resource_group.rg1-DEV-22.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.az-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}