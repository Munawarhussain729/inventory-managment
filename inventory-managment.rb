require 'csv'
$stocks_file_name = 'stocks.csv'

def menu()
    
    puts "Enter add to add an inventory "
    puts "Enter sale to sale an inventory "
    puts "Enter exit to end the program"
    selection  = gets().chomp.downcase()
    return selection
end

def add_inventory(filename, name='', price='', quantity='')
    

    if !File.exist?(filename)
        CSV.open(filename, 'w') do |csv|
            csv << ['name', 'price', 'quantity']
        end
    end
    
    
    if name.empty?
        puts "Enter name of item "
        name = gets().chomp.downcase()
        puts "Enter price of item "
        price = gets().chomp
        puts "Enter the quantity "
        quantity = gets().chomp
       
        item_found = false
        table = CSV.read(filename, headers: true, header_converters: :symbol, converters: :all)
        table.each do |row|
            if row[:name].to_s.downcase == name.to_s.downcase
                item_found = true
                row[:price] = price
                row[:quantity] = quantity.to_i + row[:quantity].to_i
            end
        end

        if item_found
            CSV.open(filename, 'w') do |csv_file|
                csv_file << table.headers
                table.each do |row|
                    csv_file << row
                end
            end
        else

            CSV.open(filename, 'a+') do |csv|
                csv << [name, price, quantity]
            end
        end
    else

        CSV.open(filename, 'a+') do |csv|
            csv << [name, price, quantity]
        end
    end
end

def sale_inventory()
    puts "Enter name of item "
    name = gets().chomp.downcase()
    puts "Enter the quantity "
    quantity = gets().chomp.to_i
    price = ''
    table = CSV.read($stocks_file_name, headers: true, header_converters: :symbol, converters: :all)
    item_found = false
    updated_rows = table.map do |row|
        if row[:name].to_s.downcase ==  name.to_s.downcase
            item_found = true
            if (row[:quantity].to_i >= quantity)
                row[:quantity] -=  quantity
            else
                puts "Required amount not present in the stock"
            end
            if row[:quantity].to_i > 0
                price = row[:price]
                row
            else
                nil 
            end
        else
            row
        end
    end.compact

    if item_found
        CSV.open($stocks_file_name, 'w') do |csv|
            csv << table.headers
            updated_rows.each do |row|
                csv << row
            end
        end
        add_inventory(filename='sales.csv', name,price, quantity )
        puts "Item #{name} has beedn saled"
    end
    puts "Item #{name} not found"
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
            add_inventory(filename='stocks.csv')
        when "sale"
            sale_inventory()
        when "exit"
            puts "Ending the program"
        else
            puts "Wrong selection"
        end
end