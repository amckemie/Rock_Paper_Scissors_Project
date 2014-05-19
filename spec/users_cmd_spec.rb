require 'spec_helper.rb'

describe 'users_cmd' do
  it 'exists' do
    expect(UsersCmd).to be_a(Class)
  end

  before(:each) do
    @cd = RPS::UsersCmd.new
    RPS.db.clear_table("users")
  end

  describe "sign up" do
    it "should allow a user to sign up if name is unique" do
      result = @cd.sign_up("Katrina", "abc123")
      expect(result[:success?]).to eq(true)
    end

    it "should check for unique name and return error if not unique" do
      @cd.sign_up("Ashley", "adf")
      result = @cd.sign_up("Ashley", "asdf")
      expect(result[:error]).to eq("That username is already taken.")
    end

    it "should return an error if the password doesn't include at least one character" do
      result = @cd.sign_up("Alex", "1234")
      expect(result[:error]).to eq("Your password does not include at least one character.")
    end
  end

  describe 'sign_in' do
    it 'should return an error if the username does not exist' do
      @cd.sign_up("Katrina", "abc123")
      result = @cd.sign_in("Alex", "sdfh")
      expect(result[:error]).to eq("That username does not exist.")
    end

    it 'should return an error if the password does not match' do
      @cd.sign_up("Katrina", "abc123")
      result = @cd.sign_in("Katrina", "sdfh")
      expect(result[:error]).to eq("That is the wrong password.")
    end

    it 'should return true if the username and password are correct' do
      @cd.sign_up("Katrina", "abc123")
      result = @cd.sign_in("Katrina", "abc123")
      expect(result[:success?]).to eq(true)
    end
  end
end
