defmodule Game do
  def start do
    game([0, 0])
  end

  def game([player_one, player_two]) do
    receive do
      {:get_score, pid} -> send pid, {:score, [player_one, player_two]}
      :player_one -> game(next_score(:player_one, [player_one, player_two]))
      :player_two -> game(next_score(:player_two, [player_one, player_two]))
    end
  end

  defp next_score(player, [player_one_score, player_two_score]) do
    case player do
      :player_one -> add_point([player_one_score, player_two_score])
      :player_two -> Enum.reverse(add_point([player_two_score, player_one_score]))
    end
  end

  defp add_point([winner_score, loser_score]) do
    case [winner_score, loser_score] do
      [:advantage, _]  -> [:win, :lose]
      [40, :advantage] -> [40, 40]
      [40, 40]         -> [:advantage, 40]
      [40, _]          -> [:win, :lose]
      [30, _]          -> [40, loser_score]
        _              -> [winner_score + 15, loser_score]
    end
  end
end
