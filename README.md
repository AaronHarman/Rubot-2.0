# Rubot-2.0
A Discord bot written in Ruby.
Contains a score system based around 💎s, which currently have no use outside of bragging rights.

Profile picture art by Eric Bradley (@eric_i_guess)

## Commands
- **%help** : Lists the commands available through use of the bot
- **%stealthmode** : Alternates Rubot in and out of "stealth mode," where it appears to be offline.
- **%score** : Reports your current 💎 score.
- **%leaderboard** : Reports the current 💎 score of everyone in the server, in a ranked order.
- **%goodmeme** : Gifts the last person to post a picture or video 2💎, and the gifter gets 1💎 as a reward for being nice.
- **%badmeme** : Why would you want to say that? It's just rude...
- **%shitpost** *[number]* : Generates a random string of nouns, if not given a number will generate 3.
- **%realshitpost** *[number]* : Same as the previous command, but only ever says "ATM."
- **%consent** : Allows Rubot to learn from your messages, and be able to use the **%imitate** command on you.
- **%unconsent** : Disallows Rubot from being able to learn from your messages or imitate you. It *will not* delete what Rubot has already learned; To have the data deleted, please contact the bot author (me!).
- **%imitate** *<user mention> [max words]* : Uses Markov chains to imitate a user's messages. If not given a max number of words, it will stop after 100 words. It will often stop before hitting the max number of words if it does not know a word to follow the words it has already generated.
- **%roll** : Rolls dice. This command has quite a few options, see the Roll Options section.
- **%eightball** : Responds with a random 8-ball response.
- **%choose** : Follow the command with choices seperated by spaces, "or", or commas. Rubot will choose one.

## Non-command Functionality
- Saying "Ping!" will cause Rubot to respond "Pong!", following up with the amount of time taken to process the request.
- If Rubot sees anyone use or react with the 🗿 emoji, it will respond "unhappily."
- If you say "hell yeah" in a message, Rubot will repeat your excitement, even matching the case with which you typed it.
- If you say "smile" in a message, Rubot will echo your happiness, even matching the case with which you typed it.
- If you say "Corey," Rubot will make a cool reference.
- If you mention Rubot while saying some rude words, it will get angry and remove 1💎 from your score.
- If you mention and thank Rubot, it will respond politely.
- If you mention Rubot and say hello, it will say hi back. Once per 24 hours, you will receive 1💎 for saying hello to Rubot.
- If Rubot hears a particular person say the word "kill," it will respond accordingly.

## Roll Options
**%roll** *#d#* (as many as you want)

add a number before your dice to roll that many sets

add these for particular changes:
- d# : drop this many dice after rolling
- k# : keep this many dice after rolling
- r# : reroll anything below this number once
- kl# : keep this many dice after rolling, but keep the lowest ones
- u : don't sort the rolls
- +# : add a number to the sum of the rolls
