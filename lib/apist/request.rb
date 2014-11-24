require 'httparty'

class Apist
  class Request
    include HTTParty

    def initialize(base_uri)
      self.class.base_uri base_uri
    end

  end
end