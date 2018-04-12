defmodule Ludo.Dice do
  @posible_values 1..6

  def throw do
    dice1 = random_dice(@posible_values)
    dice2 = random_dice(@posible_values)
    {dice1, dice2, dice1 + dice2}
  end

  defp random_dice(values) do
    Enum.random(values)
  end


end
