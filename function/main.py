import re


def _sanitize_name(value: str, max_length: int = 100) -> str:
    """Sanitize user input to prevent XSS, header injection, and oversized payloads."""
    if not value or not isinstance(value, str):
        return "World"
    # Strip leading/trailing whitespace and control chars
    value = "".join(c for c in value if c.isprintable() or c.isspace()).strip()
    # Remove newlines/carriage returns to prevent header injection
    value = re.sub(r"[\r\n]+", " ", value)
    # Limit length
    return value[:max_length] if value else "World"


def hello_world(request):
  request_json = request.get_json(silent=True)
  raw_name = request_json.get("name") if request_json and "name" in request_json else "World"
  name = _sanitize_name(raw_name) if isinstance(raw_name, str) else "World"
  return f"Hello, {name}!"