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


  def add_counter(tokens, number, offset) do
    with {:ok, %Token{} = token} <- valid_token_number(tokens, number),
      {:ok, final_token} <- valid_counter(token, offset) do
        final_token
    else
      error -> error
    end
  end

  defp valid_token_number(tokens, number) do
    case Enum.find(tokens, fn token -> token.number == number end) do
      token = %Token{} -> {:ok ,token}
      nil -> {:error, :invalid_token}
    end
  end

  defp valid_counter(token, offset) do
    if token.counter + offset <= @max_counter do
      {:ok, %Token{token | counter: token.counter + offset}}
    else
      {:error, :invalid_counter}
    end
  end

end
