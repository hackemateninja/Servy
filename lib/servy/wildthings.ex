defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black", hibernating: false},
      %Bear{id: 3, name: "Paddington", type: "Brown", hibernating: false},
      %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snow", type: "Polar", hibernating: false},
      %Bear{id: 6, name: "Brutus", type: "Grizzly", hibernating: false},
      %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
      %Bear{id: 8, name: "Roscoe", type: "Panda", hibernating: false},
      %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
      %Bear{id: 10, name: "Kenai", type: "Grizzly", hibernating: false}
    ]
  end

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear()
  end

  def get_bear(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end
end
