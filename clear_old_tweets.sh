#!/bin/sh
date
time /usr/local/bin/merb -e production -r clear_old_tweets.rb
echo "done"