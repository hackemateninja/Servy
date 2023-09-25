defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect(conv)

  def parse(request) do
    [method, path, version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split()

    %{method: method, path: path, resp_body: "", version: version, status: nil}
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | resp_body: "Bears, Lions, Tigers", status: 500}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | resp_body: "Teddy, Smokey, Paddington", status: 401}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | resp_body: "Bear #{id}", status: 201}
  end

  def route(%{method: "GET", path: "/bigfoot"} = conv) do
    %{conv | resp_body: "Hey bigfoot", status: 200}
  end

  def route(conv), do: %{conv | resp_body: "No #{conv.path} here!"}

  def format_response(%{status: status, version: version, resp_body: body}) do
    """
    #{version} #{status} #{status_reason(status)}
    Content-Type: text/html
    Content-Length: #{String.length(body)}

    #{body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[code]
  end
end

# expected_response = """
# HTTP/1.1 200 OK
# Content-Type: text/html
# Content-Length: 20
#
# Bears, Lions, Tigers
# """

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
