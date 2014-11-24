require 'apist/request'
require 'apist/method'
require 'apist/selector'

class Apist

  VERSION = '0.0.1'

  @base_url = nil

  attr_reader :requester
  attr_reader :current_method
  attr_accessor :suppress_exceptions

  def initialize
    @requester = Apist::Request.new self.class.base_url
    @suppress_exceptions = true
  end

  def self.base_url(url=nil)
    return @base_url unless url
    @base_url = url
  end

  # @return [Apist::Filter]
  def self.filter(css_selector)
    Apist::Selector.new css_selector
  end

  # @return [Apist::Filter]
  def filter(css_selector)
    self.class.filter css_selector
  end

  # @return [Apist::Filter]
  def self.current
    self.filter '*'
  end

  # @return [Apist::Filter]
  def current
    self.class.current
  end

  def request(http_method, url, blueprint = nil, options = [])
    @current_method = Apist::Method.new self, url, blueprint
    @current_method.method = http_method
    result = @current_method.get options
    @current_method = nil
    result
  end

  def parse(content, blueprint)
    @current_method = Apist::Method.new self, nil, blueprint
    @current_method.set_content content
    result = @current_method.parse_blueprint blueprint
    @current_method = nil
    result
  end

  def get(url, blueprint = nil, options = {})
    request 'get', url, blueprint, options
  end

  def head(url, blueprint = nil, options = {})
    request 'head', url, blueprint, options
  end

  def post(url, blueprint = nil, options = {})
    request 'post', url, blueprint, options
  end

  def put(url, blueprint = nil, options = {})
    request 'put', url, blueprint, options
  end

  def patch(url, blueprint = nil, options = {})
    request 'patch', url, blueprint, options
  end

  def delete(url, blueprint = nil, options = {})
    request 'delete', url, blueprint, options
  end

end