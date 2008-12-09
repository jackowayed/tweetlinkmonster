#!/bin/sh
date
ruby bin/merb -e production -r update_tweets.rb
echo "done"