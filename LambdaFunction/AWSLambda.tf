# AWSLambda.tfIONS
data "archive_file" "pp" { # archive folder
  type        = "zip"
  source_file = "${path.module}/processpurchase.py"
  output_path = "${path.module}/processpurchase.zip"
}

data "archive_file" "pr" { # archive folder
  type        = "zip"
  source_file = "${path.module}/processrefund.py"
  output_path = "${path.module}/processrefund.zip"
}

# S3 Bucket

resource "aws_s3_bucket" "cqpocsbucket" {
    bucket = "quickcloudpocsbucket001"
    acl = "private"
}

# upload zip to s3

resource "aws_s3_bucket_object" "object1" {
    bucket = aws_s3_bucket.cqpocsbucket.id
    key = "processpurchase.zip"
    source = "${path.module}/processpurchase.zip"
}

resource "aws_s3_bucket_object" "object2" {
    bucket = aws_s3_bucket.cqpocsbucket.id
    key = "processrefund.zip"
    source = "${path.module}/processrefund.zip"
}

# IAM role for lambda

resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    assume_role_policy = file("LambdaFunction/lambda_assume_role_policy.json")
}

# IAM role-policy for lambda

resource "aws_iam_role_policy" "lambda_policy" {
    name = "lambda_policy"
    role = aws_iam_role.lambda_role.id
    policy = file("LambdaFunction/lambda_policy.json")
}

# Lambda functions

resource "aws_lambda_function" "SFprocesspurchase" {
  function_name = "SFprocesspurchase"
  s3_bucket = aws_s3_bucket.cqpocsbucket.id
  s3_key = "processpurchase.zip"

  role    = aws_iam_role.lambda_role.arn
  handler = "SFprocesspurchase.handler"
  runtime = "python3.8"
}

resource "aws_lambda_function" "SFprocessrefund" {
  function_name = "SFprocessrefund"
  s3_bucket = aws_s3_bucket.cqpocsbucket.id
  s3_key = "processrefund.zip"

  role    = aws_iam_role.lambda_role.arn
  handler = "SFprocessrefund.handler"
  runtime = "python3.8"
}

# output consumed by other module

# output "pythonLambdaArnPP" {
#     value = aws_lambda_function.SFprocesspurchase.arn
# }

# output "pythonLambdaArnPR" {
#     value = aws_lambda_function.SFprocessrefund.arn
# }

output "pythonLambdaArn" {
    value = aws_lambda_function.SFprocesspurchase.arn
}



