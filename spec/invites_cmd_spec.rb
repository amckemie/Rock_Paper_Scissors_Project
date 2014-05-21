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
    @cd = RPS::InvitesCmd.new
    RPS.db.clear_table("invites")
    @user1 = RPS.db.create_user(:name => "Ashley", :password => "abc12")
    @user2 = RPS.db.create_user(:name => "Katrina", :password => "123kb")
    RPS.db.create_invite(inviter: @user1.id, invitee: @user2.id)
  end

  # describe '#create_invite' do
  #   it 'should get the inviters id and give both ids to the create_invite method in the database' do
  #   end
  # end

  describe 'list_invites' do
    it "lists all pending invites for a user with inputted id" do
      result = @cd.list_invites(@user2.name)
      expect(result[:success?]).to eq(true)
      expect(result[:invites].size).to eq(1)
      result2 = @cd.list_invites(@user1.name)
      expect(result2[:success?]).to eq(true)
      expect(result2[:invites].size).to eq(0)
    end

    it "returns an error message if the user doesn't exist" do
      result = @cd.list_invites("Clay")
      expect(result[:error]).to eq("That user doesn't exist.")
    end
  end
end
