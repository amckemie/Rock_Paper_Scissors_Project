class RPS::DB
  attr_writer :db
  def initialize(filename)
    @db = SQLite3::Database.new(filename)
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

  def get_user(name)
    user = @db.execute("select *, CAST(password AS TEXT) from users where name='#{name}';").flatten
    hash = {:id => user[0], :name => user[1], :password => user[2]}
    build_user(hash)
  end

  def update_user(name, data)
    data.each do |key, value|
      @db.execute("update users set '#{key}' = '#{value}' where name='#{name}';")
    end
    get_user(name)
  end

  def remove_user(name)
    @db.execute("delete from users where name='#{name}';")
  end

  def list_users
    all_users = []
    users = @db.execute("SELECT *, CAST(password AS TEXT) FROM users;")
    users.each do |user|
      all_users << build_user(:id => user[0], :name => user[1], :password => user[2])
    end

    all_users
  end

  def build_user(data)
    RPS::Users.new(data[:id], data[:name], data[:password])
  end

  # Matches CRUD methods
  def create_match(data)
    @db.execute("INSERT INTO matches(p1_id) values('#{data[:p1_id]}');")
    data[:id] = @db.execute("select last_insert_rowid();").flatten.first
    build_match(data)
  end

  def get_match(id)
    match = @db.execute("select * from matches where id='#{id}';").flatten
    hash = {:id => match[0], :p1_id => match[1], :p2_id => match[2], :win_id => match[3]}
    build_match(hash)
  end

  def update_match(id, data)
    data.each do |key, value|
      @db.execute("update matches set '#{key}' = '#{value}' where id='#{id}';")
    end
    get_match(id)
  end

  def remove_match(id)
    @db.execute("delete from matches where id='#{id}';")
  end

  def build_match(data)
    RPS::Matches.new(data[:id], data[:p1_id], data[:p2_id], data[:win_id])
  end

  def list_matches
    all_matches = []
    matches = @db.execute("SELECT * FROM matches;")
    matches.each do |match|
      all_matches << build_match(:id => match[0], :p1_id => match[1], :p2_id => match[2], :win_id => match[3])
    end

    all_matches
  end

  # Game CRUD methods
  def create_game(data)
    @db.execute("INSERT INTO games(mid) values('#{data[:mid]}');")
    data[:id] = @db.execute("select last_insert_rowid();").flatten.first
    build_game(data)
  end

  def get_game(id)
    game = @db.execute("select * from games where id='#{id}';").flatten
    hash = {:id => game[0], mid: game[1], p1_pick: game[2], p2_pick: game[3], win_id: game[4]}
    build_game(hash)
  end

  def update_game(id, data)
    data.each do |key, value|
      @db.execute("update games set '#{key}' = '#{value}' where id='#{id}';")
    end
    get_game(id)
  end

  def remove_game(id)
    @db.execute("delete from games where id='#{id}';")
  end

  def build_game(data)
    RPS::Games.new(data[:id], data[:mid], data[:p1_pick], data[:p2_pick], data[:win_id])
  end

  # Invite CRUD methods
  def create_invite(data)
    @db.execute("INSERT INTO invites(inviter, invitee) values('#{data[:inviter]}', '#{data[:invitee]}');")
    data[:id] = @db.execute("select last_insert_rowid();").flatten.first
    build_invite(data)
  end

  def get_invite(id)
    invite = @db.execute("select * from invites where id='#{id}';").flatten
    hash = {:id => invite[0], mid: invite[1], p1_pick: invite[2], p2_pick: invite[3], win_id: invite[4]}
    build_invite(hash)
  end

  def list_invites
    all_invites = []
    invites = @db.execute("SELECT * FROM invites;")
    invites.each do |invite|
      all_invites << build_invite(:id => invite[0], :inviter => invite[1], :invitee => invite[2])
    end

    all_invites
  end

  def remove_invite(id)
    @db.execute("delete from invites where id='#{id}';")
  end

  def build_invite(data)
    RPS::Invites.new(data[:id], data[:inviter], data[:invitee])
  end

  # testing helper method
  def clear_table(table_name)
    @db.execute("delete from '#{table_name}';")
  end
end

module RPS
  def self.db
    @__db_instance ||= DB.new("rps.db")
  end
end
