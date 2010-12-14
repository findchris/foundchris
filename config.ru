require 'toto'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
# good config guide: http://fadeyev.net/2010/05/10/getting-started-with-toto/
toto = Toto::Server.new do
  
  # Add your settings here
  # set [:setting], [value]
  
  set :author,    'Chris'                                   # blog author
  set :title,     'FoundChris.com'                          # site title
  set :url,       'http://foundchris.com'                   # site root URL
  set :prefix,    ''                                        # common path prefix for all pages
  set :root,      "index"                                   # page to load on /
  set :date,      lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }  # date format for articles
  set :markdown,  :smart                                    # use markdown + smart-mode
  set :disqus,    'foundchris'                              # disqus id, or false
  set :summary,   :max => 150, :delim => /~\n/              # length of article summary and delimiter
  set :ext,       'txt'                                     # file extension for articles
  set :cache,      28800                                    # cache duration, in seconds (8 hours)

  set :error     do |code|                                    # The HTML for your error page
    "<font style='font-size:300%'>oh no, something unexpected happened, and I'm embarrassed. (#{code})</font>"
  end

end

# Redirect www to non-www
gem 'rack-rewrite'
require 'rack-rewrite'
if ENV['RACK_ENV'] == 'production'
  use Rack::Rewrite do
    r301 %r{.*}, 'http://foundchris.com$&', :if => Proc.new {|rack_env| rack_env['SERVER_NAME'] != 'foundchris.com'}
    r301 %r{/feed(.*)}, 'http://feeds.feedburner.com/foundchris_com'
  end
end

run toto


