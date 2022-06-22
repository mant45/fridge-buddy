import json
import boto3
from boto3.dynamodb.conditions import Key, Attr


def lambda_handler(event, context):
    item = event['queryStringParameters']["ingredient"]
        
    #Create our Boto3 client & Set our Table name
    client = boto3.resource("dynamodb")
    table = client.Table("food-table")

    #Get keyword filtered items of the database
<<<<<<< HEAD
    return table.scan(FilterExpression=Attr('ingredients_main').contains(item))
=======
    return{
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        'body': table.scan(FilterExpression=Attr('ingredients_main').contains(item))
    }
>>>>>>> c8fe64225a726b084a137bedef789bc92f008657
