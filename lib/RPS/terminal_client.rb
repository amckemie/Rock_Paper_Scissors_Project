class RPS::TerminalClient
  def initialize
    user_log_in
  end

  def get_input
    puts "Please enter your choice or exit if you wish to leave."
    gets.chomp.downcase
  end

  def user_log_in
    puts "Welcome to Rock Paper Scissors!"
    puts "[1] Sign in"
    puts "[2] Sign up"
    answer = get_input
    if answer == "1"
      puts "Please enter your username"
      name = gets.chomp
      puts "Please enter your password"
      pw = gets.chomp
      result = RPS::UsersCmd.new.sign_in(name, pw)
      if result[:success?] == false
        puts "#{result[:error]}"
        user_log_in
      else
        welcome_menu(name)
      end
    elsif answer == "2"
      puts "Please enter the username you would like to use:"
      name = gets.chomp
      puts "Please enter your password, using at least one character (ex: a, b, c, etc)"
      pw = gets.chomp
      result = RPS::UsersCmd.new.sign_up(name, pw)
      if !result[:success?]
        puts "#{result[:error]}"
        user_log_in
      else
        puts "Thank you for creating an account."
        welcome_menu(name)
      end
    else
      puts "Sorry, that is not an option."
      user_log_in
    end
  end

  def welcome_menu(name)
    user = RPS.db.get_user(name)
    puts "Welcome '#{user.name}'!"
    active_matches = RPS.db.list_active_matches(user.id)
    puts "You have '#{active_matches.length}' active matches."
    list_menu
    input = get_input
    run(input)
  end

  def list_menu
    puts "Available Options:
          [1] users list - List all users
          [2] match list - List active matches
          [3] match play MID - Start playing game with id=MID
          [4] invites - List all pending invites
          [5] invite accept IID - Accept invite with id=IID
          [6] invite create USERNAME - Invite user with username=USERNAME to play a game
          [7] exit  - Leave Rock Paper Scissors"
  end

  def run(input)
    case input
      # lists all users
    when "1"
      display_users
      get_input
    when "7"
      puts "Goodbye!"
    else
      puts "That is not a valid option."
      get_input
    end
  end

  def display_users
    users = RPS.db.list_users
    puts "| NAME\t | ID |"
    users.each do |user|
      puts "'#{user.name}'\t'#{user.id}'"
    end
  end
end
