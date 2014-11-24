dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.push File.expand_path(dir, __FILE__)
require File.join(dir, 'apist')
require 'pp'
require 'json'

class HabrApi < Apist
  base_url 'http://habrahabr.ru'

  def get404
    get '/unknown-page',
        menu: filter('#TMpanel .menu a').each.text
  end
end

api = HabrApi.new
data = api.get404
puts JSON.pretty_generate data