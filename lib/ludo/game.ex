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

  def add_player(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player, name})

  def handle_call({:add_player, name}, _from, state_data) do
    review_players(state_data)
    {:reply, :ok, state_data, @timeout}
  end

  defp fresh_state(name) do
    player1 = %{name: name, tokens: Token.new()}
    player2 = %{name: nil, tokens: Token.new()}
    player3 = %{name: nil, tokens: Token.new()}
    player4 = %{name: nil, tokens: Token.new()}
    %{player1: player1, player2: player2, player3: player3,
    player4: player4, rules: %Rules{}}
  end

  defp review_players(state_data) do
    with {:ok, player2} <- player_exist?(state_data, :player2),
      {:ok, player3} <- player_exist?(state_data, :player3),
      {:ok, player4} <- player_exist?(state_data, :player4)
    do
      {:ok, state_data}
    else
      {:missing_player2, player2} -> player2,
      {:missing_player3, player3} -> player3,
      {:missing_player4, player4} -> player4

    end
  end

  defp player_exist?(state_data, :player2) do
    if state_data.player2.name do
      {:ok, state_data.player2}
    else
      {:missing_player2, state_data.player2}
    end
  end
  defp player_exist?(state_data, :player3) do
    if state_data.player3.name do
      {:ok, state_data.player3}
    else
      {:missing_player3, state_data.player3}
    end
  end
  defp player_exist?(state_data, :player4) do
    if state_data.player4.name do
      {:ok, state_data.player4}
    else
      {:missing_player4, state_data.player4}
    end
  end


end
