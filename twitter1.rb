#! /usr/bin/ruby
#ruby twitterbackup.rb yourtwittername


require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

class TwitterBackup

  def backup(username)
    url = URI::parse('http://twitter.com')

    page = 1
    loop do
      req = Net::HTTP::Get.new("/statuses/user_timeline.json?screen_name=#{username}&count=200&page=#{page}")
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }

      if res.body.length > 2
        process_response(JSON.parse(res.body))
      else
        break
      end

      page += 1
    end
  end

  protected
    def process_response(response_json)
        response_json.each do |tweet|
          puts "#{Time.parse(tweet['created_at']).strftime("%A %d %B %Y at %I:%M%p")}, #{tweet['text']}, #{tweet['source']}, #{tweet['in_reply_to_screen_name']}"
        end
    end
end

TwitterBackup.new.backup(ARGV[0])
