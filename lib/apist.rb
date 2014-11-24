require 'apist/request'
require 'apist/method'
require 'apist/selector'

class Apist

  VERSION = '1.0.0'

  attr_reader :requester
  attr_reader :current_method
  attr_accessor :suppress_exceptions

  def initialize
    @requester = Apist::Request.new self.class.base_url
    @suppress_exceptions = true
  end

  # Allows setting a base url to be used for each request.
  #
  #   class Foo < Apist
  #     base_url 'http://en.wikipedia.org'
  #   end
  def self.base_url(url=nil)
    return @base_url unless url
    @base_url = url
  end

  # Create new filter in blueprint
  #
  #   class Foo < Apist
  #     base_url 'http://en.wikipedia.org'
  #     def index
  #       get '/wiki/Main_Page',
  #           welcome_message: filter('#mp-topbanner div:first').text,
  #     end
  #   end
  # @return [Apist::Filter]
  def self.filter(css_selector)
    Apist::Selector.new css_selector
  end

  # Create new filter in blueprint
  #
  #   class Foo < Apist
  #     base_url 'http://en.wikipedia.org'
  #     def index
  #       get '/wiki/Main_Page',
  #           welcome_message: filter('#mp-topbanner div:first').text,
  #     end
  #   end
  # @return [Apist::Filter]
  def filter(css_selector)
    self.class.filter css_selector
  end

  # Create new filter object with current node as filter result
  #
  #   class Foo < Apist
  #     base_url 'http://en.wikipedia.org'
  #     def index
  #       get '/wiki/Main_Page',
  #           portals: filter('a[title^="Portal:"]').each(
  #             link: current.attr('href'),
  #             label: current.text
  #           ),
  #     end
  #   end
  # @return [Apist::Filter]
  def self.current
    self.filter '*'
  end

  # Create new filter object with current node as filter result
  #
  #   class Foo < Apist
  #     base_url 'http://en.wikipedia.org'
  #     def index
  #       get '/wiki/Main_Page',
  #           portals: filter('a[title^="Portal:"]').each(
  #             link: current.attr('href'),
  #             label: current.text
  #           ),
  #     end
  #   end
  # @return [Apist::Filter]
  def current
    self.class.current
  end

  def parse(content, blueprint)
    @current_method = Apist::Method.new self, nil, blueprint
    @current_method.set_content content
    result = @current_method.parse_blueprint blueprint
    @current_method = nil
    result
  end

  # Perform GET http-request
  def get(url, blueprint = nil, options = {})
    request 'get', url, blueprint, options
  end

  # Perform HEAD http-request
  def head(url, blueprint = nil, options = {})
    request 'head', url, blueprint, options
  end

  # Perform POST http-request
  def post(url, blueprint = nil, options = {})
    request 'post', url, blueprint, options
  end

  # Perform PUT http-request
  def put(url, blueprint = nil, options = {})
    request 'put', url, blueprint, options
  end

  # Perform PATCH http-request
  def patch(url, blueprint = nil, options = {})
    request 'patch', url, blueprint, options
  end

  # Perform DELETE http-request
  def delete(url, blueprint = nil, options = {})
    request 'delete', url, blueprint, options
  end

  private

  # Perform http-request with options and parse result by blueprint
  def request(http_method, url, blueprint = nil, options = [])
    @current_method = Apist::Method.new self, url, blueprint
    @current_method.method = http_method
    result = @current_method.get options
    @current_method = nil
    result
  end

end