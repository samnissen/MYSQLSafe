require 'mysql'

module MYSQLSafe
	class MYSQLSafe
		attr_accessor :encoding
		attr_reader :host, :database, :user, :password
		
		def host=(host_string)
			@host = esc_enc_string(host_string)
		end
		def database=(database_string)
			@database = esc_enc_string(database_string)
		end
		def user=(user_string)
			@user = esc_enc_string(user_string)
		end
		def password=(password_string)
			@password = esc_enc_string(password_string)
		end
		
		def connect_safe(raw_sql)
			sql = esc_enc_string(raw_sql)
			if @host && @database && @user && password
				begin
					@cxtn = Mysql.new(@host, @db, @user, @password)
					table_names = get_table_names
					table_match = match_name(table_names, sql)
					
					if table_match
						column_names = get_column_names(match)
						column_match = match_name(column_names, sql)
					else
						raise 'MYSQLSafe error: no valid table name could be found in your SQL statement'
					end
					
					if column_match
						ticked_sql = tick_sql(sql, table_match, column_match)
					else
						raise 'MYSQLSafe error: no valid column name(s) could be found in your SQL statement'
					end
					
					mysql_object = cxtn.query(ticked_sql)
					mysql_array = []
					mysql_object.each { |row| mysql_array.push(row) }
					
					return mysql_array
				ensure
					@cxtn.close
				end
			else
				raise 'MYSQLSafe error: Host, Database, User and Password must be set to run a query'
			end
		end
		
		private
		def tick_sql(sql, table_array, column_array)
			ticked_sql = sql.delete("`")
			table_array.each do |name|
				ticked_sql = ticked_sql.gsub(name, "`#{name}`")
			end
			column_array.each do |col|
				ticked_sql = ticked_sql.gsub(col, "`#{col}`")
			end
			
			return ticked_sql
		end
		
		def get_column_names(table_name)
			column_names_sql = "SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA`='#{@database}' AND `TABLE_NAME`='#{table_name}';"
			column_names_results_sql = query_safe(column_names_sql)
			
			column_names = []
			column_names_results_sql.each do |name|
				column_names.push(name)
			end
			
			return column_names
		end
		
		def match_name(name_array, sql)
			match = []
			
			name_array.each do |name|
				match.push(name) if sql.to_s.include?("#{name}=") || sql.to_s.match?(/#{name}\s+=/) || sql.to_s.match?(/#{name}`\s+=/)
			end
			
			if match.size > 0
				return match
			else
				return false
			end
		end
		
		def query_safe(dangerous_sql)
			@cxtn.query(Mysql.escape_string(dangerous_sql))
		end
		
		def get_table_names
			table_names_sql = "SHOW TABLES FROM `#{@database}`;"
			table_names_results_sql = query_safe(table_names_sql)
			
			table_names = []
			table_names_results_sql.each do |name|
				table_names.push(name)
			end
			
			return table_names
		end
		
		def esc_enc_string(string)
			return esc_string(enc_string(string))
		end
		
		def enc_string(string)
			return string.encode!("#{@encoding}", "#{@encoding}", :invalid => :replace)
		end
		
		def esc_string(string)
			return Mysql.escape_string(string)
		end
	end
end