module Teskal
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 7
    TINY  = 4

    STRING= [MAJOR, MINOR, TINY].join('.')
    
    def self.to_s; STRING end    
  end
end
