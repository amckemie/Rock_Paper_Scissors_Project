require 'pry-debugger'

class RPS::MatchesCmd
  def get_active_matches(id)
    matches = RPS.db.list_matches
    matches.select! {|match| (match.p1_id == id || match.p2_id == id) && match.win_id == nil}
    matches.length
  end

  def list_active_matches(id)
  end
end
