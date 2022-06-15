import json
import boto3

def lambda_handler(event, context):
    #Create our Boto3 client & Set our Table name
    client = boto3.resource("dynamodb")
    table = client.Table("recipe")
    
    #Scan all items of the database
    items = table.scan()
    
    #Get 1 item of the database
    item = table.get_item(Key={"name":"Kenneth"})
    print(items)