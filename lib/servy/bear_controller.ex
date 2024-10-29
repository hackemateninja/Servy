defmodule Servy.BearController do
  alias Servy.BearView
  alias Servy.Wildthings
  alias Servy.Conv
  alias Servy.Bear
  alias Poison

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    %Conv{conv | resp_body: BearView.index(bears), status: 200}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %Conv{conv | resp_body: BearView.show(bear), status: 200}
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

  def delete(conv) do
    %Conv{conv | resp_body: "Deleting a bear is forbiddne!", status: 403}
  end
end
