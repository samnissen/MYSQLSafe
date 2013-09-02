require_relative '../../test_helper.rb'

describe MYSQLSafe::Base do
	
	obj { MYSQLSafe::Base }
	
  it "should allow enconding to be set and read" do
		enconding_name = 'utf-8'
		obj.enconding = enconding_name
		obj.enconding.should_equal enconding_name
	end
  it "should allow username to be set and read" do
		username = 'sam'
		obj.user = username
		obj.user.should_equal username
	end
  it "should allow host to be set and read" do
		hostname = 'localhost'
		obj.host = hostname
		obj.host.should_equal hostname
	end
  it "should allow database to be set and read" do
		database_name = 'test'
		obj.database = database_name
		obj.database.should_equal database_name
	end
	
  it "must allow password to be set, but not read" do
		password_key = $MYSQLPASSWORD
		obj.password = password_key
		obj.password.must_be_kind_of Exception
	end
	
  it "should allow connections to be made" do
		obj.connect_safe("SELECT * FROM test LIMIT 1")
		obj.database.should_be_type_of Array
	end
end
