class RPS::Matches
  attr_reader :id, :win_id, :p1_id, :p2_id
  def initialize(id, p1_id, p2_id)
    @id = id
    @p1_id = p1_id
    @p2_id = p2_id
    @win_id = nil
  end
end
