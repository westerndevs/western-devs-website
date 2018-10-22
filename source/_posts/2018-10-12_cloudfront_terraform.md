layout: post
title: Terraform for a statically hosted AWS site
authorId: simon_timms
date: 2018-10-12
originalurl: 'https://blog.simontimms.com/2018/10/12/cloudfront_terraform/#more'
---

Just the other day somebody was mentioning to me that they were having trouble setting up a statically hosted site on AWS. That was the kick in the nose I needed to get this article written as it's been on my back-burner for a while. Terraform makes the whole process easy.

<!-- more -->

AWS, just like the other cloud platforms, offers a myriad of ways to host a website. Frequently, though, what you need is the simplest approach and that is using S3 to do your hosting. S3 doesn't have any smarts behind it so it is really only useful for static sites. However you can do an awful lot with static sites. This blog is statically generated and hosted but you can also do static hosting for most rich JavasScript applications  be they written in Angular, React, Vue, whatever. The one place where S3 falls down is that it cannot do SSL for custom domains. There is [no excuse](https://www.troyhunt.com/heres-why-your-static-website-needs-https/) for not doing SSL these days so we need to make sure our static site has it. 

In front of the S3 bucket we need to put something to do SSL termination. Of course, there is a service for that in the shape of CloudFront. CloudFront is a content delivery network which means that in addition to doing SSL termination it can improve performance through geo-distribution, caching and load balancing. It can even put in restrictions to disallow certain geographic regions from reaching the site. We're just interested in SSL termination right now.

Probably the hardest part of getting going on static hosting is setting up all the pieces. You can click through the, frankly, terrible AWS UI or you can cut out the mouse and use [Terraform](https://www.terraform.io/). Terraform is a tool for writing infrastructure descriptions and it has adapters for all the major cloud providers and [a bunch which aren't major](https://www.terraform.io/docs/providers/index.html). The descriptions are called templates. 

Let's take a look at a template for setting up a statically hosted site. We'll include a few services in this template

* S3 - holds our files
* CloudFront - does SSL termination for S3
* Route53 - DNS to get our domain to point at CloudFront


## Preamble

This section sets up the provider (the plugin for terraform which tells it how to talk with a cloud provider) and a storage location for the state. Terraform maintains a state of the deployment so it knows how to update resources instead of just destroying them and recreating them. 

```
provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "my-awesome-terraform"
    key    = "environment"
    region = "us-east-1"
  }
}
```

## S3

Next we set up the S3 bucket to hold our files. By now you might have noticed that we're using some variables denoted by the `${variable.name}` syntax. These variables can be defined in a file passed into the terraform tool. It is nice to make these things configurable so they can be reused. 

The S3 is a little complicated because we need to allow public reading and add some CORS rules. The rules here are in place to allow the site to call out to an API. I've left the rules really open here and you probably shouldn't do that in real life. 

```
# s3 for sites
resource "aws_s3_bucket" "website" {
  bucket = "${var.domain-name}"
  acl    = "public-read"

  policy = <<EOF
{
    "Version":"2008-10-17",
    "Statement":[{
    "Sid":"AllowPublicRead",
    "Effect":"Allow",
    "Principal": {"AWS": "*"},
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${var.domain-name}/*"]
    }]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
```

## CloudFront

Next we'll set up the CloudFront. This is a very bare-bones set up of CloudFront and doesn't make use of any of the cool advanced features. However, Terraform can do all that configuration for you. You may notice here that we're using that same variable syntax to reference other resources defined in the template. Specifically check out `domain_name = "${aws_s3_bucket.website.bucket_domain_name}"` which references back to the S3 container we set up just above.

Another thing to note here is that I've skipped creating the SSL certificate as part of this tutorial. I assume you've either got your own or you've set up one in AWS already; we just reference it by ARN.

```
# cloudfront

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "Access for cloudfront"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "origin"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.access_identity.cloudfront_access_identity_path}"
    }
  }

  aliases             = ["${var.domain-name}", "www.${var.domain-name}"]
  enabled             = "true"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin"

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

  viewer_certificate {
    acm_certificate_arn = "${var.ssl-arn}"
    ssl_support_method  = "sni-only"
  }
}
```

## Route53

We're almost there. This part sets up the domain routing in route 53. We have both bare and www prefixed domains here

```

# route 53
data "aws_route53_zone" "route53zone" {
  name = "${var.domain-name}."
}

# bare domain
resource "aws_route53_record" "domain" {
  zone_id = "${data.aws_route53_zone.route53zone.zone_id}"
  name    = "${var.domain-name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

#www domain
resource "aws_route53_record" "www-domain" {
  zone_id = "${data.aws_route53_zone.route53zone.zone_id}"
  name    = "www.${var.domain-name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
```

Finally we set up an output from the template which will be printed to the console when we deploy the template. Here we're printing out the name servers from Route53, these can be added to our domain.

```
output "name servers" {
  value = "${data.aws_route53_zone.route53zone.name_servers}"
}

```

## Variables

Our variables file looks like.

```
region = "us-east-1"
domain-name = "simontimms.com"
ssl-arn="arn:aws:acm:us-east-1:194820576566:certificate/aabcd5b3-4f32-4cbf-abd4-3b7e5385018a"
```

To run the terraform we need just do something like

```bash
terraform init #only needed on the first run
terraform apply -var-file dev.variables.tfvars
```

Terraform will spin up a CloudFormation stack containing all the resources you've defined. If you need to make changes you can change the template and run the apply command again.


The whole thing together looks like:

```
provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "my-awesome-terraform"
    key    = "environment"
    region = "us-east-1"
  }
}



# s3 for sites
resource "aws_s3_bucket" "website" {
  bucket = "${var.domain-name}"
  acl    = "public-read"

  policy = <<EOF
{
    "Version":"2008-10-17",
    "Statement":[{
    "Sid":"AllowPublicRead",
    "Effect":"Allow",
    "Principal": {"AWS": "*"},
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${var.domain-name}/*"]
    }]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# cloudfront

resource "aws_cloudfront_origin_access_identity" "access_identity" {
  comment = "Access for cloudfront"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "origin"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.access_identity.cloudfront_access_identity_path}"
    }
  }

  aliases             = ["${var.domain-name}", "www.${var.domain-name}"]
  enabled             = "true"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin"

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

  viewer_certificate {
    acm_certificate_arn = "${var.ssl-arn}"
    ssl_support_method  = "sni-only"
  }
}

# route 53
data "aws_route53_zone" "route53zone" {
  name = "${var.domain-name}."
}

# bare domain
resource "aws_route53_record" "domain" {
  zone_id = "${data.aws_route53_zone.route53zone.zone_id}"
  name    = "${var.domain-name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

#www domain
resource "aws_route53_record" "www-domain" {
  zone_id = "${data.aws_route53_zone.route53zone.zone_id}"
  name    = "www.${var.domain-name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

output "name servers" {
  value = "${data.aws_route53_zone.route53zone.name_servers}"
}
```
