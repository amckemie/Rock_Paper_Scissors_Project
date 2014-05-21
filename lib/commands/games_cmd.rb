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

  def make_move(mid, pid, move)
    games = list_games(mid)
    if games[:success?] == false
      return games
    else
      game = games[:games].select {|game| game.win_id == nil}
      match = RPS.db.get_match(mid)
      if match.p1_id == pid
        RPS.db.update_game(game[0].id, p1_pick: move)
        return {success?: true, winner: nil}
      else
        finished_game = RPS.db.update_game(game[0].id, p2_pick: move)
        result =  decide_winner(finished_game)
        RPS.db.update_game(game[0].id, win_id: result[:winner])
        return result
      end
    end
  end

  def decide_winner(finished_game)
    p1 = finished_game.p1_pick.downcase
    p2 = finished_game.p2_pick.downcase
    if p1 == p2
      return {success?: false, error: "It's a tie."}
    elsif p1 == "rock" && p2 == 'scissors'
      return {success?: true, winner: 1}
    elsif p1 == "paper" && p2 == 'rock'
      return {success?: true, winner: 1}
    elsif p1 == "scissors" && p2 == 'paper'
      return {success?: true, winner: 1}
    else
      return {success?: true, winner: 2}
    end
  end
end
