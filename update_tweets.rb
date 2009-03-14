User.all.each do |u|
  puts u.username
  u.update_tweets
end
