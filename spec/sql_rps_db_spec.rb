require 'spec_helper'
require 'fileutils'

describe 'db' do
  let(:db) do
    if File.exists?("test.db")
      FileUtils.rm("test.db")
    end

    RPS::DB.new("test.db")
  end
  let(:user1) {db.create_user(:name => "Ashley", :password => "1234")}
  let(:user2) {db.create_user(:name => "Katrina", :password => "123kb")}
  let(:match) {db.create_match({:p1_id => user1.id})}
  let(:game1) {db.create_game({mid: match.id})}
  let(:invite1) {db.create_invite({inviter: user1.id, invitee: user2.id})}

  it "exists" do
    expect(DB).to be_a(Class)
  end

  it "returns a db" do
    expect(db).to be_a(DB)
  end

  # testing users
  describe 'users' do

    it "creates a user with unique username and password" do
      expect(user1.name).to eq("Ashley")
      expect(user1.password).to eq("1234")
      expect(user1.id).to be_a(Fixnum)
    end

    it "returns a User object" do
      user = db.get_user(user1.name)
      expect(user).to be_a(RPS::Users)
      expect(user.name).to eq("Ashley")
      expect(user.password).to eq("1234")
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

    it "lists all users" do
      user1
      katrina = db.create_user(:name => "Katrina", :password => "123kb")
      users = db.list_users
      expect(users[0].name).to eq("Ashley")
      expect(users[1].name).to eq("Katrina")
      expect(users.size).to eq(2)
    end
  end

  describe 'matches' do
    describe "create_match" do
      it "creates a match with unique id and win_id set to nil" do
        expect(match.id).to be_a(Fixnum)
        expect(match.p2_id).to eq(nil)
        expect(match.win_id).to eq(nil)
      end

      it "takes in 1 player id and set it equal to p1_id" do
        expect(match.p1_id).to eq(user1.id)
      end
    end

    it "returns a match object given match id" do
      match_id = match.id
      expect(db.get_match(match_id).id).to eq(match.id)
    end

    describe '#update_match' do
      it 'updates a match with given data' do
        db.update_match(match.id, p2_id: 6)
        expect(db.get_match(match.id).p2_id).to eq(6)
      end

      it 'returns a match object' do
        result = db.update_match(match.id, p2_id: 6)
        expect(result.p2_id).to eq(6)
        expect(result.win_id).to eq(nil)
        result2 = db.update_match(match.id, win_id: user1.id)
        expect(result2.win_id).to eq(user1.id)
      end
    end

    it 'should delete a match' do
      expect(db.remove_match(match.id)).to eq([])
    end

    it "lists all matches" do
      match
      match2 = db.create_match({:p1_id => user2.id})
      matches = db.list_matches
      expect(matches[0].id).to eq(match.id)
      expect(matches[1].id).to eq(match2.id)
      expect(matches.size).to eq(2)
    end
  end

  describe 'games' do

    describe '#create_game' do
      it 'should create a game with a match id and unique id' do
        expect(game1.mid).to eq(match.id)
        expect(game1.id).to be_a(Fixnum)
      end

      it 'should set p1_pick and p2_pick and win_id to nil' do
        expect(game1.p1_pick).to eq(nil)
        expect(game1.p2_pick).to eq(nil)
        expect(game1.win_id).to eq(nil)
      end
    end

    it "returns a game object given game id" do
      game1_id = game1.id
      expect(db.get_game(game1_id).id).to eq(game1.id)
    end

    describe '#update_game' do
      it 'updates a game with given data' do
        db.update_game(game1.id, p1_pick: "rock")
        expect(db.get_game(game1.id).p1_pick).to eq("rock")
      end

      it 'returns a game object' do
        result = db.update_game(game1.id, p2_pick: "paper")
        expect(result.p2_pick).to eq("paper")
        expect(result.win_id).to eq(nil)
        result2 = db.update_game(game1.id, win_id: user1.id)
        expect(result2.win_id).to eq(user1.id)
      end
    end

    it 'should delete a game' do
      expect(db.remove_game(game1.id)).to eq([])
    end
  end

  describe 'invites' do

    it 'should create a invite with a inviter id, invitee id, and unique id' do
      expect(invite1.inviter).to eq(user1.id)
      expect(invite1.invitee).to eq(user2.id)
      expect(invite1.id).to be_a(Fixnum)
    end

    it "returns a invite object given invite id" do
      invite1_id = invite1.id
      expect(db.get_invite(invite1_id).id).to eq(invite1.id)
    end

    it 'should delete an invite' do
      expect(db.remove_invite(invite1.id)).to eq([])
    end

    describe "list all invites" do
      it "returns an array of all invites" do
        invite1
        invite2 = db.create_invite(inviter: user2.id, invitee: user1.id)
        invites = db.list_invites
        expect(invites[0].id).to eq(invite1.id)
        expect(invites[1].id).to eq(invite2.id)
        expect(invites.size).to eq(2)
      end
    end
  end
end
