#!/bin/sh
date
/opt/ruby-enterprise-1.8.6-20090201/bin/ruby /usr/local/bin/merb -e production -r update_tweets.rb
echo "done"
date