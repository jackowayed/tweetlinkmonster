#!/usr/bin/env ruby
Tweet.all.each do |t|
  t.delete_if_expired
end
