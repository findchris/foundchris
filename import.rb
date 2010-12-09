#!/usr/bin/ruby
require 'rubygems'
require 'fastercsv'
require 'xmlrpc/client'

USERID = 'chris'
PASSWORD = 

def getPages(blog)
  blog.call("wp.getPages", 0, USERID, PASSWORD, 1000)
end

def getPosts(blog)
  blog.call("metaWeblog.getRecentPosts", 0, USERID, PASSWORD, 1000)
end

def slugify(title)
  title.downcase.gsub(/[ \._]/, '-')
end

blog = XMLRPC::Client.new3(:host => "www.foundchris.com", :path => "/xmlrpc.php")
begin
  puts "Logging into blog and getting the list of posts..."
  posts = getPosts(blog)
  puts "  response received, found #{posts.size} posts"
  posts.each do |post|
    permaLink = post['permaLink']
    dateAndName = permaLink.gsub(/http:\/\/www.foundchris\.com\//, '').split('/')
    postFilename = 'articles/' + dateAndName.join('-') + '.txt'
    postDate = dateAndName[0] + '/' + dateAndName[1] + '/' + dateAndName[2]
    escapedTitle = post['title'].gsub(/"/, '\\"')
    File.open(postFilename, "w") do |postFile|
      postFile.puts("title: \"#{escapedTitle}\"")
      postFile.puts("author: Chris")
      postFile.puts("date: #{postDate}")
      postFile.puts("slug: #{dateAndName[3]}")
      puts "#{post['title']} - #{postDate}"
      postFile.puts("categories: #{post['categories']}")
      postFile.puts("keywords: #{post['mt_keywords']}")
      postFile.puts
      postFile.puts post['description']
    end
  end
rescue XMLRPC::FaultException => e
   puts "ERROR: Code: #{e.faultCode}"
   puts "ERROR: Msg.: #{e.faultString}"
end
