resource "aws_dynamodb_table" "food_table" {
  name         = "food-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "recipe_id"

  attribute {
    name = "recipe_id"
    type = "N"
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
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "${aws_dynamodb_table.food_table.arn}"
      },
      {
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect: "Allow"
        Resource: "*"
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
  filename         = "${path.module}/python/lambda_code.zip"
  function_name    = "Fetch-Recipe"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_code.lambda_handler"
  source_code_hash = filebase64sha256("python/lambda_code.zip")
  runtime          = "python3.9"
}

resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "fridge-buddy-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["https://*"]
  }
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id               = aws_apigatewayv2_api.lambda_api.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  payload_format_version = "2.0"
  integration_uri      = aws_lambda_function.terra_func_lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /getrecipe"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terra_func_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*/getrecipe"
}