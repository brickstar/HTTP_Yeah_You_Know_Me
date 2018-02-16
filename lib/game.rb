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
  end

  def gameplay
    puts @correct_number
    if @guess == @correct_number
      "Wow, you guessed it!"
    elsif
      @guess >= @correct_number
      "Too high!"
    else
      "Too low!"
    end
  end

  def game_information
    if @guesses.empty?
      "Make a guess blablablabla"
    else
      "You've guessed #{guesses.length} times. Your most recent
      guess was #{guesses.last}."
    end
  end
end
