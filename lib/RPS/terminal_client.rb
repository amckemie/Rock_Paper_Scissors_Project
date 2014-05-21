class RPS::TerminalClient
  def self.run
    puts "Welcome to Rock Paper Scissors!"
    puts "[1] Sign in"
    puts "[2] Sign up"
    answer = get_input
    user_log_in(answer)
  end

  def get_input
    puts "Please enter your choice or exit if you wish to stop."
    input = gets.chomp.downcase
  end

  def user_log_in(answer)
    if answer == "1"
      puts "Please enter your username"
      name = gets.chomp
      puts "Please enter your password"
      pw = gets.chomp
      result = RPS::UsersCmd.sign_in(name, pw)
      if !result[:success?]
        puts "#{result[:error]}"
        self.run
      else
        # welcome menu method
      end
    elsif answer == "2"
      puts "Please enter the username you would like to use:"
      name = gets.chomp
      puts "Please enter your password, using at least one character (ex: a, b, c, etc)"
      pw = gets.chomp
      result = RPS::UsersCmd.sign_up(name, pw)
      if !result[:success?]
        puts "#{result[:error]}"
        user_log_in(2)
      else
        puts "Thank you for creating an account."
        # welcome menu
      end
    else
      puts "Sorry, that is not an option."
      self.run
    end
  end

  def welcome_menu(name)
    user = RPS.db.get_user(name)
    puts "Welcome '#{user.name}'!"
    active_matches = RPS::MatchesCmd.active_matches(user.id)
    puts "You have '#{active_matches[:matches].length}' active matches."
  end
end
