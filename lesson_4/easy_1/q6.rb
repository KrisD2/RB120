class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

a = Cube.new(5)
p a.volume
