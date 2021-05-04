#             Rubot 2.0
# Module:       Commands
# Written by:   Aaron Harman
# Description:  Fucntionality activated by prefixed commands

# Variables
stealth_mode = false  # stealth mode is off by default
last_reward = [0,0]   # the last pair that rewarded (rewarder,rewardee)

# Functions
def getRandomWord
  word = ""
  File.open('nounlist.txt') do |io|
    word = io.readlines[rand(0..6799)].strip
  end
  word #return the word grabbed
end

# exit - shuts down the $bot (help_available: false makes it so it doesn't show up in the help menu)
$bot.command(:exit, help_available: false) do |event|
  break unless event.user.id == 201799907860807681 # Only lets me shut it down
  $bot.send_message(event.channel.id, 'Rubot is shutting down')
  exit
end

# setscore - sets a user's score, only usable by me
$bot.command(:setscore, help_available: false) do |event|
  break unless event.user.id == 201799907860807681
  userid = event.message.mentions[0].id
  score = event.message.content[/\s+\d+/].strip.to_i
  puts('userid: '+userid.to_s+'  score: '+score.to_s)
  setScore(userid,score)
  '' # because for some reason it sends a message with the value of the function
end

# stealthmode - toggles stealth mode on and off, making Rubot invisible or online
$bot.command(:stealthmode, description: "Toggles Rubot's stealth mode", usage: 'Just say "'+PREFIX+'stealthmode" to toggle!') do |event|
  if stealth_mode
    $bot.send_message(event.channel.id, 'Exiting stealth mode...')
    $bot.online
    stealth_mode = false
  else
    $bot.send_message(event.channel.id, 'Entering stealth mode...')
    $bot.invisible
    stealth_mode = true
  end
  "" # because for some reason it sends a message with the value of the function
end

# score - display's the user's score
$bot.command(:score, description: "Gives you your gem score", usage: 'Just say "'+PREFIX+'score" to get your score') do |event|
  score = getScore(event.author.id)
  $bot.send_message(event.channel.id, 'You have ' + score.to_s + ' :gem:')
end

# leaderboard - displays all of the users on the server and their score in order by score
$bot.command(:leaderboard, description: "Shows the score of everyone on the server", usage: 'Just say "'+PREFIX+'leaderboard" to show the leaderboard') do |event|
  users = event.server.members
  users.delete_if {|user| user.bot_account? }
  table = Array.new
  i = 0
  users.each do |member|
    name = member.username
    score = getScore(member.id)
    table[i] = [score,name]
    i+=1
  end
  table.sort!.reverse!
  i = 1
  event << "Leaderboard:"
  table.each do |value|
    event << "  " + i.to_s + ". " + value[1].to_s + ": " + value[0].to_s
    i+=1
  end
  "" # because for some reason it sends a message with the value of the function
end

# goodmeme - rewards someone for posting a good meme, also gives the user a small reward
$bot.command(:goodmeme, description: "Let someone know they made a good meme", usage: 'Just say "'+PREFIX+'goodmeme" to reward the last person who posted an image!') do |event|
  meme_reward = 2 # how many gems the meme poster gets
  user_reward = 1 # how many gems the person who called the command gets
  #get all messages with images in the last 10 messages
  recents = event.channel.history(20).delete_if {|message| not (message.attachments.any? {|atch| atch.image?} or message.embeds.any? {|emb| emb.type == :video})}
  recents.sort! {|a,b| b.timestamp <=> a.timestamp} #sorts the messages with the most recent message first
  if recents[0] == nil #theres no image/video in the last 10 messages
    $bot.send_message(event.channel.id, "I couldn't find an image/video post in the last 20 messages. :man_shrugging: Sorry!")
  elsif event.author.id == recents[0].author.id #they tried to reward themselves
    $bot.send_message(event.channel.id, "Nice try. You can't reward yourself.")
  elsif event.author.id == last_reward[0] && recents[0].author.id == last_reward[1] # same pairing as last time goodmeme was invoked
    $bot.send_message(event.channel.id, "You just rewarded them, give someone else a chance...")
  else #found a valid post to reward
    rewarder = event.author
    rewardee = recents[0].author
    event << rewardee.mention + " has been rewarded "+meme_reward.to_s+" :gem: for their good meme."
    event << "You, "+rewarder.mention+", have been rewarded "+user_reward.to_s+" :gem: for being a good person."
    addScore(rewardee.id,meme_reward)
    addScore(rewarder.id,user_reward)
    last_reward = [rewarder,rewardee]
  end
  "" # because for some reason it sends a message with the value of the function
