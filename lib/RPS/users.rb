class RPS::Users
  attr_reader :id, :name, :password
  def initialize(id, name, password)
    @id = id
    @name = name
    @password = password
  end
end
