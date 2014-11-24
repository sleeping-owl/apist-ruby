dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.push File.expand_path(dir, __FILE__)
require File.join(dir, 'apist')
require 'pp'
require 'json'

class AdminApi < Apist
  base_url 'http://sleeping-owl-admin-demo.gopagoda.com'
  # base_url 'http://sleeping-owl-admin.my'

  def initialize
    @username = 'admin'
    @password = 'SleepingOwl'
    super
  end

  def get_login_token
    get '/admin/login', filter('input[name="_token"]').attr('value')
  end

  def login
    post '/admin/login', filter('.page-header').html,
         body: {
             _token: get_login_token,
             username: @username,
             password: @password
         }
  end

  def contacts
    login
    get '/admin/contacts',
        entries: filter('.table tbody tr').each(
            photo: filter('td:first-child img').attr('src'),
            name: filter('td').eq(1).text,
            birthday: filter('.column-date').attr('data-order'),
            country: filter('td').eq(3).text,
            companies: filter('td:nth-child(5) li').each.text
        )
  end

end

api = AdminApi.new
data = api.contacts
puts JSON.pretty_generate data