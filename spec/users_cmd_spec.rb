require 'spec_helper.rb'

describe 'users_cmd' do
  it 'exists' do
    expect(UsersCmd).to be_a(Class)
  end

  before(:each) do
    @cd = RPS::UsersCmd.new
  end

  describe "sign up" do
    it "should check for unique name and return error if not unique" do
      result = @cd.sign_up("Ashley", "asdf")
      expect(result[:error]).to eq("That username is already taken.")
    end

    xit "should allow a user to sign up if name is unique" do
      result = @cd.sign_up("Katrina", "abc123")
      expect(result[:success?]).to eq(true)
    end

    xit "should return an error if the password doesn't include at least one character" do
      result = @cd.sign_up("Alex", "1234")
      expect(result[:error]).to eq("Your password does not include at least one character.")
    end
  end
end
