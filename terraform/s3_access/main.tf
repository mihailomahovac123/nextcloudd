// aws iam policy document = definise policy koji dopusta IAM roli da bude koriscena od strane Service Accounta iz naseg k8s clustera koristeci OIDC
// aws_iam_role = definnise IAM role
// aws_iam_role_policy_attachemnt - 

//nisu vezane za vpc - top
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.63.0"
    }
  }

  backend "s3" {
    bucket = "tfstatemihailom"
    key="terraform1.state"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_iam_policy_document" "assume_role_policy" {  //kreira IAM Policy Document za Assume Role Policy - ko sme korisiti ovu IAM Role
  version = "2012-10-17"

  statement {
    actions   = ["sts:AssumeRoleWithWebIdentity"]  //This is necessary for OIDC-based federated authentication.
    effect    = "Allow"
    principals { //definise ko sve sme da koristi ovu rolu
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${var.cluster_oidc_id}"] //arn i oicd mog accounta 
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${var.region}.amazonaws.com/id/${var.cluster_oidc_id}:sub" //the OIDC claim that includes the Kubernetes ServiceAccount.
      values  = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"] //specificira koji service account moze da koristi ovu rolu
    }
  }
}

data "aws_iam_policy_document" "s3_policy" { //samo nad fajlovima ovog s3 bucketa list,get,put,delete
  version = "2012-10-17"

  statement {
    actions   = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::mihailo-s3-bucket-test",   
      "arn:aws:s3:::mihailo-s3-bucket-test/*"          
    ]
  }
}

resource "aws_iam_role" "s3-role" {
  name               = "mihailo-s3-access-role-for-helmchart"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


resource "aws_iam_role_policy" "s3_policy_attachment" { //nema role policy attachment
  role       = aws_iam_role.s3-role.id
  policy = data.aws_iam_policy_document.s3_policy.json
}



