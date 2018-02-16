require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test

  def test_it_exists
    game = Game.new

    assert_instance_of Game, game
  end

  def test_guess_starts_as_nil
    game = Game.new

    assert_nil game.guess
  end

  def test_it_can_take_a_guess
    game = Game.new

    assert_equal 33, game.user_guess(33)
  end

  def test_it_handles_high_guess
    game = Game.new

    assert_equal
  end

  # def test_it_handles_low_guess
  #   assert_equal "Too low!",
  # end
end
