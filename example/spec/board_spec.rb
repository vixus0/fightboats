require 'board'
require 'errors'

RSpec.describe Board do
  let (:board) { Board.new(10, 10) }

  context '.point' do
    it 'should turn user input into a Point object' do
      point = board.point('A5')
      expect(point[0]).to eql(0)
      expect(point[1]).to eql(4)

      point = board.point('b2')
      expect(point[0]).to eql(1)
      expect(point[1]).to eql(1)
    end

    it 'should raise an error on invalid input' do
      expect { board.point('Z9') }.to raise_error('Z9 is not a valid coordinate!')
      expect { board.point('B12') }.to raise_error('B12 is not a valid coordinate!')
      expect { board.point('9') }.to raise_error('9 is not a valid coordinate!')
      expect { board.point('8T') }.to raise_error('8T is not a valid coordinate!')
    end
  end

  context '.ship' do
    it 'should create a Ship object with the correct position vertically' do
      destroyer = board.ship('destroyer', [0,0], 4, :v)
      expect(destroyer.points).to eql([
        [0, 0],
        [0, 1],
        [0, 2],
        [0, 3]
      ])
    end

    it 'should create a Ship object with the correct position vertically' do
      destroyer = board.ship('destroyer', [0,0], 4, :h)
      expect(destroyer.points).to eql([
        [0, 0],
        [1, 0],
        [2, 0],
        [3, 0]
      ])
    end

    it 'should raise an error for incorrect placement' do
      expect { board.ship('destroyer', [0,8], 4, :v) }.to raise_error(
        Errors::ShipPlacementError
      )
    end
  end
end
