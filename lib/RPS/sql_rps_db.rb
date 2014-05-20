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
