# Get TF to make a GitHub repo for you (on your account)

provider "github" {
    token = var.github_token
}

resource "github_repository" "test_repo" {
  name        = "se-dare-tf-repo"
  description = "This is a test repo created by Terraform"
  # private     =  
  visibility  = "public"
}
