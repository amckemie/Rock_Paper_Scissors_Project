class RPS::Invites
  attr_reader :id, :inviter, :invitee
  def initialize(id, inviter, invitee)
    @id = id
    @inviter = inviter
    @invitee = invitee
  end
end
