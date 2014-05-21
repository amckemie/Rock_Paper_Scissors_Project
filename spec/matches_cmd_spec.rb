require 'spec_helper.rb'

describe 'matches_cmd' do
  it 'exists' do
    expect(MatchesCmd).to be_a(Class)
  end

  let(:user1) {RPS.db.create_user(:name => "Ashley", :password => "1234")}
  let(:user2) {RPS.db.create_user(:name => "Katrina", :password => "123kb")}
  let(:match) {RPS.db.create_match({:p1_id => user1.id})}
  let(:match2) {RPS.db.create_match({:p1_id => user2.id})}
  let(:game1) {RPS.db.create_game({mid: match.id})}
  let(:game2) {RPS.db.create_game({mid: match2.id})}
  let(:update) {RPS.db.update_match(match.id, p2_id: user2.id)}

  before(:each) do
    @cd = RPS::MatchesCmd.new
    RPS.db.clear_table("games")
    RPS.db.clear_table("matches")
    RPS.db.clear_table("users")
  end


  describe "get_active_matches" do
    it "returns an array of active matches a user has" do
      match
      match2
      update
      expect(@cd.active_matches(user1.id)[:matches].length).to eq(1)
      expect(@cd.active_matches(user2.id)[:matches].length).to eq(2)
    end
  end
end
