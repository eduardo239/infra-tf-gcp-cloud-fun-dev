def hello_world(request):
  request_json = request.get_json(silent=True)
  name = request_json.get("name") if request_json and "name" in request_json else "World"
  return f"Hello, {name}!"