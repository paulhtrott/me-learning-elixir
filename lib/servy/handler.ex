defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  # one liner with a single line return
  def log(conv),  do: IO.inspect conv

  def parse(request) do
    # Parse the request string into a map
    # Pattern matching [x, y,z] = [1, 2, 3]. x = 1, y = 2, z = 3
    # _ is wildcard
    # first argument is filled with returned value
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, resp_body: "" }
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{ conv | resp_body: "Bears, Lions, Tigers" }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | resp_body: "Teddy, Smokey, Paddington" }
  end

  def format_response(conv) do
    # Use values in the map the create an HTTP response string
    # Get length of string - String.length(text)
    # Length for content length headers should be in bytes
    # which is - byte_size(text)
    # this is because special characters can take up two bytes, but
    # length will still be 20 characters, not 21, as the byte size would be
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


