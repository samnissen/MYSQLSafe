require_relative '../../test_helper.rb'

describe MYSQLSafe do

  it "must be defined" do 
    MYSQLSafe::VERSION.wont_be_nil
  end

end
