defmodule LudoTest do
  use ExUnit.Case
  doctest Ludo

  test "greets the world" do
    assert Ludo.hello() == :world
  end
end
