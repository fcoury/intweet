require 'rubygems'
require 'tweetstream'
require 'daemons'
require 'gmail_sender'
require 'redis'
require 'yaml'
require 'config'
require 'ostruct'
require 'logger'

begin
  config = Intweet::Config.new

  r = Redis.new

  Daemons.run_proc('consumer', :multiple => true) do
    logger = Logger.new("consumer-#{$$}.log", "daily")
    logger.info "Checking delivery queue..."

    alerts  = []
    body    = []
    terms   = []
    total   = 0

    while tweet_str = r.pop_head('tweets')
      tweet = YAML.load(tweet_str)

      config.terms.each do |term|
        if tweet.text =~ /#{term}/
          if total < 10
            alerts << term 
            body << "#{tweet.user.screen_name}: #{tweet.text}\n\n"
          end

          total += 1
        end
      end
    end
  
    body << "... and #{total - 10} more ..." if total > 10

    if alerts.empty?
      logger.info "Nothing to deliver..."
    else
      alerts.uniq!

      subject = "[intweet] Alerts for #{alerts.join(" ")}"

      logger.info "Sending: #{subject} with #{total} tweets"

      g = GmailSender.new(config.gmail_user, config.gmail_password)
      g.send(config.email, subject, body.join(""))
    end

    logger.info "Sleeping..."
    sleep config.send_period
    logger.info ""
  end
rescue
  logger.error $!
end