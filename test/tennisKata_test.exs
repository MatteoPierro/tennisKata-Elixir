defmodule Game do
  def start do
    game(0, 0)
  end

  def game(player_one, player_two) do
    receive do
      {:get_score, pid} -> send pid, {:score, [player_one, player_two]}
      :player_one -> game(15, player_two)
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

  test "player scored one point" do
    game = spawn_link(Game, :start, [])
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [15, 0]}
  end

end
