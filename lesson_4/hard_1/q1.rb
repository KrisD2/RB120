class SecretFile
  # attr_reader :data

  def initialize(secret_data)
    @data = secret_data
    @logger = SecurityLogger.new
  end

  def data
    @logger.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    puts "Secret file accessed."
  end
end

a = SecretFile.new("Secret Data")
p a.data
