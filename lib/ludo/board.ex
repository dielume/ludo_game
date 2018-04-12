defmodule Ludo.Board do
  alias __MODULE__

  def new do
    %{}
  end

  def win?(player) do
    case Enum.all?(player.tokens, fn token -> token.counter == 45 end) do
      true -> :win
      false -> :no_win
    end
  end

  # def add_player_name(board = %Board{}, name) do
  #   %Board{board | player_name: name}
  # end


end
