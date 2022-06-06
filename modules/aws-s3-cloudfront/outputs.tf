output "s3-endpoint" {
  description = "The end point of s3 bucket"
  value       = aws_s3_bucket.site.website_endpoint
}

output "cloudfront-endpoint" {
  description = "the url of s3 bucket"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}
