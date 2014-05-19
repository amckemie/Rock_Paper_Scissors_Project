class RPS::DB
  def initialize
    @db = SQLite3::Database.new "rps.db"
    users = "create table if not exists users(id INTEGER, name TEXT, password TEXT, PRIMARY KEY(id));"
    games = "create table if not exists games(id integer, mid integer, p1_pick string, p2_pick string, win_id integer, PRIMARY KEY(id));"
    matches = "create table if not exists matches(id integer, p1_id integer, p2_id integer, win_id integer, PRIMARY KEY(id));"
    invites = "create table if not exists invites(id integer, inviter integer, invitee integer, PRIMARY KEY(id));"

    tables = [users, games, matches, invites]
    tables.each do |table|
      @db.execute(table)
    end
  end
  # User CRUD methods
  def create_user(data)
    @db.execute("insert into users(name, password) values('#{data[:name]}', '#{data[:password]}');")
    data[:id] = @db.execute("select last_insert_rowid();").flatten.first
    build_user(data)
  end

  def get_user(id)
    user = @db.execute("select * from users where id='#{id}';").flatten
    hash = {:id => user[0], :name => user[1], :password => user[2]}
    build_user(hash)
  end

  def update_user(id, data)
    data.each do |key, value|
      @db.execute("update users set '#{key}' = '#{value}' where id='#{id}';")
    end
    get_user(id)
  end

  def build_user(data)
    RPS::Users.new(data[:id], data[:name], data[:password])
  end
end

module RPS
  def self.db
    @__db_instance ||= DB.new
  end
end
