#ruby
#!/usr/bin/env ruby
require 'optparse'
require 'mysql2'
require 'json'

class SqlQuery

  def initialize(host="127.0.0.1",username='root',password='root',database="quizdb",required = true )
    begin
      @client = Mysql2::Client.new(reconnect: true,:host => host, :username => username, :database => database, :password => password) if required
    rescue Exception => e
      puts e.message
    end
    return @client
  end

  def read_json(file)
    json_data = File.read(file) if file
    puts json_data
  end

  def insert_temp_data
    if @client
      puts "hi"
      begin
        @client.query('DROP TABLE IF EXISTS orders;')
        puts 'Finished dropping table (if existed).'
        @client.query('CREATE TABLE orders (id serial PRIMARY KEY, name VARCHAR(50), quantity INTEGER);')
        puts 'Finished creating table.'
        #Insert some data into table.
        fruits = ['Apple','Banana','Banana','Orange','Mango','Grapes','Pineapple','Pomegranate',"Avocado",'Papaya']
        quentity = *(190..300)
        (1..10).each do |i|
          @client.query("INSERT INTO orders VALUES(#{i}, '#{fruits[i]}', #{quentity[i]})")
          puts "Inserted #{i} rows of data."
        end

      rescue StandardError => e
        puts e
     end
    end
  end

  def where_eql(table,options_hash = {})
   begin
    return nil unless @client
    p @client
    unless options_hash.empty?
      a=  []
      options_hash.map do |k,v|
       if v.is_a?(String)
        a << "#{k} like '%#{v}%'"
       elsif v.is_a?(Array)
        a << "#{k} in #{v}".gsub('[','(').gsub(']',')')
       else
        a << "#{k}=#{v}"
       end
      end
      query = a.join(' and ')
      _query = "SELECT * FROM #{table} where #{query};"
      p _query
      data = @client.query(_query)
    end
   rescue Exception => e
    puts e
   end
   rows = data.map{|row| row}
   puts _query
   puts rows
  end

  def where_between(table,attr,from,to)
   begin
    return nil unless @client
    _query = "SELECT * FROM #{table} where #{attr} BETWEEN #{from} AND #{to};"
    data = @client.query(_query)
   rescue Exception => e
    puts e
   end
   rows = data.map{|row| row}
   puts _query
   puts rows
  end

  def where_gt_eql(table,attr,value)
   begin
    return nil unless @client
    _query = "SELECT * FROM #{table} where #{attr} >= #{value};"
    data = @client.query(_query)
   rescue Exception => e
    puts e
   end
   rows = data.map{|row| row}
   puts _query
   puts rows
  end

  def where_ls_eql(table,attr,value)
   begin
    return nil unless @client
    _query = "SELECT * FROM #{table} where #{attr} <= #{value};"
    data = @client.query(_query)
   rescue Exception => e
    puts e
   end
   rows = data.map{|row| row}
   puts _query
   puts rows
  end
end
