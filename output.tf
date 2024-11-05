
#Output the Amplify app URL
output "amplify_app_url" {
  value = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.my-app.id}.amplifyapp.com"
}

output "amplify_app_url_dev" {
  value = "https://${aws_amplify_branch.develop.branch_name}.${aws_amplify_app.my-app.id}.amplifyapp.com"
}
output "amplify_app_url_test" {
  value = "https://${aws_amplify_branch.testing.branch_name}.${aws_amplify_app.my-app.id}.amplifyapp.com"
}

output "domain_url" {
  value = "https://${aws_amplify_domain_association.domain_association.domain_name}"
}

output "domain_url_dev" {
  value = "https://${aws_amplify_domain_association.domain_association_dev.domain_name}"
}
output "domain_url_test" {
  value = "https://${aws_amplify_domain_association.domain_association_test.domain_name}"
}