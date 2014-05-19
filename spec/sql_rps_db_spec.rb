require 'spec_helper'
require 'fileutils'

describe 'db' do
  let(:db) do
    if File.exists?("test.db")
      FileUtils.rm("test.db")
    end

    RPS::DB.new("test.db")
  end

  it "exists" do
    expect(DB).to be_a(Class)
  end

  it "returns a db" do
    expect(db).to be_a(DB)
  end

  # testing users
  describe 'users' do

    let(:user1) {db.create_user(:name => "Ashley", :password => "abc")}

    it "creates a user with unique username and password" do
      expect(user1.name).to eq("Ashley")
      expect(user1.password).to eq("abc")
      expect(user1.id).to be_a(Fixnum)
    end

    it "returns a User object" do
      user = db.get_user(user1.name)
      expect(user).to be_a(RPS::Users)
      expect(user.name).to eq("Ashley")
      expect(user.password).to eq("abc")
      expect(user.id).to be_a(Fixnum)
    end

    it "updates a user's information" do
      user = db.update_user(user1.name, :password => "abc12")
      expect(user.name).to eq("Ashley")
      expect(user.password).to eq("abc12")
      expect(db.get_user(user1.name).password).to eq("abc12")
    end

    it "removes a user" do
      expect(db.remove_user(user1.name)).to eq([])
    end
  end

  # describe 'games' do
  # end

  # describe 'matches' do
  # end

  # describe 'invites' do
  # end
end
