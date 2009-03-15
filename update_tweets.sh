#!/bin/sh
date
/usr/local/bin/merb -e production -r update_tweets.rb
echo "done"
date
/home/tlm/restart_merb
