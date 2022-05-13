# lambda function created

variable "pythonfunctionapparn" {
    
}

# AWS Step function role
resource "aws_iam_role" "step_function_role" {
    name = "cloudquickpocsstepfunction-role"
    assume_role_policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                "sts:AssumeRole",
                "iam:AttachRolePolicy",
                "iam:CreateRole",
                "iam:PutRolePolicy"
                ],
                "Principal": {
                    "Service": "states.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": "StepFunctionAssumeRole"
            }
        ]
    }
    EOF
}

# AWS step function role-policy
resource "aws_iam_role_policy" "step_function_policy" {
    name = "cqpdstepfunctionrole-policy"
    role = aws_iam_role.step_function_role.id
    
    policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "lambda:InvokeFunction"
                ],
                "Effect": "Allow",
                "Resource": "${var.pythonfunctionapparn}"
            }
        ]
    }
    EOF
}

# AWS State function - State Machine - Step Function

resource "aws_sfn_state_machine" "SFtransactionprocessor" {
  name     = "transactionprocessor"
  role_arn = aws_iam_role.step_function_role.arn
  definition = <<EOF
{
  "Comment": "Transaction Processor State Machine",
  "StartAt": "ProcessTransaction",
  "States": {
    "ProcessTransaction": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.TransactionType",
          "StringEquals": "PURCHASE",
          "Next": "ProcessPurchase"
        },
        {
          "Variable": "$.TransactionType",
          "StringEquals": "REFUND",
          "Next": "ProcessRefund"
        }
      ]
    },
    "ProcessPurchase": {
      "Type": "Task",
      "Resource": "${var.pythonfunctionapparn}",
      "End": true
    },
    "ProcessRefund": {
      "Type": "Task",
      "Resource": "${var.pythonfunctionapparn}",
      "End": true
    }
  }
}

EOF
}






