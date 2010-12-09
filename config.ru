
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
toto = Toto::Server.new do
  
  # Add your settings here
  # set [:setting], [value]
  
  set :author,    Chris Johnson                             # blog author
  set :title,     Dir.pwd.split('/').last                   # site title
  set :url,       'http://foundchris.com'                   # site root URL
  set :prefix,    ''                                        # common path prefix for all pages
  set :root,      "index"                                   # page to load on /
  set :date,      lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }  # date format for articles
  set :markdown,  :smart                                    # use markdown + smart-mode
  set :disqus,    false                                     # disqus id, or false
  set :summary,   :max => 150, :delim => /~\n/                # length of article summary and delimiter
  set :ext,       'txt'                                     # file extension for articles
  set :cache,      28800                                    # cache duration, in seconds (8 hours)

  set :error     do |code|                                    # The HTML for your error page
    "<font style='font-size:300%'>oh no, something unexpected happened, and I'm embarrassed. (#{code})</font>"
  end

end

run toto


