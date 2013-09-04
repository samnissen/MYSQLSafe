require_relative '../../test_helper.rb'

describe MYSQLSafe::Base do

	help = TestHelpers.new()
	
	before do
		@obj = MYSQLSafe::Base.new
	end
	
  it "should allow enconding to be set and read" do
		encoding_name = 'utf-8'
		@obj.encoding = encoding_name
		@obj.encoding.must_equal encoding_name
	end
  it "should allow username to be set and read" do
		username = 'sam'
		@obj.user = username
		@obj.user.must_equal username
	end
  it "should allow host to be set and read" do
		hostname = 'localhost'
		@obj.host = hostname
		@obj.host.must_equal hostname
	end
  it "should allow database to be set and read" do
		database_name = 'test'
		@obj.database = database_name
		@obj.database.must_equal database_name
	end
	
  it "must allow password to be set and read" do
		password_key = ENV['MYSQLPASSWORD'] || "password"
		@obj.password = password_key
		@obj.password.must_equal password_key
	end
	
  it "should allow connections to be made, and return an array" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT * FROM performance_test LIMIT 1")
		success.must_be_instance_of Array
	end
	
  it "should allow table=value syntax" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT * FROM performance_test WHERE test_int=1 LIMIT 1")
		success.must_be_instance_of Array
	end
end