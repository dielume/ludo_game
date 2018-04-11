defmodule Ludo.Token do
  alias __MODULE__
  @enforce_keys [:position, :counter, :number]
  defstruct @enforce_keys
  @types ~w(one two three four)

  @max_counter 45

  def new() do
    Enum.map(@types, fn type -> %Token{position: 0, counter: 0, number: type} end)
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
