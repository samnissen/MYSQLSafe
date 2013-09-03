require 'mysql'

module MYSQLSafe
	class Base
		attr_accessor :host, :database, :user, :encoding, :password

		def connect_safe(raw_sql)
			@mysql_array = []
			@encoding ||= 'utf-8'
			options = {}
			self.instance_variables.map{|name| options = options.merge({ name.to_s.delete("@") => self.instance_variable_get(name) }) }
			options.each do |k,v|
				options[k] = esc_enc_string(v)
			end
			
			
			sql = esc_enc_string(raw_sql)
			if options["host"] && options["database"] && options["user"] && options["password"]
				begin
					@cxtn = Mysql.new(options["host"], options["user"], options["password"], options["database"])
					table_names = get_table_names
					table_match = match_name(table_names, sql)
					
					if table_match
						column_names = get_column_names(table_match)
						column_match = match_name(column_names, sql)
						column_match = [] if !(sql.to_s.downcase.include?('where'))
					else
						raise 'MYSQLSafe error: no valid table name could be found in your SQL statement'
					end
					
					if column_match
						ticked_sql = tick_sql(sql, table_match, column_match)
					else
						raise 'MYSQLSafe error: no valid column name(s) could be found in your SQL statement'
					end
					
					mysql_object = @cxtn.query(ticked_sql)
					mysql_object.each { |row| @mysql_array.push(row) }
				rescue Mysql::Error => msqle
					puts "Error! #{msqle}, #{@mysql_array}"
					@mysql_array.push(["MYSQL Error: #{msqle}"])
				ensure
					@cxtn.close if @cxtn
				end
			else
				raise "MYSQLSafe error: Host, Database, User and Password must be set to run a query. You included #{options}"
			end
			return @mysql_array
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

		def get_column_names(table_names)
			column_names = []
			table_names.each do |table_name|
				column_names_sql = "SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA`='#{@database}' AND `TABLE_NAME`='#{table_name}';"
				column_names_results_sql = @cxtn.query(column_names_sql)
			
				column_names_results_sql.each do |name|
					column_names.push(name)
				end
			end
			
			return column_names
		end

		def match_name(name_array, sql)
			match = []
			
			name_array.each do |name|
				match.push(name) if sql.to_s.include?("#{name}")
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
				table_names.push(name[0])
			end
			
			return table_names
		end

		def esc_enc_string(string)
			return esc_string(enc_string(string.to_s))
		end

		def enc_string(string)
			return string.encode("#{@encoding}", "#{@encoding}", :invalid => :replace)
		end

		def esc_string(string)
			return Mysql.escape_string(string)
		end

	end
end