output "bucket_name" {
  value = aws_s3_bucket.first_project.id
}

output "bucket_domain_name" {
  description = "URL of the deployed project"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

