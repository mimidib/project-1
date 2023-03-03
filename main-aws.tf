resource "aws_iam_user" "user-classmates" {
  for_each = toset(var.users)
  name     = each.value

  tags = {
    tag-key = "DEV-22-classmates"
  }

  depends_on = [
    aws_s3_bucket.DEV-22-bucket
  ]
}

resource "aws_s3_bucket" "DEV-22-bucket" {
  bucket = "${var.DEV-22-bucket-names}-${count.index}"
  count  = var.number-of-DEV-22-buckets

  tags = {
    Name        = "DEV-22"
    Environment = "Dev"
  }
  depends_on = [
    azuread_user.user-mimi
  ]
}
