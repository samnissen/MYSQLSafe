require_relative '../../test_helper.rb'

describe MYSQLSafe::Base do
	
	obj { MYSQLSafe::Base }
	#@host && @database && @user && @password && @enconding
	
  it "must allow enconding to be set and read" do
		enconding_name = 'utf-8'
		obj.enconding = enconding_name
		obj.enconding.must_equal enconding_name
	end
  it "must allow username to be set and read" do
		username = 'sam'
		obj.user = username
		obj.user.must_equal username
	end
  it "must allow host to be set and read" do
		hostname = 'localhost'
		obj.host = hostname
		obj.host.must_equal hostname
	end
  it "must allow database to be set and read" do
		database_name = 'test'
		obj.database = database_name
		obj.database.must_equal database_name
	end
  it "must allow password to be set, but not read" do
		password_key = 'password'
		obj.password = password_key
		obj.password.must_be_kind_of Exception
	end
	
end
