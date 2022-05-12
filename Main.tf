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


