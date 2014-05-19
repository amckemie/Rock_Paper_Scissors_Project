require 'spec_helper'

describe 'db' do
  it "exists" do
    expect(DB).to be_a(Class)
  end

  it "returns a db" do
    expect(RPS.db).to be_a(DB)
  end

  it "is a singleton" do
    db1 = RPS.db
    db2 = RPS.db
    expect(db1).to be(db2)
  end

  # testing users
  describe 'users' do
    before(:each) do
      RPS.db.clear_table("users")
    end

    let(:user1) {RPS.db.create_user(:name => "Ashley", :password => "abc")}

    it "creates a user with unique username and password" do
      expect(user1.name).to eq("Ashley")
      expect(user1.password).to eq("abc")
      expect(user1.id).to be_a(Fixnum)
    end

    it "returns a User object" do
      user = RPS.db.get_user(user1.name)
      expect(user).to be_a(RPS::Users)
      expect(user.name).to eq("Ashley")
      expect(user.password).to eq("abc")
      expect(user.id).to be_a(Fixnum)
    end

    it "updates a user's information" do
      user = RPS.db.update_user(user1.name, :password => "abc12")
      expect(user.name).to eq("Ashley")
      expect(user.password).to eq("abc12")
      expect(RPS.db.get_user(user1.name).password).to eq("abc12")
    end

    it "removes a user" do
      expect(RPS.db.remove_user(user1.name)).to eq([])
    end
  end

  # describe 'games' do
  # end

  # describe 'matches' do
  # end

  # describe 'invites' do
  # end
end
