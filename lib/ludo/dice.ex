defmodule Ludo.Dice do
  @posible_values 1..6

  def throw do
    {random_dice(@posible_values), random_dice(@posible_values)}
  end

  defp random_dice(values) do
    Enum.random(values)
  end


end
