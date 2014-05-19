class RPS::DB
end

module RPS
  def self.db
    @__db_instance ||= DB.new
  end
end
