#
# Ship
# Defines a ship's name and position
#
class Ship
  attr_reader :name, :points, :orientation

  def initialize(name, start_point, length, orientation)
    orient_idx = {h: 0, v: 1}[orientation]
    points = generate_points(start_point, length, orient_idx)
    @name = name
    @points = points.map { |p| [p, :healthy] }.to_h
    @orientation = orientation
  end

  def points
    @points.keys
  end

  def hit(target)
    @points[target] = :damaged if @points.keys.include?(target)
  end

  def damaged_points
    @points.select { |k, v| v == :damaged }.keys
  end

  def sunk?
    points == damaged_points
  end

private

  def generate_points(start_point, length, orient_idx)
    points = (0 ... length).map { |_| [start_point[0], start_point[1]] }
    (0 ... length).each { |c| points[c][orient_idx] += c }
    points
  end
end
