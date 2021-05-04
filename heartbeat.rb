#             Rubot 2.0
# Module:       Heartbeat
# Written by:   Aaron Harman
# Description:  Fucntionality activated periodically

first = true;

$bot.heartbeat() do |event|
  puts("\nHeartbeat: #{Time.now}\n")
  
  #first hearbeat stuff
  if first
    old_user_list = $bot.server(484882444428771348).users
    puts(old_user_list)
    first = false
    "" #to make sure it doesnt say anything
  else
    
    # Notify people of streams starting (only in Mica)
    $bot.server(484882444428771348).users.each do |user| #check to see if they weren't streaming last check, but are now
      puts("#{user.name}: #{user.stream_type}, #{user.stream_url}")
      if user.stream_type != nil && old_user_list[user.id].stream_type == nil
        notify_role = $bot.server(484882444428771348).role(775441384245035053)
        $bot.send_message($bot.server(484882444428771348).default_channel.id, "Hey #{notify_role.mention}! #{user.mention} is streaming! Go check it out! #{user.stream_url}")
      end
    end
    
    old_user_list = $bot.server(484882444428771348).users
  end
end
