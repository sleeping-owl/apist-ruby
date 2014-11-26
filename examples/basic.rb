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

  def current_events
    get '/wiki/Portal:Current_events',
        filter('#mw-content-text > table:last td:first table.vevent').each(
            date: filter('.bday').text,
            events: filter('dl').each.text
        )
  end


end

api = WikiApi.new
data = api.current_events
puts JSON.pretty_generate data