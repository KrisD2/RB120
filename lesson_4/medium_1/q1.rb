class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is correct - he is using the getter method for balance.
# balance on line 9 does not refer to the instance variable,
# it refers to the method balance.
