defmodule Servy.Bear do
  alias __MODULE__
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_grizzly(%Bear{} = bear) do
    bear.type == "Grizzly"
  end

  def order_asc_by_name(%Bear{} = b1, %Bear{} = b2) do
    b1.name <= b2.name
  end
end
