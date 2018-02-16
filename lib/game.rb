require 'pry'


class Game

attr_reader :guess,
            :correct_number

  def initialize
    @guess = nil
    @correct_number = rand(100)
    @guesses = []
  end

  def user_guess(input)
    @guess = input
    @guesses << @guess
    @guess
  end

  def guess_eval
    if @guess > @correct_number
      'Too high!'
    elsif @guess < @correct_number
      'Too low!'
    else
      'Correct!!!'
    end
  end

  def game_information
    return "Please make a guess!" if @guesses.empty?

    "Total guesses: #{@guesses.length}. Your most recent
    guess was #{@guesses.last}. #{guess_eval}"
  end
end
