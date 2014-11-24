require 'apist'

class TestApi < Apist
  base_url 'http://en.wikipedia.org'
  # base_url 'http://habrahabr.my'

  def get404
    get '/unknown-page'
  end

  def menu_first
    get '/wiki/Main_Page', filter('#mp-topbanner div:first').text[0...-1]
  end

  def static_blueprint(blueprint)
    get '/wiki/Main_Page', blueprint
  end

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

  def query
    post '/test.php', nil,
        query: {
            first: 1
        },
        body: {
            first: 1,
            second: 2
        }
  end

end