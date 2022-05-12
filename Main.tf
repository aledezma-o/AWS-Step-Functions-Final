# 
# terraform {
#     required_version = ">= 0.12.24"
#     backend "s3" {
#         bucket = "cloudquickpocsbackendtf"
#         key = "quickcloudpocsbackend.tfstate"
#         region = "us-east-1"
        
#         access_key = "AKIARHTFFQDACXVZS3XT"
#         secret_key = "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"
#     }
# }
#

provider "random" {} #

provider "aws" {
    region = "us-east-1"
    
    access_key = "AKIARHTFFQDAGRTZKSXB"
    secret_key = "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"
}

provider "aws" {
    alias = "central"
    region = "us-west-1"
    
    access_key = "AKIARHTFFQDAGRTZKSXB"
    secret_key = "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"
}

module "awslambdafunction" {
    source = "./LambdaFunction"
}

module "awsstepfunction" {
    source = "./StepFunction"
    # pythonfunctionapparnPP = module.awslambdafunction.pythonLambdaArnPP
    # pythonfunctionapparnPR = module.awslambdafunction.pythonLambdaArnPR
    pythonfunctionapparn = module.awslambdafunction.pythonLambdaArn
}


