class Pets
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end


class Dog < Pets
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Pets
  def speak
    'meow!'
  end
end
