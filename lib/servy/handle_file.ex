defmodule Servy.HandleFile do
  alias Servy.Conv

  def read_file(file, %Conv{} = conv) do
    case File.read(file) do
      {:ok, content} -> %{conv | status: 200, resp_body: content}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "File not found!"}
      {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
    end
  end
end
