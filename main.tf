# Configure AWS provider
provider "aws" {
  region = var.region
}

# Create Amplify app 
resource "aws_amplify_app" "my-app" {
  name                     = "demo-app"
  repository               = var.repository_name
  access_token             = var.github_access_token
  enable_branch_auto_build = true
  # enable_auto_branch_creation = true
  # Configure build settings
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT


  environment_variables = {
    ENV = "prod"
  }

  custom_rule {
    source = "htpps://${var.domain}"
    status = "404"
    target = "https://www.${var.domain}"
  }
}

# Create branch 
resource "aws_amplify_branch" "main" {
  app_id            = aws_amplify_app.my-app.id
  branch_name       = "main"
  enable_auto_build = true
  #   enable_performance_mode = false
  #   enable_pull_request_preview = true
  framework = "Vue"
  stage     = "PRODUCTION"
}

resource "aws_amplify_branch" "develop" {
  app_id                 = aws_amplify_app.my-app.id
  branch_name            = "dev"
  enable_auto_build      = true
  framework              = "Vue"
  stage                  = "DEVELOPMENT"
  basic_auth_credentials = base64encode(var.basic_auth_credentials)
  enable_basic_auth      = true
}
resource "aws_amplify_branch" "testing" {
  app_id                 = aws_amplify_app.my-app.id
  branch_name            = "test"
  enable_auto_build      = true
  framework              = "Vue"
  stage                  = "BETA"
  basic_auth_credentials = base64encode(var.basic_auth_credentials)
  enable_basic_auth      = true
}

# Create webhook
resource "aws_amplify_webhook" "webhook" {
  app_id      = aws_amplify_app.my-app.id
  branch_name = aws_amplify_branch.main.branch_name
  description = "Webhook for automated deployments"
}

# Create webhook 
resource "aws_amplify_webhook" "test" {
  app_id      = aws_amplify_app.my-app.id
  branch_name = aws_amplify_branch.testing.branch_name
  description = "Webhook for automated deployments (test branch)"
}

# Create webhook 
resource "aws_amplify_webhook" "dev" {
  app_id      = aws_amplify_app.my-app.id
  branch_name = aws_amplify_branch.develop.branch_name
  description = "Webhook for automated deployments (dev branch)"
}


# Create domain association
resource "aws_amplify_domain_association" "domain_association" {
  app_id      = aws_amplify_app.my-app.id
  domain_name = var.domain

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
  sub_domain {
    branch_name = aws_amplify_branch.develop.branch_name
    prefix      = var.subdomain_dev
  }
  sub_domain {
    branch_name = aws_amplify_branch.testing.branch_name
    prefix      = var.subdomain_test
  }
}






