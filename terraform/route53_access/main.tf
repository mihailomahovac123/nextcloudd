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

data "aws_iam_policy_document" "assume_role_policy" {  //kreira IAM Policy Document za Assume Role Policy - ko sme korisiti ovu IAM Role; cluster sme da koristi
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

data "aws_iam_policy_document" "route53_policy" { //samo nad fajlovima ovog s3 bucketa list,get,put,delete
  version = "2012-10-17"

  statement {
    actions   = [
       
        "route53:ListResourceRecordSets",
        "route53:ListHostedZones",
        "route53:GetHostedZone"

    ]
    effect    = "Allow"
    resources = [
        "*"         
    ]
  }
}

resource "aws_iam_role" "route53-role" {
  name               = "mihailo-route53-access-role-for-helmchart"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


resource "aws_iam_role_policy" "route53_policy_attachment" { 
  role       = aws_iam_role.route53-role.id
  policy = data.aws_iam_policy_document.route53_policy.json
}

//nakon ovoga kreiras service account 
//onda stavis da ga koristi deployment
//onda napravis rekord u kojem tvoj load balancer pokazuje na neki domen npr u zoni academy.cyberlab.rs napravis A rekord za tvoj LB koji ide sa 
// *.academy.cyberlab.rs i u ingress-u odradis da mu host bude: mydoman1.academy.cyberlab.rs, pa ces tek onda googlanjem dobiti da pokazuje na mydomain1.academy.cyberlab.rs
