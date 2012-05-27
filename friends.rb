require 'rubygems'
require 'twitter'
require 'pp'

def followers_of name
  print "Getting the followers..."
  r = Twitter::follower_ids(name)
  puts "...Done"
  r
end

def friends_of name
  print "Getting your friends..."
  r = Twitter::friend_ids(name)
  puts "...Done"
  r
end

def twitter copy_to
  httpauth = Twitter::HTTPAuth.new(copy_to[:name], copy_to[:pass])
  Twitter::Base.new(httpauth)
end

def perform copy_from, copy_to #(user,pass, followers, user_from)
  followers = followers_of copy_from
  friends = friends_of copy_from

  puts "#{copy_from} has #{friends.size} followers, and #{followers.size} people following them..."
#  if size > 150
#    puts '(You have more Friends to Follow than the Rate limit will allow within one hour!)'
#  end

  base = twitter copy_to

  begin
    base.update("This account is being copied from @#{copy_from} courtesy of @TwitDup")
  rescue
  end

  puts "Remaining hits : #{base.rate_limit_status.remaining_hits}"
  puts base.rate_limit_status


  puts "*** Adding follows... ***"

  count = 0
  friends.each do |id|
    print "#{count+=1}/#{friends.size} - Add Follow #{id}..." #: \"#{Twitter.user(id).name}\"..."

    begin
      base.friendship_create(id)
      print "    Done."
    rescue Exception => e
      print '    FAIL!'
      #      puts e  e.message  e.backtrace.inspect
    end

#    puts "    (Rate limit : #{base.rate_limit_status.remaining_hits})"
#    if base.rate_limit_status.remaining_hits <= 0
#      puts 'No limit left!'
#    end
  end

  puts "*** Requesting friends... ***"

  followers = [5905182]

  count = 0
  followers.each do |id|
    name = Twitter.user(id).screen_name
    print "#{count+=1}/#{followers.size} - Requesting #{id} : @#{name} follow you..."
    begin
      base.update("@#{name} Please could you follow me? I am copying this account from @#{copy_from}, many thanks. Courtesy of @TwitDup")
      puts "    Done."
    rescue
      puts '    FAIL!'
    end
  end

  base.update('Done. Account has been copied from @#{user_from} courtesy of @TwitDup')

end

#  @TwitDup
#   Account Duplicator
copy_from = 'ianvaughan'
copy_to = {:name => 'TwitDup', :pass =>''}

perform copy_from, copy_to

