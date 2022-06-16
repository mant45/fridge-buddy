import json
import boto3
from boto3.dynamodb.conditions import Key, Attr


def lambda_handler(event, context):
    item = event['queryStringParameters']["ingredient"]
        
    #Create our Boto3 client & Set our Table name
    client = boto3.resource("dynamodb")
    table = client.Table("food-table")

    #Get all items of the database
    return json.dumps(table.scan(FilterExpression=Attr('ingredient_1').contains(item)))