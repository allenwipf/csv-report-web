require "csv"
require 'pry'





class AccountInfo
  def set_up_initial_values
    @tally = 0.00
    @categories = {}
  end

  def build_report(object, account) 

    CSV.foreach("accounts.csv", {headers: true, return_headers: false}) do |row|
      if row["Account"].chomp == account
        outflow = Outflow.new
        outflow.set_value(row["Outflow"])
        inflow = Inflow.new
        inflow.set_value(row["Inflow"])
        
        transaction_amount = inflow.to_f - outflow.to_f
        object.update_tally(transaction_amount)
        category = row["Category"].chomp

        if !object.already_has_category(category)
            object.add_category(category)
        end

        object.category(category).add_transaction(transaction_amount)
        end
    end
  end




  def tally
  	return @tally 				
  end

  def update_tally(amount)
    @tally += amount
  end

  def add_category(category_name)
    @categories[category_name] = Category.new
    @categories[category_name].set_up_initial_values
  end


  def test_for_category(cats)
	  	cats.each do |each|
			if (@categories[each] == nil)
			 	add_category(each)
		    end
	   end
  end

  def pretty_tally
    return @tally.round(2)
  end

  def already_has_category(category_name)
    return (@categories[category_name] != nil)
  end

  def category(category_name)
    return @categories[category_name]
  end

  def categories
    return @categories
  end
end

class Category
  def set_up_initial_values
    @tally = 0.00
    @num_transactions = 0
    @average_transaction_cost = 0.00
  end

  def tally
  	return @tally
  end

  def avr_trans
  	return @average_transaction_cost
  end

  def add_transaction(amount)
    @tally += amount
    @num_transactions += 1
    @average_transaction_cost = @tally / @num_transactions
  end

  def pretty_tally
    @tally.round(2).to_s.ljust(10)
  end

  def pretty_avg_transaction
    @average_transaction_cost.round(2).to_s.ljust(20)
  end
end

class Outflow
  def set_value(number_string_from_csv)
    @value = number_string_from_csv.gsub(/[,\$]/, "").to_f.round(2)
  end

  def to_f
    return @value
  end
end

class Inflow
  def set_value(number_string_from_csv)
    @value = number_string_from_csv.gsub(/[,\$]/, "").to_f.round(2)
  end

  def to_f
    return @value
  end
end