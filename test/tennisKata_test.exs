defmodule Game do
  def start do
    receive do
      {:get_score, pid} -> send pid, {:score, [0, 0]}
    end
  end
end

defmodule TennisKataTest do
  use ExUnit.Case

  test "it returns zero all" do
  	game = spawn_link(Game, :start, [])
  	send game, {:get_score, self}
  	assert_receive {:score, [0, 0]}
  end
end
