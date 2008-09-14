%xml{:version => "1.0"}
%feed{:xmlns => "http://www.w3.org/2005/Atom"}
  %title
    ="#{@user.username}'s Twitterlinks Feed"
  %link{:href => "/#{@user.username}.xml", :rel => self}
  %link{:href => "/"}
  %updated
    =Time.now
  %author
    %name
      Daniel Jackoway
  %id
    http://www.twitterlinks.com

  -@user.tweets.each do |tweet|
    %entry
      %title
        Link
      %link{:href => tweet.website}
      %id
        http://www.twitterlinks.com
      %updated
        tweet.created_at
      %content
        tweet.text
    

