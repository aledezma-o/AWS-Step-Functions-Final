provider "random" {} #

provider "aws" {
    region = "us-east-1"
    access_key = "" # use your user's credentials
    secret_key = ""
}

provider "aws" {
    alias = "central"
    region = "us-west-1"
    access_key = ""
    secret_key = ""
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


