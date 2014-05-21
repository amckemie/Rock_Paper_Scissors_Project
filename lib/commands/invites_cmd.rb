class RPS::InvitesCmd
  def list_invites(name)
    user = RPS.db.get_user(name)
    if user.name != nil
      RPS.db
    end
  end
end
