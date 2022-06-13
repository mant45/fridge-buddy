resource "aws_dynamodb_table" "food_table" {
  name = "food-table"
  #billing_mode     = "PAY_PER_REQUEST"
  hash_key = "ingredient_1"

  attribute {
    name = "ingredient_1"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "read_dynamo_db" {
  name = "read_dynamo_db"
  role = "iam_for_lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:DescribeScalingActivities",
          "application-autoscaling:DescribeScalingPolicies",
          "cloudwatch:DescribeAlarmHistory",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "datapipeline:DescribeObjects",
          "datapipeline:DescribePipelines",
          "datapipeline:GetPipelineDefinition",
          "datapipeline:ListPipelines",
          "datapipeline:QueryObjects",
          "dynamodb:BatchGetItem",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PartiQLSelect",
          "dax:Describe*",
          "dax:List*",
          "dax:GetItem",
          "dax:BatchGetItem",
          "dax:Query",
          "dax:Scan",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "iam:GetRole",
          "iam:ListRoles",
          "kms:DescribeKey",
          "kms:ListAliases",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "lambda:ListFunctions",
          "lambda:ListEventSourceMappings",
          "lambda:GetFunctionConfiguration",
          "resource-groups:ListGroups",
          "resource-groups:ListGroupResources",
          "resource-groups:GetGroup",
          "resource-groups:GetGroupQuery",
          "tag:GetResources",
          "kinesis:ListStreams",
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "cloudwatch:GetInsightRuleReport",
        Effect   = "Allow",
        Resource = "arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*"
      }
    ]
  })
}

data "archive_file" "zip_python_code" {
  type        = "zip"
  source_file = "${path.module}/python/lambda_code.py"
  output_path = "${path.module}/python/lambda_code.zip"
}

resource "aws_lambda_function" "terra_func_lambda" {
  filename      = "${path.module}/python/lambda_code.zip"
  function_name = "Fetch-Recipe"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_code.handler"
  runtime       = "python3.9"
}