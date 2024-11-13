# Criação do Cloud Front

# O recurso aws_cloudfront_origin_access_identitydo Terraform é usado para criar uma identidade de acesso de origem (OAI)
# do CloudFront , que permite proteger o acesso a um compartimento do Amazon S3 atrás de uma distribuição do CloudFront.

# BlocoBloco origin-> Define a origem da distribuição do CloudFront. A origem é a fonte do conteúdo que o CloudFront distribui.
# default_cache_behavior-> Define o comportamento de cache padrão para CloudFront
# custom_error_response->Permite que obter uma experiência de uso mais fluida, controlando o que os usuários fazem quando 
# encontram erros. Em vez de exibir páginas de erros genéricos, oferecemos páginas mais informativas,


# BlocoBloco custom_origin_config-> Configura a origem para balanceador de carga personalizado

# Criação do Recurso  Cloud Front(Identidade de Acesso de Origem")
resource "aws_cloudfront_origin_access_identity" "s3_origin_access" {
  comment = "Um OAI permite que o CloudFront aja com segurança intermediária para acessar objetos em um compartimento S3"
}

# Definindo a origem da distribuição(Esta configuração cria uma distribuição do CloudFront que é uma senha para difundir o 
# conteúdo proveniente de um balanceador de carga (ALB)
resource "aws_cloudfront_distribution" "load_balancer_distribution" {
  origin {
    domain_name = aws_lb.lb-front-end.dns_name
    origin_id   = "load-balancer-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "load-balancer-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name        = "loadbalancer-cloudfront-distribution"
    Environment = var.environment
    Managed_by  = "terraform"
  }

  wait_for_deployment = false
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.santander-coders-bucket.bucket_regional_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_origin_access.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Distribuição CloudFront para o bucket S3"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name        = "s3-cloudfront-distribution"
    Environment = var.environment
    Managed_by  = "terraform"
  }

  wait_for_deployment = false
}