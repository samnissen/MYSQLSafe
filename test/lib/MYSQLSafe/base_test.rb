require_relative '../../test_helper.rb'

describe MYSQLSafe::Base do

	help = TestHelpers.new()
	
	before do
		@obj = MYSQLSafe::Base.new
	end
	
  it "should allow encoding to be set and read" do
		encoding_name = 'utf-8'
		@obj.encoding = encoding_name
		@obj.encoding.must_equal encoding_name
	end
  it "should allow username to be set and read" do
		username = ENV['MYSQLUSERNAME']
		@obj.user = username
		@obj.user.must_equal username
	end
  it "should allow host to be set and read" do
		hostname = 'localhost'
		@obj.host = hostname
		@obj.host.must_equal hostname
	end
  it "should allow database to be set and read" do
		database_name = 'gem_test_mysqlsafe'
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
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
	
  it "should allow table=value syntax" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT * FROM performance_test WHERE test_int=1 LIMIT 1")
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
	
  it "should allow mysql ticking" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT * FROM `performance_test` WHERE `test_int` = 1 LIMIT 1")
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
	
  it "should allow column selection" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT `test_int`, `test_varchar` FROM `performance_test` WHERE `test_int` = 1 LIMIT 1")
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
	
  it "should allow database and test specification" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT `test_int`, `test_varchar` FROM `gem_test_mysqlsafe`.`performance_test` WHERE `test_int` = 1 LIMIT 1")
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
	
  it "should allow order by" do
		@obj = help.set_variables(@obj)
		success = @obj.connect_safe("SELECT `test_int`, `test_varchar` FROM `gem_test_mysqlsafe`.`performance_test` WHERE `test_int` = 1 ORDER BY `test_int` LIMIT 1")
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
	
  it "should allow insert into syntax" do
		@obj = help.set_variables(@obj)
		
		max_id = @obj.connect_safe("SELECT MAX( test_int ) FROM  `performance_test`")
		next_id = max_id[0][0].to_i + 1
		
		success = @obj.connect_safe("INSERT INTO `performance_test` SELECT * FROM `performance_test` WHERE `test_int` = #{next_id} LIMIT 1")
		success.to_s.wont_include "MYSQL Error"
		success.must_be_instance_of Array
	end
end