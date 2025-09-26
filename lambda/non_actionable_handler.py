import json
import os
import boto3


s3 = boto3.client('s3')
BUCKET = os.environ.get('NON_ACTIONABLE_BUCKET')




def lambda_handler(event, context):
detail = event.get('detail', {})
event_arn = detail.get('eventArn', '')
if not event_arn:
return { 'status': 'no-event-arn' }


event_id = event_arn.split('/')[-1]
key = f"non-actionable/{event_id}.json"


s3.put_object(Bucket=BUCKET, Key=key, Body=json.dumps(detail))


return { 'status': 'stored', 'key': key }