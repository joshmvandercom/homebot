require 'rubygems'
require 'appscript'
require 'isaac'
require 'eventmachine'
require 'yaml'

CONFIG = YAML.load_file("config.yml")

bot = Isaac::Bot.new do
  helpers do
    def show_dogs
      `open facetime://#{CONFIG['phone']}`
      Appscript::app('System Events').keystroke("\r")
      sleep(3)
      Appscript::app('FaceTime').activate
      sleep(3)
      Appscript::app('System Events').keystroke("\r")
    end
  end

  configure do |c|
    c.nick      = CONFIG['bot_nick']
    c.server    = CONFIG['server']
    c.port      = CONFIG['port']
  end

  on :channel, /^show dogs$/ do
    if nick == CONFIG['restricted_nick']
      msg channel, "Ok #{nick}.. will, do right away!"
      show_dogs
    end
  end

  on :connect do
    join "##{CONFIG['channel']}"
  end
end

EventMachine.run {bot.start}
