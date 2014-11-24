dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.push File.expand_path(dir, __FILE__)
require File.join(dir, 'apist')
require 'pp'
require 'json'

class WikiApi < Apist
  base_url 'http://en.wikipedia.org'

  def index
    get '/wiki/Main_Page',
        welcome_message: filter('#mp-topbanner div:first').text[0...-1],
        portals: filter('a[title^="Portal:"]').each(
            link: current.attr('href').call(lambda { |href| self.class.base_url + href }),
            label: current.text
        ),
        languages: filter('#p-lang li a[title]').each(
            label: current.text,
            lang: current.attr('title'),
            link: current.attr('href').call(lambda { |href| 'http:' + href })
        ),
        sister_projects: filter('#mp-sister b a').each.text,
        featured_article: filter('#mp-tfa').html
  end

end

api = WikiApi.new
data = api.index
puts JSON.pretty_generate data