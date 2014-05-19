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
end
