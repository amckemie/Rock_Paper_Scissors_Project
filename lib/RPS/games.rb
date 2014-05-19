class RPS::Games
  attr_reader :id, :mid, :p1_pick, :p2_pick, :win_id
  def initialize(id, mid, p1_pick, p2_pick)
    @id = id
    @mid = mid
    @p1_pick = p1_pick
    @p2_pick = p2_pick
    @win_id = nil
  end
end
