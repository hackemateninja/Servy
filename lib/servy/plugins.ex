defmodule Servy.Plugins do
  require Logger
  alias Servy.Conv

  def emojify(%Conv{status: 200, resp_body: resp_body} = conv) do
    emojies = String.duplicate("🥋", byte_size(resp_body))

    %{conv | resp_body: emojies <> "\n" <> resp_body <> "\n" <> emojies}
  end

  def emojify(%Conv{} = conv), do: conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      IO.puts("warning #{path} is on the loose!")
    end

    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv), do: %{conv | path: "/wildthings"}

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv), do: %{conv | path: "/bear/" <> id}

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{status: 200} = conv) do
    Logger.info(conv.resp_body)
    conv
  end

  def log(%Conv{status: 500} = conv) do
    Logger.error(conv.resp_body)
    conv
  end

  def log(%Conv{status: 403} = conv) do
    Logger.warning(conv.resp_body)
    conv
  end

  def log(%Conv{status: 404} = conv) do
    Logger.warning(conv.resp_body)
    conv
  end

  def log(%Conv{} = conv) do
    if Mix.env() != :test do
      IO.inspect(conv)
    end

    conv
  end

  def put_content_length(%Conv{} = conv) do
    headers = Map.put(conv.resp_headers, "Content-Length", String.length(conv.resp_body))

    %{conv | resp_headers: headers}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  defp format_response_headers(%Conv{} = conv) do
    for {key, value} <- conv.resp_headers do
      "#{key}: #{value}\r"
    end
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
