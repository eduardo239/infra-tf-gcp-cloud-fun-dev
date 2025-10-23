def hello_pubsub(event, context):
    import base64
    message = base64.b64decode(event['data']).decode('utf-8') if 'data' in event else 'No message'
    print(f"Received message: {message}")
    return f"Processed: {message}"