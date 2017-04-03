# Aivis bot

A plugin-enable bot engine

## Available

- [x] Slack bot engine
- [ ] Twitter bot engine
- [ ] Messenger bot engine
- [ ] LINE bot engine

## Installation
```
$ git clone git@github.com:yukidallas/aivisbot.git
```

## Dependency
[slack-ruby-client][slack-ruby-client]
```
$ gem install slack-ruby-client
```

[slack-ruby-client]: https://github.com/slack-ruby/slack-ruby-client

## Configuration

Add the path to LOAD_PATH for require files like ruby gem.
```ruby
$LOAD_PATH.push('/path/to/aivisbot/lib')

require 'aivis'
require 'aivis/slack_bot'
```

## Usage Examples (Slack bot)
More information on [Wiki][slack-plugin]

[slack-plugin]: https://github.com/yukidallas/aivisbot/wiki/Create-Plugin

Bot configuration
```ruby
bot = Aivis::SlackBot::Reactor.new do |config|
  config.token = 'SLACK_BOT_TOKEN'
  config.bot_id = 'SLACK_BOT_ID'
end

bot.run
```

Command base plugin
```ruby
class PingPlugin < Aivis::Plugin
  on :message do
    command 'ping' do |message|
      message.reply 'pong!'
    end
  end
end
```

Job base plugin
```ruby
class TimeSignalPlugin
  every 1.hours do |time, account|
    account.web_client.chat_postMessage(
      channel: '#general', text: "#{time}"
    )
  end
end
```

Install plugin
```ruby
bot.install_plugin(PingPlugin, JobPlugin)
```

## More custimize
Catch exceptions
```ruby
class MyBot < Aivis::SlackBot::Reactor
  def handle_exception(options = {})
    super
  rescue => e
    raise e
  end
end
```

## Examples
[https://github.com/yukidallas/aivisbot/tree/master/examples][examples]

[examples]: https://github.com/yukidallas/aivisbot/tree/master/examples
