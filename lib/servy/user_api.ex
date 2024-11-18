defmodule Servy.UserApi do
  def query(id) do
    id
    |> api_url
    |> HTTPoison.get()
    |> handle_response
  end

  defp api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{URI.encode(id)}"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    city =
      Poison.Parser.parse!(body, %{})
      |> get_in(["address", "city"])

    {:ok, city}
  end

  defp handle_response({:ok, %{status_code: _status, body: body}}) do
    message =
      Poison.Parser.parse!(body, %{})
      |> get_in(["message"])

    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
