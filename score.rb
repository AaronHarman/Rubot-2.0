#             Rubot 2.0
# Module:       Score
# Written by:   Aaron Harman
# Description:  Hold Functions for handling individual users' scores

# Score class
class Score
  def initialize
    @scores = Hash.new
  end
  def addScore(id,num)
    if @scores[id] == nil
      @scores[id] = num
    else
      @scores[id]+= num
    end
  end
  def score(id)
    @scores[id]
  end
  def setScore(id,num)
    @scores[id] = num
  end
end

# Score functions
# adds to a user's score
def addScore(id,num)
  scores = Score.new
  File.open('score') do |f|
    scores = Marshal.load(f)
  end
  scores.addScore(id,num)
  File.open('score','w+') do |f|
    Marshal.dump(scores,f)
  end
end
# sets a user's score
def setScore(id,num)
  scores = Score.new
  File.open('score') do |f|
    scores = Marshal.load(f)
  end
  scores.setScore(id,num)
  File.open('score','w+') do |f|
    Marshal.dump(scores,f)
  end
end
# gets a user's score
def getScore(id)
  scores = Score.new
  File.open('score') do |f|
    scores = Marshal.load(f)
  end
  if scores.score(id) == nil
    0
  else
    scores.score(id)
  end
end
