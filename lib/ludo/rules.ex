defmodule Ludo.Rules do
  alias __MODULE__
  defstruct state: :initialized, player1: :not_set, player2: :not_set,
            player3: :not_set, player4: :not_set

  def new(), do: %Rules{}

  def check(%Rules{state: :initialized} = rules, :add_player), do:
    {:ok, %Rules{rules | state: :waiting_players}}

  def check(%Rules{state: :waiting_players} = rules, {:add_player, player}) do

  end

  # def check(%Rules{state: :player_set} = rules, {:all_player_ready, board) do
  #
  # end


end
