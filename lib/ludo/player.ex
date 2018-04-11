defmodule Ludo.Player do
  alias Ludo.{Player, Token}
  @enforce_keys [:name, :tokens]
  defstruct @enforce_keys

  def new(name) do
    %Player{name: name, tokens: Token.new()}
  end

end
