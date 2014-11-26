## SleepingOwl Apist

SleepingOwl Apist is a small library which allows you to access any site in api-like style, based on html parsing.

## Overview

This package allows you to write method like this:

```ruby
require 'apist'

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
```

use it:

```ruby
api = WikiApi.new
data = api.index
```

and get the following result (*json format used only for visualization, actual result type is `Hash`*):

```json
{
    "welcome_message": "Welcome to Wikipedia",
    "portals": [
        {
            "link": "http:\/\/en.wikipedia.org\/wiki\/Portal:Arts",
            "label": "Arts"
        },
        {
            "link": "http:\/\/en.wikipedia.org\/wiki\/Portal:Biography",
            "label": "Biography"
        },
        ...
    ],
    "languages": [
        {
            "label": "Simple English",
            "lang": "Simple English",
            "link": "http:\/\/simple.wikipedia.org\/wiki\/"
        },
        {
            "label": "العربية",
            "lang": "Arabic",
            "link": "http:\/\/ar.wikipedia.org\/wiki\/"
        },
        {
            "label": "Bahasa Indonesia",
            "lang": "Indonesian",
            "link": "http:\/\/id.wikipedia.org\/wiki\/"
        },
        ...
    ],
    "sister_projects": [
        "Commons",
        "MediaWiki",
        ...
    ],
    "featured_article": "<div style=\"float: left; margin: 0.5em 0.9em 0.4em 0em;\">...<\/div>"
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apist'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apist

## Documentation

Documentation can be found at [sleeping owl apist](http://sleeping-owl-apist.gopagoda.com).

## Examples

View [examples](http://sleeping-owl-apist.gopagoda.com/#examples).

## Support Library

You can donate in BTC: 13k36pym383rEmsBSLyWfT3TxCQMN2Lekd

## Copyright and License

Apist was written by Sleeping Owl and is released under the MIT License. See the LICENSE file for details.