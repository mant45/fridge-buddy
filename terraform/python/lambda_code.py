import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import *

def lambda_handler(event, context):
    item = event['queryStringParameters']["ingredient"]
        
    #Create our Boto3 client & Set our Table name
    client = boto3.resource("dynamodb")
    table = client.Table("food-table")

    #Get the data that matches & create a payload of what we want to send back to the client
    data = table.scan(FilterExpression=Attr('ingredients_main').contains(item))
    payload = json.dumps(data["Items"], cls=DecimalEncoder)
    return payload

#Since JSON doesn't handle decimals, we need to encode it to another format.    
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return str(obj)
        return json.JSONEncoder.default(self, obj)