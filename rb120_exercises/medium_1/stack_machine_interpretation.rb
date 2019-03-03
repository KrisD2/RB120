class Minilang
  def initialize(string)
    @register = 0
    @stack = []
    @program = string.downcase.split
  end

  def push
    @stack << @register
  end

  def add
    @register += @stack.pop
  end

  def sub
    @register -= @stack.pop
  end

  def mult
    @register *= @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def pop
    @register = @stack.pop
  end

  def print
    puts @register
  end

  def eval
    @program.each do |command|
      if command.to_i.to_s == command
        @register = command.to_i
      else
        begin
          self.send command
        rescue
          raise "Invalid token: #{command.upcase}"
        end
      end
      raise "Empty stack!" if @register == nil
    end
  end
end

Minilang.new('6 PUSH').eval
