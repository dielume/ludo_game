defmodule Ludo.Rules do
  alias __MODULE__
  defstruct state: :initialized, player1: :set, player2: :not_set,
            player3: :not_set, player4: :not_set

  def new(), do: %Rules{}

  def check(%Rules{state: :initialized} = rules, :add_player_2), do:
    {:ok, %Rules{rules | state: :waiting_player_3, player2: :set}}

  def check(%Rules{state: :waiting_player_3} = rules, :add_player_3) do
    {:ok, %Rules{rules | state: :waiting_player_4, player3: :set}}
  end

  def check(%Rules{state: :waiting_player_4} = rules, :add_player_4) do
    {:ok, %Rules{rules | state: :player1_turn, player4: :set}}
  end


  def check(_state, _action), do: :error



  # def check(%Rules{state: :player_set} = rules, {:all_player_ready, board) do
  #
  # end


end
