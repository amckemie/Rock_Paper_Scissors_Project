class RPS::GamesCmd

  def list_games(mid)
    games = RPS.db.list_games
    games.select! {|game| game.mid == mid}
    if games.length == 0
      return {success?: false, error: "There are no games associated with this match."}
    else
      return {success?: true, games: games}
    end
  end
end
