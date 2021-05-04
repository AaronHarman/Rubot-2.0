#             Rubot 2.0
# Module:       Main
# Written by:   Aaron Harman
# Description:  A discord bot that performs various functions

# Requires
require 'discordrb' # the discord $bot gem

# Bot Initialization
PREFIX = '%' # the prefix used for commands. it only needs to be changed here
load 'token.rb' # loads the file with the token in it. NOTE: This file is not included in the repo, and must declare a variable 'token' containing the string
# create the bot
# it is global to allow the loading stuff below to work properly
$bot = Discordrb::Commands::CommandBot.new(token: $token, prefix: PREFIX)

# Loads
# Will reload all of the modules named in modules.txt, without needing to restart the bot
def loadFunctionality
  File.open('modules.txt') do |io|
    modules = io.readlines
    modules.each do |mod|
      load mod.strip
    end
  end
end
loadFunctionality

# Reload Command
$bot.command(:reload, help_available: false) do |event|
  break unless event.user.id == 201799907860807681 # Only lets me rekoad this stuff
  # reset the bot
  $bot.clear!
  # load each of the segments again
  loadFunctionality
  # and then send a message with a reloading gif
  'Reloaded. https://tenor.com/view/lockandload-lock-load-arnold-schwarzenegger-gif-7977879'
end

# when the bot is ready, set its status
$bot.ready do |event|
  $bot.game = PREFIX + 'help for commands'
end

# This method call has to be put at the end of your script, it is what makes the bot actually connect to Discord. If you
# leave it out (try it!) the script will simply stop and the bot will not appear online.
$bot.run
