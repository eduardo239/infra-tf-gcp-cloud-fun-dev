import base64


def hello_pubsub(event, context):
    """Process Pub/Sub message with safe decoding and size limit."""
    max_message_size = 1024 * 1024  # 1 MiB
    default_message = "No message"

    if "data" not in event:
        return f"Processed: {default_message}"

    try:
        raw = event["data"]
        if isinstance(raw, str):
            raw = raw.encode("utf-8")
        decoded = base64.b64decode(raw, validate=True)
        if len(decoded) > max_message_size:
            return "Processed: message too large"
        message = decoded.decode("utf-8")
    except (ValueError, UnicodeDecodeError, TypeError):
        return "Processed: invalid message encoding"

    # Log only length to avoid leaking sensitive content
    print(f"Received message length: {len(message)}")
    return f"Processed: {message}"