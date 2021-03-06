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
    {:ok, %Rules{rules | state: :player_1_turn, player4: :set}}
  end

  def check(%Rules{state: :player_1_turn} = rules, :player_1_turn) do
    {:ok, %Rules{rules | state: :player_1_win?}}
  end
  def check(%Rules{state: :player_1_win?} = rules, {:win_check, win_status}) do
    case win_status do
      :no_win -> {:ok, %Rules{rules | state: :player_2_turn}}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(%Rules{state: :player_2_turn} = rules, :player_2_turn) do
    {:ok, %Rules{rules | state: :player_2_win?}}
  end
  def check(%Rules{state: :player_2_win?} = rules, {:win_check, win_status}) do
    case win_status do
      :no_win -> {:ok, %Rules{rules | state: :player_3_turn}}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(%Rules{state: :player_3_turn} = rules, :player_3_turn) do
    {:ok, %Rules{rules | state: :player_3_win?}}
  end

  def check(%Rules{state: :player_3_win?} = rules, {:win_check, win_status}) do
    case win_status do
      :no_win -> {:ok, %Rules{rules | state: :player_4_turn}}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end

  def check(%Rules{state: :player_4_turn} = rules, :player_4_turn) do
    {:ok, %Rules{rules | state: :player_4_win?}}
  end
  def check(%Rules{state: :player_4_win?} = rules, {:win_check, win_status}) do
    case win_status do
      :no_win -> {:ok, %Rules{rules | state: :player_1_turn}}
      :win -> {:ok, %Rules{rules | state: :game_over}}
    end
  end


  # rules, {:win_check, win_status}


  def check(_state, _action), do: :error



end
