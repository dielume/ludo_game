defmodule Ludo.Game do
  alias Ludo.{Rules, Token}
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient
  @timeout 60 * 60 * 24 * 1000
  @players [:player1, :player2, :player3, :player4]

  def init(name) do
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
      |> update_player2_name(name)
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
      |> update_player3_name(name)
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
      |> update_player4_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
    :error -> {:reply, :error, state_data}
    end
  end


  defp fresh_state(name) do
    player1 = %{name: name, tokens: Token.new()}
    player2 = %{name: nil, tokens: Token.new()}
    player3 = %{name: nil, tokens: Token.new()}
    player4 = %{name: nil, tokens: Token.new()}
    %{player1: player1, player2: player2, player3: player3,
    player4: player4, rules: %Rules{}}
  end

  defp update_player2_name(state_data, name), do:
    put_in(state_data.player2.name, name)
  defp update_player3_name(state_data, name), do:
    put_in(state_data.player3.name, name)
  defp update_player4_name(state_data, name), do:
    put_in(state_data.player4.name, name)
  defp update_rules(state_data, rules), do:
    %{state_data | rules: rules}
  defp reply_success(state_data, reply) do
    # :ets.insert(:game_state,{state_data.player1.name, state_data})
    {:reply, reply, state_data, @timeout}
  end

end
