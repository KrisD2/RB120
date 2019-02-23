class Person
  attr_accessor :first_name, :last_name
  def initialize(first_name, last_name='')
    @first_name = first_name
    @last_name = last_name
  end
  def name=(name)
    if name.split.size >= 2
      @first_name = name.split[0]
      @last_name = name.split[-1]
    else
      @first_name = name
    end
  end
  def name
    (@first_name + ' ' + @last_name).strip
  end
end

bob = Person.new('Robert')
p bob.name
p bob.first_name
p bob.last_name
bob.last_name = 'Smith'
p bob.name

bob.name = "John Adams"
p bob.first_name
p bob.last_name
