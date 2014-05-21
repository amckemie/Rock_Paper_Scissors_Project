require 'spec_helper.rb'

describe 'games_cmd' do
  it 'exists' do
    expect(GamesCmd).to be_a(Class)
  end


  let(:user1) {RPS.db.create_user(:name => "Ashley", :password => "1234")}
  let(:match) {RPS.db.create_match({:p1_id => user1.id})}
  let(:game1) {RPS.db.create_game({mid: match.id})}
  let(:game2) {RPS.db.create_game({mid: match.id})}

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
end
