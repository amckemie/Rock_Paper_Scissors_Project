class RPS::InvitesCmd
  def create_invite(inviter, invitee)
    invitee = RPS.db.get_user(invitee)
    if invitee.name != nil
      inviter = RPS.db.get_user(inviter)
      invite = RPS.db.create_invite(inviter: inviter.id, invitee: invitee.id)
      return {
        success?: true,
        invite: invite
      }
    else
      return {success?: false, error: "That user doesn't exist."}
    end
  end

  def list_invites(name)
    user = RPS.db.get_user(name)
    if user.name != nil
      pending_invites = []
      invites = RPS.db.list_invites
      invites.each do |invite|
        if invite.invitee == user.id
          pending_invites << invite
        end
      end
      return {
        success?: true,
        invites: pending_invites
      }
    else
      return {success?: false, error: "That user doesn't exist."}
    end
  end
end