end

# badmeme - scolds the user for being so negative
$bot.command(:badmeme, help_available: false) do |event|
  $bot.send_message(event.channel.id, "Get your negativity outta here. #{[":mask:",":angry:",":shushing_face:",":face_vomiting:"].shuffle[0]}")
end

# shitpost
$bot.command(:shitpost, min_args: 0, max_args: 2, description: "Says some nonsense in the meme channel.", usage: "Either just "+PREFIX+"shitpost, or put a number after to specify the number of words. If you don't want the standard channel, put a different channel name after the number.") do |event,*args|
  # determine the number of words to use
  if args.length == 0 # no args
    num_words = 3
  else # the arg is the # of words
    num_words = args[0].strip.to_i
    if num_words <= 0
      num_words = 3
    elsif num_words > 1000
      num_words = 1000
    end
  end
  # construct the message
  post = ''
  for x in 1..num_words
    post << getRandomWord + ' '
  end
  post.strip!
  # check the server and send a message in the appropriate channel
  if event.server.id == 484882444428771348 # Mica
    channelID = 711112222956584980
  elsif event.server.id == 201830610619203584 # Peter Griffin's Ball Chin
    channelID = 277506818505310209
  else # any other channel
    channelID = event.channel.id
  end
  if args.length == 2 # has a channel argument
    # find a text channel with the given name
    meme_chan = event.server.channels.delete_if {|channel| (channel.name.downcase != args[1].downcase.delete_prefix('#') && channel.mention != args[1]) || channel.type != 0}
    if meme_chan.length == 1 # found exactly one
      channelID = meme_chan[0].id
    elsif meme_chan.length > 1 # found multiple (idk if this is even possible)
      $bot.send_message(event.channel.id, "Found multiple text channels with that name. Using the first one.")
      channelID = meme_chan[0].id
    else # found none
      $bot.send_message(event.channel.id, "I couldn't find a text channel with that name. I'll use the default channel instead.")
    end
  end
  # trim if too long
  if post.length > 2000
    post = post[0,2000]
  end
  $bot.send_message(channelID,post)
end

# real shitpost - only uses ATM as the word
$bot.command(:realshitpost, min_args: 0, max_args: 2, description: "Says the best nonsense in the meme channel.", usage: "Either just "+PREFIX+"realshitpost, or put a number after to specify the number of words.") do |event, *args|
  # determine the number of words to use
  if args.length == 0 # no args
    num_words = 3
  else # the arg is the # of words
    num_words = args[0].strip.to_i
    if num_words <= 0
      num_words = 3
    end
  end
  # construct the message
  post = ''
  for x in 1..num_words
    post << 'ATM '
  end
  post.strip!
  # check the server and send a message in the appropriate channel
   if event.server.id == 484882444428771348 # Mica
    channelID = 711112222956584980
  elsif event.server.id == 201830610619203584 # Peter Griffin's Ball Chin
    channelID = 277506818505310209
  else # any other channel
    channelID = event.channel.id
  end
  if args.length == 2 # has a channel argument
    # find a text channel with the given name
    meme_chan = event.server.channels.delete_if {|channel| (channel.name.downcase != args[1].downcase.delete_prefix('#') && channel.mention != args[1]) || channel.type != 0}
    if meme_chan.length == 1 # found exactly one
      channelID = meme_chan[0].id
    elsif meme_chan.length > 1 # found multiple (idk if this is even possible)
      $bot.send_message(event.channel.id, "Found multiple text channels with that name. Using the first one.")
      channelID = meme_chan[0].id
    else # found none
      $bot.send_message(event.channel.id, "I couldn't find a text channel with that name. I'll use the default channel instead.")
    end
  end
  # trim if too long
  if post.length > 2000
    post = post[0,2000]
  end
  $bot.send_message(channelID,post)
end

# eval - allows me, and only me, to run code through rubot
$bot.command(:eval, help_available: false) do |event, *code|
  break unless event.user.id == 201799907860807681 # My discord ID

  begin
    eval code.join(' ')
  rescue StandardError
    'An error occurred :cry:'
  end
end

