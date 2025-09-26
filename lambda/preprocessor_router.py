import os




def rules_based_label(detail):
# Simple rules fallback
cat = detail.get('eventTypeCategory', '')
status = detail.get('statusCode', '')
if cat in ['issue', 'scheduledChange'] and status in ['open','upcoming']:
return 'actionable'
return 'non_actionable'




def store_actionable(detail):
table = dynamodb.Table(ACTIONABLE_TABLE)
item = {
'eventArn': detail['eventArn'],
'service': detail.get('service', ''),
'eventTypeCode': detail.get('eventTypeCode', ''),
'status': detail.get('statusCode', ''),
'region': detail.get('region', 'global'),
'startTime': str(detail.get('startTime', '')),
'endTime': str(detail.get('endTime', '')),
'lastUpdatedTime': str(detail.get('lastUpdatedTime', ''))
}
table.put_item(Item=item)




def store_non_actionable(detail):
event_arn = detail.get('eventArn', '')
if not event_arn:
return
event_id = event_arn.split('/')[-1]
key = f"non-actionable/{event_id}.json"
s3.put_object(Bucket=NON_ACTIONABLE_BUCKET, Key=key, Body=json.dumps(detail))




def lambda_handler(event, context):
# EventBridge sends records with 'detail'
detail = event.get('detail')
if not detail:
# Might be batch - handle each record
for rec in event.get('Records', []):
body = json.loads(rec['body'])
detail = body.get('detail')
if detail:
label = call_sagemaker(detail)
if label == 'actionable':
store_actionable(detail)
else:
store_non_actionable(detail)
return { 'status': 'processed_records' }


label = call_sagemaker(detail)
if label == 'actionable':
store_actionable(detail)
else:
store_non_actionable(detail)


return { 'status': 'ok', 'label': label }