class FramesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # manage different frame and there rolling points
  def roll
    @game = Game.find(params[:game_id])
    @frame = @game.frames.find_by(number: params[:frame_number])

    case
    when strike_in_first_roll?
      handle_strike_in_first_roll
    when frame_ten_strike_or_spare?
      handle_frame_ten_strike_or_spare
    when strike_already_in_first_roll?
      render_strike_already_message
    when first_roll_less_than_ten_pins?
      handle_first_roll_less_than_ten_pins
    when second_roll_invalid?
      render_invalid_second_roll_message
    when spare_in_second_roll?
      handle_spare_in_second_roll
    when valid_second_roll?
      handle_valid_second_roll
    else
      render_error_message
    end
  end

  private

  def strike_in_first_roll?
    @frame.rolls.empty? && params[:pins].to_i == 10
  end

  def handle_strike_in_first_roll
    @frame.rolls << params[:pins].to_i
    @frame.save
    render json: { message: 'Strike! You knocked down all 10 pins in the first roll.' }, status: :ok
  end

  def frame_ten_strike_or_spare?
    params[:frame_number].to_i == 10 && (@frame.rolls.first == 10 || @frame.rolls.sum == 10) && @frame.rolls.count < 3
  end

  def handle_frame_ten_strike_or_spare
    @frame.rolls << params[:pins].to_i
    @frame.save
    render json: { error: "You got #{@frame.rolls.sum} points!!!" }
  end

  def strike_already_in_first_roll?
    @frame.rolls.count == 1 && @frame.rolls.sum == 10
  end

  def render_strike_already_message
    render json: { message: 'You already got the Strike!!.' }, status: :ok
  end

  def first_roll_less_than_ten_pins?
    @frame.rolls.empty? && params[:pins].to_i < 10
  end

  def handle_first_roll_less_than_ten_pins
    @frame.rolls << params[:pins].to_i
    @frame.save
    render json: { message: 'You knocked down ' + params[:pins] + ' pins in the first roll. You have one more chance.' }, status: :ok
  end

  def second_roll_invalid?
    @frame.rolls.count == 1 && params[:pins].to_i > (10 - @frame.rolls.sum)
  end

  def render_invalid_second_roll_message
    render json: { message: "You already got #{@frame.rolls.sum} points out of 10, number is invalid remaning points are #{10 - @frame.rolls.sum}" }
  end

  def spare_in_second_roll?
    @frame.rolls.count == 1 && @frame.rolls.sum + params[:pins].to_i == 10
  end

  def handle_spare_in_second_roll
    @frame.rolls << params[:pins].to_i
    @frame.save
    render json: { message: 'Spare! You knocked down all 10 pins in two rolls.' }, status: :ok
  end

  def valid_second_roll?
    @frame.rolls.count < 2
  end

  def handle_valid_second_roll
    @frame.rolls << params[:pins].to_i
    @frame.save
    render json: { error: "You got #{@frame.rolls.sum} points!!!" }
  end

  def render_error_message
    render json: { error: 'Cannot add more rolls in a frame' }, status: :unprocessable_entity
  end
end