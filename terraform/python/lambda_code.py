import json
import boto3


def lambda_handler(event, context):

    
    item = event['queryStringParameters']["ingredient"]
        
    #Create our Boto3 client & Set our Table name
    client = boto3.resource("dynamodb")
    table = client.Table("food-table")

    #Get 1 item of the database
    print("item = " + item)
    return table.get_item(Key={"ingredient_1":item})