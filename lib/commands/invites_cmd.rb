class RPS::InvitesCmd
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
