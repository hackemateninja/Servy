defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Conv
  alias Servy.Bear
  @templates_path Path.expand("templates", File.cwd!())

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %Conv{conv | resp_body: content, status: 200}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.heex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.heex", bear: bear)
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{conv | status: 201, resp_body: "Create a #{type} bear named #{name}!"}
  end

  def delete(conv) do
    %Conv{conv | resp_body: "Deleting a bear is forbiddne!", status: 403}
  end
end
