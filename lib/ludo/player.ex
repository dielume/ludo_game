defmodule Ludo.Player do
  alias Ludo.{Player, Token}
  @enforced_keys [:tokens]
  defstruct [:tokens]

  def new() do
    %Player{tokens: Token.new}
  end
end
