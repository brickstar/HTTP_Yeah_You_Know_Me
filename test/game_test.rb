require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test
  attr_reader :game

  def setup
    @game = Game.new
  end

  def test_game_class_exist
    assert_instance_of Game, game
  end

  def test_guess_begins_as_nil
    assert_nil game.guess
end
