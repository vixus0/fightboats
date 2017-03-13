#
# Board:
# Encapsulate everything that involves the game board, which defines the
# width and height of the grid. Parsing user input into coordinates and
# placing ships on the board will require bounds checking, so we can do
# that here.
#

require 'errors'
require 'ship'

class Board
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def point(input)
    if input.empty?
      raise Errors::BadInputError.new("Please input something.")
    end

    # Split up the user input
    alphabet = ('a'..'z').map(&:to_s).join('')
    letter = input[0]
    digits = input[1 .. -1]

    # Turn A1 notation into a pair of integers
    x = alphabet.index(letter.downcase)
    y = digits.to_i - 1

    # If someone tries to use a grid position off the edge of the grid,
    # complain about it.
    if x.nil? || width < x || height < y || y < 0
      raise Errors::BadInputError.new("#{input} is not a valid coordinate!")
    end

    # Finally, return the new point
    [x, y]
  end

  def ship(name, start_point, length, orientation)
    # Make the rest of our calculations simpler (no ifs)
    orient_idx = {h: 0, v: 1}[orientation]
    dimensions = [width, height]
    
    # Check if we can place the ship where the user wants
    start_point_ok = (start_point[orient_idx] + length) <= dimensions[orient_idx]

    if start_point_ok == false 
      raise Errors::ShipPlacementError.new("#{name} would go off the edge of the board!")
    end

    Ship.new(name, start_point, length, orientation)
  end
end
