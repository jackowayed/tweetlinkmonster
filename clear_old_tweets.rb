#!/usr/bin/env ruby
Tweet.all(:created_at.lt => Time.now - 3.days).destroy!
