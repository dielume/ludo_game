defmodule Ludo.Token do
  alias __MODULE__
  @enforce_keys [:position, :counter, :number]
  defstruct @enforce_keys
  @types ~w(one two three four)

  @max_counter 45

  def new(:player1) do
    loop_token(@types, 1)
  end

  def new(:player2) do
    loop_token(@types, 11)
  end

  def new(:player3) do
    loop_token(@types, 21)
  end

  def new(:player4) do
    loop_token(@types, 31)
  end

  defp loop_token([], _offset), do: []

  defp loop_token(tokens, offset) do
    [head | tail] = tokens
    head = %Token{position: offset, counter: 0, number: head}
    [head | loop_token(tail, offset)]
  end


  def add_counter_position(tokens, number, offset) do
    with {:ok, %Token{} = token} <- valid_token_number(tokens, number),
         {:ok, counter_token} <- valid_counter(token, offset),
         {:ok, final_token} <- valid_position(counter_token, offset)
    do
      {:ok, final_token}
    else
      error -> {:error, error}
    end
  end

  defp valid_position(%Token{} = token, offset) do
    cond do
      token.position + offset > 40 ->
        {:ok, %Token{token | position: token.position + offset - 40}}
      token.position + offset <=  40 ->
        {:ok, %Token{token | position: token.position + offset}}
      true ->
        {:error, :invalid_counter}
    end
  end

  defp valid_token_number(tokens, number) do
    case Enum.find(tokens, fn token -> token.number == number end) do
      token = %Token{} -> {:ok ,token}
      nil -> {:error, :invalid_token}
    end
  end

  defp valid_counter(%Token{} = token, offset) do
    cond do
      token.counter + offset <= @max_counter ->
        {:ok, %Token{token | counter: token.counter + offset}}
      token.counter + offset > @max_counter ->
        {:ok, %Token{token | counter: @max_counter}}
      true ->
        {:error, :invalid_counter}
    end
  end

end
