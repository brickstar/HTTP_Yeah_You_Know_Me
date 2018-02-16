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

  def gameplay
    puts @correct_number
    if @guess > @correct_number
      'Too high!'
    elsif @guess < @correct_number
      'Too low!'
    else
      'Congrats!!!'
    end
  end

  def game_information
    if @guesses.empty?
      "make a guess mf"
    else
      "You've guessed #{@guesses.length} times. Your most recent
      guess was #{@guesses.last}."
    end
  end
end
