# Tweet Link Monster

TLM gives you an atom feed of all of the links your friends tweet.

This used to live on tweetlinkmonster.com, but I got tired of it, and despite having 91 users, no one I asked really seemed to be getting much value out of it. Feel free to host it yourself if you still want it. 

## Hosting it yourself

It is written in Merb. At the end of its life, the server had merb 1.0.9 on it. It's using DataMapper as its ORM. 

It should be pretty trivial to host yourself. The deploy file is setup for managing nginx + mongrel (though I think just changing 1 line would let it run thin). I wouldn't do that now, though. I would either host it on [Heroku](http://heroku.com/) or host it on a VPS but use [Phusion Passenger](http://modrails.com/). 

Everything is pretty straightforward, standard Merb. The only somewhat weird thing is that you need to run the `update_tweets.sh` script to fetch new tweets. I was doing it once an hour. I was also running `clear_old_tweets.sh` once a day because tweets were seriously piling up and slowing down the db. That's less of an issue if you just host it for 1 or 2 accounts, though. 

## License

Released under the MIT License:

The MIT License

Copyright (c) 2008 Daniel Jackoway

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
