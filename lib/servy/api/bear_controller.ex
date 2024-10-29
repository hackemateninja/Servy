defmodule Servy.Api.BearController do
  alias Servy.Conv
  alias Poison
  alias Servy.Wildthings

  defp put_resp_content_type(conv, type) do
    headers = Map.put(conv.resp_headers, "Content-Type", type)
    %{conv | resp_headers: headers}
  end

  def index(%Conv{} = conv) do
    json =
      Wildthings.list_bears()
      |> Poison.encode!()

    conv = put_resp_content_type(conv, "application/json")

    %Conv{conv | resp_body: json, status: 200}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %Conv{conv | resp_body: "Created a #{type} bear named #{name}!", status: 201}
  end
end
