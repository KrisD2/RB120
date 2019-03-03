class Person
  def name=(name)
    @first, @last = name.split
  end
  def name
    [@first, @last].join(' ')
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
