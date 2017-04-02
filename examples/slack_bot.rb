$LOAD_PATH.push("path/to/aivisbot/lib")

require 'aivis'
require 'aivis/slack_bot'

class SlackBot < Aivis::SlackBot::Reactor; end

bot = SlackBot.new do |config|
  config.token = 'SLACK_BOT_TOKEN'
  config.bot_id = 'SLACK_BOT_ID'
end

class PingPlugin < Aivis::Plugin
  on :message do
    command 'ping' do |message|
      message.reply('pong!')
    end
  end
end

class JobPlugin < Aivis::Plugin
  every 10.seconds do |time, account|
    account.web_client.chat_postMessage(channel: '#general', text: "#{time}")
  end
end

bot.install_plugin(PingPlugin, JobPlugin)
bot.run
