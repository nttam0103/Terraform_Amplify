variable "region" {
  type        = string
  default     = "us-east-2"
  description = "Region in which AWS Resources to be created"
}

variable "repository_name" {
  type        = string
  default     = "https://github.com/nttam0103/responsive-ui-blogs-app-wnuxt"
  description = "Name of the repository"
}


variable "github_access_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}
variable "domain" {
  type        = string
  description = "Domain name for the route53 connect"
  default     = "talkandbook-healing.systems"
}
variable "subdomain_dev" {
  type        = string
  description = "Subdomain name for the route53 connect"
  default     = "dev"
}
variable "subdomain_test" {
  type        = string
  description = "Subdomain name for the route53 connect"
  default     = "test"
}
variable "basic_auth_credentials" {
  type        = string
  description = "Basic auth credentials for the route53 connect"
  default     = "admin:password123"
}