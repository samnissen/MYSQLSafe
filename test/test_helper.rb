require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/MYSQLSafe.rb', __FILE__)

class TestHelpers
	attr_accessor :encoding_name, :hostname_name, :user_name, :database_name, :password_name
	
	def set_encoding(obj)
		@encoding_name = 'utf-8'
		obj.encoding = @encoding_name
		return obj
	end
	def set_user(obj)
		@user_name = 'sam'
		obj.user = @user_name
		return obj
	end
	def set_hostname(obj)
		@hostname_name = 'localhost'
		obj.host = @hostname_name
		return obj
	end
	def set_database(obj)
		@database_name = 'test_mysql'
		obj.database = @database_name
		return obj
	end
	def set_password(obj)
		@password_name = ENV['MYSQLPASSWORD'] || "password"
		obj.password = @password_name
		return obj
	end
	
	def set_variables(obj)
		obj = set_encoding(obj)
		obj = set_user(obj)
		obj = set_hostname(obj)
		obj = set_database(obj)
		obj = set_password(obj)
		
		return obj
	end
end