class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
# tv.manufacturer # => NoMethodError
# tv.model # => Calls model instance method

# Television.manufacturer # => calls manufacturer class method
# Television.model # => NoMethodError
