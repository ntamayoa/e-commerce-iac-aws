#bucket para contenido estatico (s3 hosting)

resource "aws_s3_bucket" "static" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.static.id

  block_public_acls   = true
  block_public_policy = true
}

#permite acceso desde cloudfront al bucket s3 aumentando seguridad
resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.cloudfront_arn
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.static.arn}/*"
    }]
  })
}
