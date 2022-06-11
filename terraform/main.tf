resource "aws_dynamodb_table" "food_table" {
  name             = "food-table"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "ingredient_1"

  attribute {
    name = "ingredient_1"
    type = "S"
  }
}