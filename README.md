# Quick and Dirty Twitter keyword monitoring - intweet

I needed something to keep me posted on <a href="http://webbynode.com">Webbynode</a>'s-related twitter posts and found out that there were some Apps on AppStore that would charge you .99 EUR per keyword. Nah. I Installed Prowl for USD 2.99 instead so I can get any notifications I can take, straight from a Ruby daemon. Then I just deployed this to a Webby...

*Disclaimer:* The code is very dirty but works for my needs :)

# Prerequisites

* <a href="http://prowl.weks.net/">Prowl</a> for iPhone
* and/or Gmail Account
* Ruby and Gems: tweetstream, redis, prowl, fcoury-gmail and tlsmail
* <a href="http://code.google.com/p/redis/">Redis</a>

# Installation

To install on Ubuntu:

<pre>
$ git clone git://github.com/fcoury/intweet.git
$ cd intweet
$ ./install.sh
</pre>

## Configuring

<pre>
$ cp config.yml.example config.yml
</pre>

<dl>
  <dt>terms</dt>
  <dd>Array of keywords to monitor</dd>
  <dt>twitter_user</dt>
  <dd>Your twitter user</dd>
  <dt>twitter_password</dt>
  <dd>Your twitter password</dd>
  <dt>notify_by_prowl</dt>
  <dd>If <pre>true</pre>, uses Prowl for iPhone to get notifications</dd>
  <dt>prowl_apikey</dt>
  <dd>Your Prowl <a href="http://prowl.weks.net/api.php">API Key</a> (set it up <a href="https://prowl.weks.net/settings.php">here</a>)</dd>
  <dt>notify_by_email</dt>
  <dd>If <pre>true<pre>, sends emails notifications</dd>
  <dt>email</dt>
  <dd>Email to receive the notifications</dd>
  <dt>gmail_user</dt>
  <dd>Your gmail username</dd>
  <dt>gmail_password</dt>
  <dd>Your gmail password</dd>
  <dt>send_period</dt>
  <dd>Times between sending batches</dd>
</dl>  
