require 'player'

RSpec.describe Player do
  let (:submarine) { 
    instance_double('Ship',
      points: [[1,1], [2,1], [3,1], [4,1]],
      name: 'submarine',
      orientation: :h
    ) 
  }
  let (:destroyer) { 
    instance_double('Ship',
      points: [[2,0], [2,1], [2,2], [2,3]],
      name: 'destroyer',
      orientation: :v
    ) 
  }
  let (:patrol) { 
    instance_double('Ship',
      points: [[2,2], [3,2]],
      name: 'patrol',
      orientation: :h
    ) 
  }


  it 'should store the player name' do
    player = Player.new('Jenny')
    expect(player.name).to eql('Jenny')
  end

  context '.add_ship' do
    it 'should allow you to add a ship' do
      player = Player.new('Tabitha')
      player.add_ship(submarine)
      expect(player.ships).to eql([submarine])
    end

    it 'should check for collisions' do
      player = Player.new('Tabitha')
      player.add_ship(submarine)
      player.add_ship(patrol)
      expect { player.add_ship(destroyer) }.to raise_error(
        'destroyer would collide with submarine and patrol!'
      )
      expect(player.ships).to eql([submarine, patrol])
    end
  end

  it 'should know if all the ships have sunk' do
    allow(submarine).to receive(:sunk?).and_return(true)
    player = Player.new('Tabitha')
    player.ships.push(submarine)
    expect(player.lost?).to eql(true)
  end
end
