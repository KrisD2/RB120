class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

bob = AngryCat.new(3, "Bob")
sal = AngryCat.new(7, "Sal")

bob.name
bob.age

sal.name
sal.age
