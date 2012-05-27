#!/usr/bin/env ruby
#curl -u aboutruby:pass123 http://twitter.com/statuses/friends_timeline.xml
#curl -u aboutruby:pass123 -d 'status=Posted from CURL' http://twitter.com/statuses/update.xml

#curl -u ianvaughan:jodiev http://twitter.com/statuses/friends_timeline.xml >timeline.xml


require 'rubygems'
require 'hpricot'

doc = Hpricot(open('timeline.xml'))

(doc/'status').each do |st|
  user = (st/'user name').inner_html
  text = (st/'text').inner_html

  puts "#{user} -> #{text}"
end

