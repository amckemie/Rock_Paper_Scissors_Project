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
    let(:user1) {RPS.db.create_user(:name => "Ashley", :password => "1234")}

    it "creates a user with unique username and password" do
      user1
      expect(user1.name).to eq("Ashley")
      expect(user1.password).to eq("1234")
      expect(user1.id).to be_a(Fixnum)
    end
  end

  # describe 'games' do
  # end

  # describe 'matches' do
  # end

  # describe 'invites' do
  # end
end
