#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
x = gets
if x.length>140
  puts "That was #{x.length} characters long"
else
  puts Twitter::Base.new('tweetlinkmonstr', 'getmetweetlinks!').update(x)
end
