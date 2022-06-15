import json
import json
import boto3


def lambda_handler(event, context):

    if event['rawPath'] == "/request":
        item = event['queryStringParameters']["ingredient"]
        
        #Create our Boto3 client & Set our Table name
        client = boto3.resource("dynamodb")
        table = client.Table("recipe")

        #Get 1 item of the database
        item = table.get_item(Key={"name":"Kenneth"})
        return item