#!/usr/bin/env ruby
User.all.each do |u|
  u.meta_tweet_update
end
