#             Rubot 2.0
# Module:       Markov
# Written by:   Aaron Harman
# Description:  Hold Functions for imitating individual users with Markov chains

# Chains are held in the following in the following data structure:
#   Hash, where each key is a user ID, each value being a
#   Hash, where each key is the word 2 before the one we wish to produce, and each value is a
#   Hash, where each key is the word 1 before the one we wish to produce, and each value is a
#   Hash, where each key is the word to be produced, and each value is an
#   integer, indicating the weight of the word when a choice is made

# Markov class
class Markov
  def initialize
    @chains = {}
    @consented = []
  end

  # add a consenting user
  def consent(id)
    if not @consented.include?(id)
      @consented.push(id)
    end
  end

  # remove a consenting user
  def unconsent(id)
    @consented.delete(id)
  end

  # sanitize input to have punctuation given extra space
  def sanitize(message)
    #punc = '!"#$%&()*+, -./:;<=>?@[\]^_`{|}~'
    message.gsub(/[!"#\$%&\(\)\*\+,-\.\/:;<=>\?@\[\\\]\^_`\{\|\}~]+/, ' \0 ')
  end

  # clear the whole chain for a user
  def clear_user(id)
    @chains.delete(id)
  end

  # add a word to a chain
  # id of 0 adds to the collective chain
  def add_word(id, words)
    if not @chains.has_key?(id)
      @chains[id] = {}
    end
    if not @chains[id].has_key?(words[0])
      @chains[id][words[0]] = {}
    end
    if not @chains[id][words[0]].has_key?(words[1])
      @chains[id][words[0]][words[1]] = {}
    end
    if not @chains[id][words[0]][words[1]].has_key?(words[2])
      @chains[id][words[0]][words[1]][words[2]] = 1
    else
      @chains[id][words[0]][words[1]][words[2]] += 1
    end
  end

  # processes a message into the respective ID's chain
  def add_message(id, message)
    if @consented.include?(id)
      words = sanitize(message).strip.split
      for i in 0..words.length-3
        # adds both to this ID and the global chain
        add_word(id, [words[i], words[i+1], words[i+2]])
        add_word(0, [words[i], words[i+1], words[i+2]])
      end
      return true
    end
    return false
  end

  # generate a new message from the respective ID's chain
  def gen_message(id, num)
    if @consented.include?(id) or id == 0
      message = ''
      chain = @chains[id]
      prev = ''
      prevprev = ''
      if num >= 1
        prevprev = chain.keys[rand(chain.length)]
        message.concat(prevprev)
      end
      if num >= 2
        prev = chain[message].keys[rand(chain[message].length)]
        message.concat(" "+prev)
      end
      if num >= 3
        for i in 2..num
          choiche = []
          if chain[prevprev] == nil
            break
          end
          if chain[prevprev][prev] == nil
            break
          end

          for key in chain[prevprev][prev].keys
            chain[prevprev][prev][key].times do
              choiche.push(key)
            end
          end
          cur = choiche.sample
          message.concat(" "+cur)
          prevprev = prev
          prev = cur
        end
      end

      # post-processing on the generated message
      

      return message
    end
  end
end

# Rubot Helper declarations
$markov = Markov.new
File.open('markov') do |f|
  $markov = Marshal.load(f)
end

def markov_add(id, message)
  worked = $markov.add_message(id, message)
  File.open('markov','w+') do |f|
    Marshal.dump($markov,f)
  end
  return worked
end

def markov_gen(id, num)
  $markov.gen_message(id, num)
end

def markov_consent(yn, id)
  result = nil
  if yn
    result = $markov.consent(id)
  else
    result = $markov.unconsent(id)
  end
  File.open('markov','w+') do |f|
    Marshal.dump($markov,f)
  end
  return result
end
