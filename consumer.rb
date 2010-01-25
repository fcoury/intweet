require 'rubygems'
require 'tweetstream'
require 'daemons'
require 'gmail_sender'
require 'prowl'
require 'redis'
require 'yaml'
require 'config'
require 'ostruct'
require 'logger'

class Array
  def joinizzle
    return "" if empty?

    array = self.clone
    last = array.pop

    return last if array.empty?

    "#{array.join(", ")} and #{last}"
  end
end

config = Intweet::Config.new

r = Redis.new

options = { 
  :dir => "log", 
  :log_output => true, 
  :dir_mode => :normal 
} 

Daemons.send(:run_proc, 'consumer', options) do
  while true
    alerts  = []
    body    = []
    terms   = []
    users   = []
    total   = 0

    while tweet_str = r.pop_head('tweets')
      tweet = YAML.load(tweet_str)

      config.terms.each do |term|
        if tweet.text =~ /#{term}/
          if total < 10
            alerts << term 
            body << "#{tweet.user.screen_name}: #{tweet.text}\n\n"
            users << tweet.user.screen_name
          end

          total += 1
        end
      end
    end

    body << "... and #{total - 10} more ..." if total > 10

    unless alerts.empty?
      alerts.uniq!

      if config.notify_by_email
        subject = "[intweet] Alerts for #{alerts.joinizzle}"
        puts "Sending: #{subject} with #{total} tweets"
        g = GmailSender.new(config.gmail_user, config.gmail_password)
        g.send(config.email, subject, body.join(""))
      end
      
      if config.notify_by_prowl
        if total == 1
          description = body
        else
          str = []
          users.uniq.each do |user|
            str << user
            if str.size == users.size
              break
            elsif str.size > 3
              str << "#{total - 3} more..."
              break
            end
          end

          description = "Tweets from: #{str.joinizzle}"
        end

        puts "Sending prowl [Intweet Alerts - Alerts: #{alerts.joinizzle}]: #{description}"
        Prowl.add(
             :apikey => config.prowl_apikey,
             :application => "Intweet Alerts",
             :event => "Alerts: #{alerts.joinizzle}",
             :description => description
        )
      end
      
    end
    
    sleep config.send_period
  end
end
