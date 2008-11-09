require 'rubygems'
require 'twitter'




def func
  raise Twitter::CantConnect
end

func
puts "didn't kill"

