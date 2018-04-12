defmodule Ludo.Game do
  alias Ludo.{Rules, Token, Dice}
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient
  @timeout 60 * 60 * 24 * 1000
  @players [:player1, :player2, :player3, :player4]

  def init(name) do
    send(self(), {:set_state, name})
    {:ok, fresh_state(name)}
  end

  def start_link(name) when is_binary(name), do:
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  def via_tuple(name), do: {:via, Registry, {Registry.Game, name}}

  def add_player_2(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player_2, name})

  def add_player_3(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player_3, name})

  def add_player_4(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player_4, name})

  def handle_call({:add_player_2, name}, _from, state_data) do
    with {:ok, rules} <- Rules.check(state_data.rules, :add_player_2)
    do
      state_data
      |> update_player_2_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
    :error -> {:reply, :error, state_data}
    end
  end

  def handle_call({:add_player_3, name}, _from, state_data) do
    with {:ok, rules} <- Rules.check(state_data.rules, :add_player_3)
    do
      state_data
      |> update_player_3_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
    :error -> {:reply, :error, state_data}
    end
  end

  def handle_call({:add_player_4, name}, _from, state_data) do
    with {:ok, rules} <- Rules.check(state_data.rules, :add_player_4)
    do
      state_data
      |> update_player_4_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
    :error -> {:reply, :error, state_data}
    end
  end

  def handle_call({:player_1_turn, number}, _from, state_data) do
    with {:ok, rules} <- Rules.check(state_data.rules, :player_1_turn),
         {_dice1, _dice2, dice_sum} <- Dice.throw(),
         {:ok, new_token}<- Token.add_counter(state_data.player1.tokens, number, dice_sum),
         win_status <- Board.win?(new_token),
         {:ok, rules} <- Rules.check(rules, {:win_check, win_status})
    do
      state_data
      |> update_player_1_token(new_token)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state_data}
    end
  end


  def handle_info(:timeout, state_data) do
  {:stop, {:shutdown, :timeout}, state_data}
  end

  def handle_info({:set_state, name}, _state_data) do
    state_data =
    case :ets.lookup(:game_state, name)  do
      [] -> fresh_state(name)
      [{_key, state}] -> state
    end
    :ets.insert(:game_state, {name, state_data})
    {:noreply, state_data, @timeout}
  end

  def terminate({:shutdown, :timeout}, state_data) do
    :ets.delete(:game_state, state_data.player1.name)
    :ok
  end

  def terminate(_reason, _state), do: :ok


  defp fresh_state(name) do
    player1 = %{name: name, tokens: Token.new(:player1)}
    player2 = %{name: nil, tokens: Token.new(:player2)}
    player3 = %{name: nil, tokens: Token.new(:player3)}
    player4 = %{name: nil, tokens: Token.new(:player4)}
    %{player1: player1, player2: player2, player3: player3,
    player4: player4, rules: %Rules{}}
  end


  defp update_player_2_name(state_data, name), do:
    put_in(state_data.player2.name, name)
  defp update_player_3_name(state_data, name), do:
    put_in(state_data.player3.name, name)
  defp update_player_4_name(state_data, name), do:
    put_in(state_data.player4.name, name)
  def update_player_1_token(state_data, new_token) do
    tokens = state_data.player1.tokens
    new_tokens =
      tokens
      |> Enum.map(&match_number_update(&1, new_token))
    put_in(state_data.player1.tokens, new_tokens)
  end

  defp match_number_update(%Token{} = token, new_token) do
    if token.number == new_token.number do
      new_token
    else
      token
    end
  end

  defp update_rules(state_data, rules), do:
    %{state_data | rules: rules}
  defp reply_success(state_data, reply) do
    :ets.insert(:game_state,{state_data.player1.name, state_data})
    {:reply, reply, state_data, @timeout}
  end

end
