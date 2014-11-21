require 'apist/request'

class Apist
  VERSION = '0.0.1'

  attr_accessor :requester

  def initialize(base_url)
    @requester = Apist::Request.new base_url
  end

  def test
    puts self.class
  end

end
