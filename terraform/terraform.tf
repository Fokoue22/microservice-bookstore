terraform {

  cloud {
    organization = "microservice-bookstore"

    workspaces {
      name = "devops-project-workspace"
    }
  }
}

provider "aws" {
  region = "us-east-1"  
}