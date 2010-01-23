require 'rubygems'
require 'tweetstream'
require 'redis'
require 'yaml'
require 'config'

c = Intweet::Config.new
r = Redis.new

TweetStream::Daemon.new(c.twitter_user, c.twitter_password).track(*c.terms) do |status|
  r.push_tail 'tweets', status.to_yaml
end