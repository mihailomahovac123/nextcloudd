terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.64.0"
    } 
  }

   backend "s3" {
        bucket="tfstatemihailo"
        key="terraform.state.file" 
        region = "eu-central-1" 
      
    }
}

provider "aws" {
   region="eu-central-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }  
}

module "rds_instance" {
    source = "./modules/rds_instance" 
}

module "rds_secret" {
  source = "./modules/secrets_deployment"

  depends_on = [ module.rds_instance ]

  db_endpoint = module.rds_instance.rds_endpoint
  db_user = module.rds_instance.rds_user
  db_password = module.rds_instance.rds_password
  db_database_name = module.rds_instance.rds_db_name
}

module "eso_user" {
  source = "./modules/tf_deployment_ESO_user"
  depends_on = [ module.rds_secret ]
  secrets_name = module.rds_secret.secrets_name
}

module "route53_access" {
  source = "./modules/route53_access"
}

module "s3_access" {
  source = "./modules/s3_access"
}

module "ebs_volume1" {
  source = "./modules/ebs_volume"
}

module "ebs_volume2" {
  source = "./modules/ebs_volume"
}


//nextcloud chart deployment
module "nextcloud-chart" {                    //....
  source = "./modules/nextcloud_chart"
}

// ingress controller deployment
module "ingress-controller" {
  source = "./modules/nginx_controller"
}

// ingress deployment
module "ingress-deployment" {
  source = "./modules/ingress"
  depends_on = [ module.nextcloud-chart ]
  service_name = module.nextcloud-chart.nextcloud_release_name
}

//access s3 service account deployment
module "s3_access_service_acc" {
  source = "./modules/s3_access_service_account"
  depends_on = [ module.s3_access ]
  s3_access_role_name = module.s3_access.role_name
}

//access route53 service account deployment

module "r53_access_service_acc" {
  source = "./modules/route53_access_service_account"
  depends_on = [ module.route53_access ]
  r53_access_role_name = module.route53_access.route53_access_role_name
}

//import ebs csi driver 
//add EC2 Access Polict to EKS Nodes group: 
module "ec2_access_policy" {
source = "./modules/ec2_access"  
}

//deploy persistant volumes

module "pvc1" {
  source = "./modules/persistant_volume_claim_one"
  depends_on = [ module.ebs_volume1 ]
  volume_handle = module.ebs_volume1.volume_id
  name = "ebs-pv1"
}

module "pvc2" {
  source = "./modules/persistant_volume_claim_one"
  depends_on = [ module.ebs_volume2 ]
  volume_handle = module.ebs_volume2.volume_id
  name = "ebs-pv2"
}

