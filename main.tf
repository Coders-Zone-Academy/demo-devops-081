resource "aws_s3_bucket" "first_project" {
  # bucket´s name
  bucket = var.bucket_name

  tags = {
    Environment = "Dev"
    Service = "First Project"
  }

}

resource "aws_s3_bucket_public_access_block" "website_bucket_block" {
  bucket = aws_s3_bucket.first_project.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.first_project.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "website_files" {
  for_each = fileset("dist", "**")

  bucket = aws_s3_bucket.first_project.id
  key    = each.value
  source = "dist/${each.value}"
  etag   = filemd5("dist/${each.value}")
  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      png  = "image/png"
      jpg  = "image/jpeg"
      jpeg = "image/jpeg"
      svg  = "image/svg+xml"
    },
    regex("[^.]+$", each.value),
    "binary/octet-stream"
  )
}

resource "aws_s3_bucket_policy" "first_project_policy" {
  bucket = aws_s3_bucket.first_project.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.first_project.arn}/*"
      }
    ]
  })
  
}
