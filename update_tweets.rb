threadarr = []
User.all.each do |u|
  t = Thread.new do
    u.update_tweets
  end
  threadarr << t
end
threadarr.each do |t|
  t.join if t.alive?
end
