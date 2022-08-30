#ruby
#!/usr/bin/env ruby
require './cli_app'
class InsertTempData < SqlQuery

end

itd = InsertTempData.new
itd.insert_temp_data
itd.where_eql('orders',{id: [3,4,5]})
