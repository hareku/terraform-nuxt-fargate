# Terraform Nuxt.js Fargate

## Nuxt.js development
``` bash
# run h2o and node
$ docker-compose up -d

# exec node
$ docker-compose exec node sh

# install dependencies
$ yarn install

$ run dev server localhost:80
$ yarn run dev
```

## Terraform usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and set credentials.
2. Apply `02_acm.tf` and wait verification. because ALB and CloudFront need verified certificates.
3. Apply .tf files other than `03_route53.tf`
4. Apply `03_route53.tf`