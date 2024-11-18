defmodule Servy.HttpClient do
  @host ~c"localhost"
  def send_request(request) do
    case :gen_tcp.connect(@host, 4000, [:binary, packet: :raw, active: false]) do
      {:ok, socket} ->
        :ok = :gen_tcp.send(socket, request)
        recieve_response(socket)

      {:error, reason} ->
        IO.puts("Failed to connect: #{reason}")
        {:error, reason}
    end
  end

  def recieve_response(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, response} ->
        :gen_tcp.close(socket)
        response

      {:error, reason} ->
        IO.puts("Failed to recieve response: #{reason}")
        {:error, reason}
    end
  end
end

# request = """
# GET /bears HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# pid = spawn(Servy.HttpServer, :start, [4000])

# response = Servy.HttpClient.send_request(request)
# IO.puts(response)
# IO.puts(pid)
