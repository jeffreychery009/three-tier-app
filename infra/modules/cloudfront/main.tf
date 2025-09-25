resource "aws_cloudfront_origin_access_control" "this" {
    name = var.aws_cloudfront_origin_access_control_name
    description = var.aws_cloudfront_origin_access_control_description
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
    origin {
        domain_name = var.s3_bucket_domain_name
        origin_id   = var.s3_bucket_domain_name
        
        origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    }

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "Static dashboard distribution"
    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = var.s3_bucket_domain_name

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    # Custom error page for SPA routing
    custom_error_response {
        error_code         = 404
        response_code      = 200
        response_page_path = "/index.html"
    }

    custom_error_response {
        error_code         = 403
        response_code      = 200
        response_page_path = "/index.html"
    }

    price_class = "PriceClass_100"

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    tags = {
        Name        = "Static Dashboard Distribution"
        Environment = "Dev"
    }
}