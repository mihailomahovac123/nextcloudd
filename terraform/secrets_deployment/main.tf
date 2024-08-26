
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }


   backend "s3" {

    bucket="tfstatemihailo"
    key="terraform10.tfstate"
    region="eu-central-1"
  
  }
}

provider "aws" {
  region="eu-central-1"
}




resource "aws_secretsmanager_secret" "mysql_db" {  //kreira secret
  name = "mihailo_nextcloud_secrets"  
  description = "This secret contains nextcloud credentials..."
}

resource "aws_secretsmanager_secret_version" "db_mysql_values" { //dodaje vrednsoti u secret
  secret_id     = aws_secretsmanager_secret.mysql_db.id
  secret_string = jsonencode({
    host = "database-mihailo.cscjwnksxo6a.eu-central-1.rds.amazonaws.com",
    user = "admin",
    password = "Admin12345!",
    database="nextcloud"
  })
}