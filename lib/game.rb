require './lib/server'
require './lib/response'
require 'pry'


class Game
  attr_reader :guess,
              :guesses,
              :answer

  def initialize
    @answer = rand(100)
    @guesses = []
    @guess = nil
  end

  def guess(user_guess)
    @guess = user_guess.gets.chomp.to_i
    @guesses << @guess
  end

  def gameplay
    if @guess == @answer
      "Wow, you guessed it!"
    elsif
      @guess >= @answer
      "Too high!"
    else
      "Too low!"
    end
  end

  def game_information
    if guesses.empty?
      "Make a guess blablablabla"
    else
      "You've guessed #{guesses.length} times. Your most recent
      guess was #{guesses.last}."
    end
end
