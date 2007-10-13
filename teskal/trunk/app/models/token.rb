# Teskal


class Token < ActiveRecord::Base
  belongs_to :user
  
  @@validity_time = 1.day
  
  def before_create
    self.value = Token.generate_token_value
  end

  # Return true if token has expired  
  def expired?
    return Time.now > self.created_on + @@validity_time
  end
  
  # Delete all expired tokens
  def self.destroy_expired
    Token.delete_all ["action <> 'feeds' AND created_on < ?", Time.now - @@validity_time]
  end
  
private
  def self.generate_token_value
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    token_value = ''
    40.times { |i| token_value << chars[rand(chars.size-1)] }
    token_value
  end
end
