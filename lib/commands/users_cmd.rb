
class RPS::UsersCmd
  def sign_up(name, password)
    user = RPS.db.get_user(name)
    if user.name != nil
      return {success?: false, error: "That username is already taken."}
    elsif /[a-zA-Z]/.match(password) == nil
      return {success?: false, error: "Your password does not include at least one character."}
    else
      RPS.db.create_user(:name => name, :password => password)
      return {success?: true}
    end
  end

  def sign_in(name, password)
    user = RPS.db.get_user(name)
    if user.name == nil
      return {success?: false, error: "That username does not exist."}
    elsif user.password != password
      return {success?: false, error: "That is the wrong password."}
    else
      return{success?: true}
    end
  end

end
