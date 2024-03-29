class Game < ApplicationRecord
  has_many :frames, dependent: :destroy
  after_create :initialize_frames

  # create 10 frames for each game whenever new game is created
  def initialize_frames
    (1..10).each { |number| frames.create(number: number) }
  end

  #calculate the total score
  def score(game)
    total_score = 0
    frames = game.frames.order(number: :asc)
    frames.each do |frame| # we can use each with index also, I manage number inside the frame 
      rolls = frame.rolls
      frame_index = frame.number - 1
      if !rolls.nil? && !rolls.empty?
        if strike?(frame_index, rolls)
          total_score += (frame_index == 10 ? strike_bonus(frame_index, rolls) : 10 + strike_bonus(frame_index, rolls))
        elsif spare?(frame_index, rolls)
          total_score += (frame_index == 10 ? spare_bonus(frame_index, rolls) : 10 + spare_bonus(frame_index, rolls))
        else
          total_score += sum_of_balls_in_frame(frame_index, rolls)
        end
      end
    end
    total_score
  end

  # check if it is strike(all pins knocked down with the first ball)
  def strike?(frame_index, rolls)
    !rolls.nil? && rolls.compact.first.to_i == 10
  end

  # if it is strike then give the bonus to add the next frame both bolling points
  def strike_bonus(frame_index, rolls)
    next_frame = frames[frame_index + 1] || frames.find_by(number: frame_index + 1)
    if next_frame.nil? || next_frame.rolls.nil?
      frames.find_by(number: frame_index).rolls.compact.sum if frame_index == 10
    else
      next_frame.rolls.compact.take(2).sum
    end
  end

  # Check if it spare(all pins knocked down with the first and second bith ball)
  def spare?(frame_index, rolls)
    frame_index == 10 ? rolls&.compact&.take(2)&.sum == 10 : rolls&.compact&.sum == 10
  end

  # if it is spare then add the bonus to give the extra point of next frame first bolling points
  def spare_bonus(frame_index, rolls)
    next_frame = frames[frame_index + 1] || frames.find_by(number: frame_index + 1)
    if next_frame.nil? || next_frame.rolls.nil?
      frames.find_by(number: frame_index).rolls.compact.sum if frame_index == 10
    else
      next_frame.rolls.compact.first.to_i
    end
  end

  # If no strike or spare then simply calculate the both bolling points
  def sum_of_balls_in_frame(frame_index, rolls)
    rolls.compact.sum
  end
end
