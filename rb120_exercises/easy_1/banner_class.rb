class Banner
  def initialize(message)
    @message = message
    @banner_width = message.size + 2
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private
  attr_reader :banner_width, :message

  def horizontal_rule
    "+" + "-" * banner_width + "+"
  end

  def empty_line
    "|" + " " * banner_width + "|"
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner
