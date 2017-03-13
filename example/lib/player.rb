require 'errors'

class Player
  attr_reader :name, :ships, :misses

  def initialize(name)
    @name = name
    @ships = []
    @misses = []
  end

  def lost?
    @ships.select { |ship| ship.sunk? }.any?
  end

  def add_ship(ship)
    # Find all the ships which occupy the same points as the one
    # you're trying to add (& finds the common items between two lists)
    collisions = @ships.reject { |other| (other.points & ship.points).empty? }
    if collisions.any?
      raise Errors::ShipPlacementError.new(
        "#{ship.name} would collide with #{collisions.map(&:name).join(' and ')}!"
      )
    end
    @ships.push(ship)
  end

  def attack(target)
    ships.map { |ship| ship.hit(target) }.include?(:damaged)
  end
end
