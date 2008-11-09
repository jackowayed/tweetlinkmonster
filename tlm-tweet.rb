#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
puts Twitter::Base.new('tweetlinkmonstr', 'getmetweetlinks!').update(gets)
