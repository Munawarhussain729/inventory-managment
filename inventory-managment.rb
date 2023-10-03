require 'csv'
$stocks_file_name = 'stocks.csv'

def menu()
    
    puts "Enter add to add an inventory "
    puts "Enter remove to remove an inventory "
    puts "Enter exit to end the program"
    selection  = gets().chomp.downcase()
    return selection
end

def add_inventory()
    puts "Enter name of item "
    name = gets().chomp.downcase()
    puts "Enter price of item "
    price = gets().chomp
    puts "Enter the quantity "
    quantity = gets().chomp.to_i

    table = CSV.read($stocks_file_name, headers: true, header_converters: :symbol, converters: :all)
    item_found = false
    table.each do |row|
        if row[:name].to_s.downcase == name.to_s.downcase
            item_found = true
            row[:price] = price
            row[:quantity] = quantity.to_i + row[:quantity].to_i
        end
    end

    if item_found
    CSV.open($stocks_file_name, 'w') do |csv_file|
        csv_file << table.headers
        table.each do |row|
            csv_file << row
        end
    end
    else

        CSV.open('stocks.csv', 'a+') do |csv|
            csv << [name, price, quantity]
        end
    end
 
end

def display_items()
    puts "*********************  Welcome to inventory Managment  ********************"
   if(File.exist?("stocks.csv"))
        puts "Current items are: "
        table = CSV.read($stocks_file_name, headers: true, header_converters: :symbol, converters: :all)
        table.each do |item_row|
            puts "Name: #{item_row[:name]}, Price: #{item_row[:price]}, Available quantity: #{item_row[:quantity]}"
        end
    else
        puts "Stock is empty"
        CSV.open('stocks.csv', 'a+') do |csv|
            csv << ["name", "price", "quantity"]
        end
    end
    puts
    puts
end

selection = ""
while(selection != "exit")
    display_items()
    selection = menu()
    case selection
        when "add"
            add_inventory()
        when "exit"
            puts "Ending the program"
        else
            puts "Wrong selection"
        end
end