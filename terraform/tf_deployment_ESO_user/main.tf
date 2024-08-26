//kreira usera sa polisama da sme da cita secrete


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }


   backend "s3" {

    bucket="tfstatemihailo"
    key="terraform12.tfstate"
    region="eu-central-1"
  
  }
}

provider "aws" {
  region="eu-central-1"
}


resource "aws_iam_user" "user" {
  name = "aws_secrets_manager_user_mihailo"

}

resource "aws_iam_access_key" "user_access_key" { //kreira access key i secret access key
  user = aws_iam_user.user.name
}


data "aws_iam_policy_document" "user_policy" {
  statement {
    effect    = "Allow"
    actions   = [
    "secretsmanager:GetRandomPassword",
    "secretsmanager:GetResourcePolicy",
    "secretsmanager:GetSecretValue",
    "secretsmanager:DescribeSecret",
    "secretsmanager:ListSecretVersionIds",
    "secretsmanager:ListSecrets",
    "secretsmanager:BatchGetSecretValue"
    ]
    resources = ["*"] // ovde sam dodao sve secrete, ali ako hocu da pristupi samo secretima kojima mora, onda se navodi ovde u resursima
  }
}

resource "aws_iam_user_policy" "user_policy_association" {
  name   = "userpolicymihailo"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.user_policy.json
}



