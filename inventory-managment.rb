require 'csv'

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
    price = gets().chomp.downcase()
    puts "Enter the quantity "
    quantity = gets().chomp.downcase()
    if(File.exist?("stocks.csv"))
        CSV.open('stocks.csv', 'a+') do |csv|
            csv << [name, price, quantity]
          end
    else
        CSV.open('stocks.csv', 'a+') do |csv|
            csv << ["name", "price", "quantity"]
            csv << [name, price, quantity]
          end
    end
end

def display_items()
    puts "*********************  Welcome to inventory Managment  ********************"
   if(File.exist?("stocks.csv"))
        puts "Current items are: "
        table = CSV.parse(File.read("stocks.csv"), headers: true)
        table.each do |item_row|
            puts "Name: #{item_row["name"]}, Price: #{item_row["price"]}, Available quantity: #{item_row["quantity"]}"
        end
    else
        puts "Stock is empty"
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