if GC.respond_to?(:copy_on_write_friendly=)
        GC.copy_on_write_friendly = true
end
User.all.each do |u|
    u.update_tweets
end
