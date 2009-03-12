User.all.each do |u|
    u.update_tweets
end
