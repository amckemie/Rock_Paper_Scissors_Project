require 'pry-debugger'

class RPS::MatchesCmd
  def active_matches(id)
    matches = RPS.db.list_matches
    matches.select! {|match| (match.p1_id == id || match.p2_id == id) && match.win_id == nil}
    if matches.length == 0
      return {success?: false, error: "There are no active matches."}
    else
      return {success?: true, matches: matches}
    end
  end
end
