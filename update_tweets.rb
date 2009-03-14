User.all.each do |u|
  puts u
  u.update_tweets
end
