#             Rubot 2.0
# Module:       Mentions
# Written by:   Aaron Harman
# Description:  Fucntionality activated by mentions of this bot

last_hi = Time.new(2000) #defaults to January 1, 2000

# insulted
$bot.mention(start_with: /(\s|\W|^)fuck(\s|\W|$)/i) do |event|
  if event.author.id == 292749588551565314 #corey
    $bot.send_message(event.channel.id, 'Shut up, loser.')
  else
    $bot.send_message(event.channel.id, 'Oh yeah? Fuck you, ' + event.author.mention)
  end
  $bot.send_message(event.channel.id, 'You have lost 1 :gem: for your foul language.')
  addScore(event.author.id,-1)
end

# thanked
$bot.mention(contains: /thank/i) do |event|
  $bot.send_message(event.channel.id, "You're very welcome!")
end

# someone said hi
def hello(event,last_hi,bot)
  if event.author.id == 153307669405499393 # Alek
    bot.send_message(event.channel.id, 'Greetings, Mr. Biscardi!')
  else
    bot.send_message(event.channel.id, "Hello, " + event.author.mention)
  end
  if(event.message.timestamp - last_hi >= 86400.0)
    bot.send_message(event.channel.id, "Since nobody has said hi to me for a day, you get 1 :gem:!")
    addScore(event.author.id,1)
  end
  event.message.timestamp
end
$bot.mention(contains: /(\s|\W|^)(hello|hi|greetings|howdy)(\s|\W|$)/i) do |event| last_hi=hello(event,last_hi,$bot) end
# $bot.mention(contains: /hi/i) do |event| last_hi=hello(event,last_hi,$bot) end
# $bot.mention(contains: /greetings/i) do |event| last_hi=hello(event,last_hi,$bot) end
# $bot.mention(contains: /howdy/i) do |event| last_hi=hello(event,last_hi,$bot) end
