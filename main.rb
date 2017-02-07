require_relative './functions.rb'
require 'pry'
require "csv"



accounts = {}

CSV.foreach("accounts.csv", {headers: true, return_headers: false}) do |row|
  # Add a key for each account to the accounts Hash.
  account = row["Account"].chomp

  if !accounts[account]
    accounts[account] = AccountInfo.new
    accounts[account].set_up_initial_values
  end

  # Set the account which is being affected by this iteration.
  current_account = accounts[account]

  # Clean up outflow and inflow.
  outflow = Outflow.new
  outflow.set_value(row["Outflow"])
  inflow = Inflow.new
  inflow.set_value(row["Inflow"])
  
  transaction_amount = inflow.to_f - outflow.to_f

  # Keep a tally for current balance of the account.
  current_account.update_tally(transaction_amount)

  category = row["Category"].chomp

  # Initialize category.
  if !current_account.already_has_category(category)
    current_account.add_category(category)
  end

  # Add transaction for that category.
  current_account.category(category).add_transaction(transaction_amount)



end

#  Display
accounts.each do |name, info|
  puts "\n"
  puts "======================================================================"
  puts "Account: #{name}... Balance: $#{info.pretty_tally}"
  puts "======================================================================"
  puts "Category                     | Total Spent | Average Transaction"
  puts "---------------------------- | ----------- | -------------------------"
  info.categories.each do |category, c_info|
    print "#{category.ljust(28)} | $#{c_info.pretty_tally} | $#{c_info.pretty_avg_transaction}\n"
  end
  puts "\n"
end

