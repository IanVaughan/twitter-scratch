require 'rubygems'
require 'twitter'
require 'pp'

httpauth = Twitter::HTTPAuth.new('ianvaughan', '')
base = Twitter::Base.new(httpauth) # 'ianvaughan', '')

#pp base.lists('ianvaughan')
#pp base.user_timeline
#pp base.verify_credentials


last_id = 1
while true
  timeline = base.timeline( :friends, :since_id => last_id )

  unless timeline.empty?
    last_id = timeline[0].id

    timeline.reverse.each do|st|
      puts "#{st.user.name} said #{st.text}"
    end

    sleep 300
  end
end

