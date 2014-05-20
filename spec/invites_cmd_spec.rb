require 'spec_helper.rb'

describe 'invites_cmd' do
  it 'exists' do
    expect(InvitesCmd).to be_a(Class)
  end

  let(:user1) {RPS.db.create_user(:name => "Ashley", :password => "1234")}

  before(:each) do
    @cd = RPS::InvitesCmd.new
    RPS.db.clear_table("games")
    RPS.db.clear_table("matches")
    RPS.db.clear_table("users")
  end
end
