resource "aws_iam_user" "user-classmates" {
  for_each = toset(var.users)
  name     = each.value

  tags = {
    tag-key = "DEV-22-classmates"
  }
}

