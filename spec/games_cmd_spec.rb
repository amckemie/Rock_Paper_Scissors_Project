require 'spec_helper.rb'

describe 'games_cmd' do
  it 'exists' do
    expect(GamesCmd).to be_a(Class)
  end

  let(:user1) {RPS.db.create_user(:name => "Ashley", :password => "1234")}
  let(:user2) {RPS.db.create_user(:name => "Katrina", :password => "123kb")}
  let(:match) {RPS.db.create_match({:p1_id => user1.id})}
  let(:match2) {RPS.db.create_match({:p1_id => user2.id})}
  let(:game1) {RPS.db.create_game({mid: match.id})}
  let(:game2) {RPS.db.create_game({mid: match.id})}
  let(:game3) {RPS.db.create_game({mid: match2.id})}
  let(:update) {RPS.db.update_match(match.id, p2_id: user2.id)}
  let(:update2) {RPS.db.update_match(match2.id, p2_id: user1.id)}

  before(:each) do
    @cd = RPS::GamesCmd.new
    RPS.db.clear_table("games")
    RPS.db.clear_table("matches")
    RPS.db.clear_table("users")
  end

  describe 'list_games' do
    it 'should return an array all of the game objects for a match given its id' do
      game1
      game2
      expect(@cd.list_games(match.id)[:games].length).to eq(2)
    end
  end

  describe "make_move" do
    it 'should update the game with the players move and check to see if there is a winner' do
      user1
      user2
      match
      match2
      update
      game1
      game3
      # Check if it returns the correct winner
      move1 = @cd.make_move(match.id,user1.id,"Rock")
      expect(RPS.db.get_game(game1.id).p1_pick).to eq("Rock")
      expect(move1[:winner]).to eq(nil)
      move2 = @cd.make_move(match.id,user2.id,"Paper")
      expect(RPS.db.get_game(game1.id).p2_pick).to eq("Paper")
      expect(move2[:winner]).to eq(2)
      expect(RPS.db.get_game(game1.id).win_id).to eq(2)
      # Check if it sets the win_id as 0 if it's a tie
      move1 = @cd.make_move(match2.id,user2.id,"Rock")
      expect(RPS.db.get_game(game3.id).p1_pick).to eq("Rock")
      expect(move1[:winner]).to eq(nil)
      move2 = @cd.make_move(match2.id,user1.id,"Rock")
      expect(RPS.db.get_game(game3.id).p2_pick).to eq("Rock")
      expect(move2[:winner]).to eq(0)
      expect(RPS.db.get_game(game3.id).win_id).to eq(0)
    end
  end
end
