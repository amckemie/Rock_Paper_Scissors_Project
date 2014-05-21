require 'sqlite3'

module RPS
end

require_relative './rps/sql_rps_db.rb'
require_relative './rps/users.rb'
require_relative './rps/games.rb'
require_relative './rps/matches.rb'
require_relative './rps/invites.rb'
require_relative './rps/terminal_client.rb'
require_relative './commands/users_cmd.rb'
require_relative './commands/matches_cmd.rb'
require_relative './commands/invites_cmd.rb'
require_relative './commands/games_cmd.rb'
RPS::TerminalClient.new
