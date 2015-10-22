defmodule TennisKataTest do
  use ExUnit.Case

  setup do
    game = spawn_link(Game, :start, [])
    {:ok, game: game}
  end

  test "it returns zero all", %{game: game} do
  	send game, {:get_score, self}
  	assert_receive {:score, [0, 0]}
  end

  test "player one scored one point", %{game: game} do
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [15, 0]}
  end

  test "player two scored one point", %{game: game} do
    send game, :player_two
    send game, {:get_score, self}
    assert_receive {:score, [0, 15]}
  end

  test "players scored one point", %{game: game} do
    send game, :player_one
    send game, :player_two
    send game, {:get_score, self}
    assert_receive {:score, [15, 15]}
  end

  test "player one scored two point", %{game: game} do
    send game, :player_one
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [30, 0]}
  end

  test "player two scored two point", %{game: game} do
    send game, :player_two
    send game, :player_two
    send game, {:get_score, self}
    assert_receive {:score, [0, 30]}
  end

  test "a player scored three point", %{game: game} do
    send game, :player_one
    send game, :player_one
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [40, 0]}
  end

  test "a player win the match", %{game: game} do
    send game, :player_one
    send game, :player_one
    send game, :player_one
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [:win, _]}
  end

  test "a player lose the match", %{game: game} do
    send game, :player_two
    send game, :player_two
    send game, :player_two
    send game, :player_two
    send game, {:get_score, self}
    assert_receive {:score, [:lose, :win]}
  end

  test "player one in advantage", %{game: game} do
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [:advantage, 40]}
  end

  test "player two in advantage", %{game: game} do
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, {:get_score, self}
    assert_receive {:score, [40, :advantage]}
  end

  test "tie score after advantage", %{game: game} do
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, {:get_score, self}
    assert_receive {:score, [40, 40]}
  end

  test "a player win after an advantage", %{game: game} do
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_one
    send game, :player_two
    send game, :player_two
    send game, {:get_score, self}
    assert_receive {:score, [:lose, :win]}
  end

end
