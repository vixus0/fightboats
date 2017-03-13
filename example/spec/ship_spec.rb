require 'ship'

RSpec.describe Ship do
  let (:occupied_points) {
    [
      [2, 3],
      [3, 3],
      [4, 3],
      [5, 3]
    ]
  }

  let (:ship) {
    Ship.new('noahs_ark', occupied_points.first, 4, :h)
  }

  it 'should have a name' do
    expect(ship.name).to eql('noahs_ark')
  end

  it 'should have an orientation' do
    expect(ship.orientation).to eql(:h)
  end

  it 'should correctly know the grid points it occupies' do
    expect(ship.points).to eql(occupied_points)
  end

  it 'should register a successful hit' do
    ship.hit([2,3])
    expect(ship.damaged_points).to eql([[2,3]])
  end

  it 'should not register misses' do
    ship.hit([2,4])
    expect(ship.damaged_points).to eql([])
  end

  it 'should tell if it has sunk' do
    (2 .. 5).each { |x| ship.hit([x,3]) }
    expect(ship.sunk?).to eql(true)
  end
end
