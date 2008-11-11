#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
x = Twitter::Base.new('tweetlinkmonstr', 'getmetweetlinks!')
x.update("Want billionth. Spamming for tweetlinkmonster.com! Check out http://tinyurl.com/4qbuyb to get an atom feed of the links your friends tweet") while true
