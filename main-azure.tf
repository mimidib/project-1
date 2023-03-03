resource "azuread_user" "user-ibrahim" {
  user_principal_name   = "IOz@hashicorp.com"
  display_name          = "Ibrahim"
  mail_nickname         = "IOz"
  force_password_change = true
}
resource "azuread_user" "user-mimi" {
  user_principal_name = "MDib@hashicorp.com"
  display_name        = "Mimi Dib"
  mail_nickname       = "MDib"
}