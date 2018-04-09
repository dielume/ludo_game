defmodule Ludo.Token do
  alias __MODULE__
  @enforced_keys [:position, :counter]
  defstruct [:position, :counter]

  @max_counter 45

  def new() do
    {%Token{position: 0, counter: 0}}
  end

  def add_counter(token = %Token{}, offset) do
    if token.counter + offset <= @max_counter do
      {:ok, %Token{token | counter: token.counter + offset}}
    else
      {:error, :invalid_counter}
    end
  end

end
