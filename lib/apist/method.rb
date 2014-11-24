require 'nokogiri'
require 'apist/selector'
require 'apist/error/http'

class Apist
  class Method

    attr_reader :resource
    attr_reader :url
    attr_reader :blueprint
    attr_accessor :method
    attr_reader :content
    attr_reader :crawler

    # @param [Apist] resource
    # @param [String] url
    def initialize(resource, url, blueprint)
      @resource = resource
      @url = url
      @blueprint = blueprint
    end

    def get(options)
      begin
        make_request options
        parse_blueprint @blueprint
      rescue Apist::Error::Http => e
        error_response e.code, e.reason, e.url
      rescue SocketError => e
        error_response 0, e.message, @url
      end
    end

    def make_request(options = {})
      @content = @resource.requester.class.send method, @url, options
      if @content.code != 200
        code = @content.code
        message = @content.response.message
        url = @content.request.last_uri.to_s
        raise Apist::Error::Http.new(code, message, url)
      end
      set_content @content.body
    end

    def set_content(content)
      @crawler = Nokogiri::HTML content
    end

    def parse_blueprint(blueprint, node = nil)
      return @content if blueprint.nil?
      return parse_blueprint_value(blueprint, node) unless blueprint.is_a? Hash
      blueprint.each do |key, value|
        if value.is_a? Hash
          blueprint[key] = parse_blueprint value.clone, node
        else
          blueprint[key] = parse_blueprint_value value, node
        end
      end
      blueprint
    end

    private

    def parse_blueprint_value(value, node)
      return value.get_value(self, node) if value.is_a? Apist::Selector
      return value
    end

    def error_response(code, reason, url)
      {
          url: url,
          error: {
              status: code,
              reason: reason
          }
      }
    end

  end
end