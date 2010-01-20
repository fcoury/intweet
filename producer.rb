require 'rubygems'
require 'tweetstream'
require 'redis'
require 'yaml'
require 'config'
require 'logger'

config = Intweet::Config.new
logger = Logger.new("producer.log", "daily")

logger.info "Started. Monitoring terms: #{config.terms.inspect}"

r = Redis.new
TweetStream::Daemon.new('fcoury', 'tempra13twit').track(config.terms) do |status|
  logger.info "Found: #{status}"
  r.push_tail 'tweets', status.to_yaml
end