#             Rubot 2.0
# Module:       Messages
# Written by:   Aaron Harman
# Description:  Adds functionalities in response to messages

#when the $bot sees "Ping!", it responds with "Pong!", and how long it took to process
$bot.message(content: 'Ping!') do |event|
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

#when the $bot sees "Corey"
$bot.message(content: 'Corey') do |event|
  $bot.send_message(event.channel.id, "Corey's in the House!")
end

# moyai emoji
$bot.message(contains: "\u{1F5FF}") do |event|
  $bot.send_message(event.channel.id, ":moyai: is the worst emoji. It's horrendous and ugly. I hate it. The point of emojis is to show emotions, but what emotion does this show? Do you just wake up in the morning and think \"wow, I really feel like a massive fucking stone today\"? It's useless. I hate it. It just provokes a deep rooted anger within me whenever I see it. I want to drive on over to the fucking emoji headquarters and kill it. If this was the emoji movie I'd push it off a fucking cliff. People just comment :moyai: as if it's funny. It's not. :moyai: deserves to die. He deserves to have his smug little stone face smashed in with a hammer. Oh wow, it's a stone head, how fucking hilarious, I'll use it in every comment I post. NO. STOP IT. It deserves to burn in hell. Why is it so goddamn smug. You're a fucking stone, you have no life goals, you will never accomplish anything in life apart from pissing me off. When you die noone will mourn. I hope you die.")
end
$bot.reaction_add(emoji: "\u{1F5FF}") do |event| # reacts with moyai
  puts("Moyai reaction response triggered by: "+event.user.username.to_s)
  $bot.send_message(event.channel.id, ":moyai: is the worst emoji. It's horrendous and ugly. I hate it. The point of emojis is to show emotions, but what emotion does this show? Do you just wake up in the morning and think \"wow, I really feel like a massive fucking stone today\"? It's useless. I hate it. It just provokes a deep rooted anger within me whenever I see it. I want to drive on over to the fucking emoji headquarters and kill it. If this was the emoji movie I'd push it off a fucking cliff. People just comment :moyai: as if it's funny. It's not. :moyai: deserves to die. He deserves to have his smug little stone face smashed in with a hammer. Oh wow, it's a stone head, how fucking hilarious, I'll use it in every comment I post. NO. STOP IT. It deserves to burn in hell. Why is it so goddamn smug. You're a fucking stone, you have no life goals, you will never accomplish anything in life apart from pissing me off. When you die noone will mourn. I hope you die.")
end

# hell yeah
$bot.message(contains: /hell.+yeah/i) do |event|
  $bot.send_message(event.channel.id, event.content[/hell/i]+' '+event.content[/yeah/i])
end

# smile
$bot.message(contains: /smile/i) do |event|
  $bot.send_message(event.channel.id, event.content[/smile/i])
end

# markov listening
$bot.message do |event|
  unless event.message.content.start_with?('%')
    markov_add(event.author.id, event.message.content)
  end
end
