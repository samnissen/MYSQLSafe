# MYSQLSafe

MYSQLSafe abstracts some common MYSQL connection and query actions
Specifically it 
+ Ensures connection closure
+ Returns an Array (instead of MYSQL object)
+ Rescues and prints errors
+ Sanitizes input
+ Encodes queries
+ Encloses table and column names in backticks (like `this`.`that`)

## Installation

Add this line to your application's Gemfile:

    gem 'MYSQLSafe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install MYSQLSafe

## Usage

MYSQLSafe allows you to optionally set
+ host
+ database
+ user
+ password
+ encoding


		safe_sql_connect = MYSQLSafe::Base.new()
		safe_sql_connect.user = 'username'
		safe_sql_connect.host = 'myhost'
		safe_sql_connect.password = ENV['MYSQLPASSWORD']
		safe_sql_connect.database = 'databasename'
		safe_sql_connect.encoding = 'iso-8859-1' # otherwise defaults to 'utf-8'

MYSQLSafe has one other public function which allows you to pass a MYSQL query

		safe_sql_connect.connect_safe("SELECT * FROM tablename LIMIT 1;")

And it returns an Array
		
		#=> [["1", "Sam", "Areas Of My Expertise"], ["2", "Caz", "1Q84"], ["3", "Kyle", "How I Became A Famous Novelist"]]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contact

Shoot me [an email](mailto:scnissen@gmail.com) with any questions or ideas.