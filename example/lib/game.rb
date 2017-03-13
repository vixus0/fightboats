require 'board'
require 'errors'
require 'player'
require 'visuals'

class Game
  BOARD = Board.new(10, 10)
  SHIPS = {
    'carrier' => 5,
    'battleship' => 4,
    'submarine' => 3,
    'destroyer' => 3,
    'patrol' => 2,
  }

  def self.prepared
    players = ['Alice', 'Bert'].map do |name|
      Player.new(name).tap do |p|
        SHIPS.each_with_index { |ship, i| p.add_ship(BOARD.ship(ship[0], [i, 0], ship[1], :v)) }
      end
    end
    self.new(players)
  end

  def initialize(players = [], board = BOARD)
    @board = board
    @visuals = Visuals.new(@board)
    @players = players
    @turns = 0

    if @players.empty?
      ['one', 'two'].each do |p|
        clear
        puts
        puts "Hi, player #{p}."
        @players.push(add_player)
      end
    end

    clear
    puts "Let the games begin! Hand the computer to #{@players.first.name}."
    wait('Hit ENTER when you are ready to play.')

    while in_play?
      @player = @players[@turns % 2]
      @opponent = @players[(@turns+1) % 2]
      boards_puts("Turn #{@turns}: Here we go, #{@player.name}!")
      target, target_point = prompt_position('Where are you going to aim? [A1]')
      successful_shot = fire_at(@opponent, target)
      if successful_shot
        boards_puts("Excellent shot, #{@player.name}. Direct hit!")
      else
        @player.misses.push(target_point)
        boards_puts("Looks like we failed to hit anything...")
      end
      wait
      clear
      puts 'Your turn is done. Hand it to your opponent.' 
      wait("If you are #{@opponent.name}, hit ENTER to start your turn.")
      @turns += 1
    end 

    winner = @players.reject(&:lost?)
    boards_puts("★★★ Congratulations, #{winner.name}, you've won the game! ★★★")
    wait('Hit ENTER to quit.')
  end

private

  def in_play?
    @players.select(&:lost?).empty?
  end

  def fire_at(opponent, target)
    puts 'FIRE!'
    success = opponent.attack(@board.point(target))
  rescue Errors::BadInputError => e
    puts e.message
    retry
  end

  def prompt_position(msg)
    begin
      position = prompt(msg)
      [position, @board.point(position)]
    rescue Errors::BadInputError => e
      puts e.message
      retry
    end
  end

  def prompt_orientation(msg)
    orientation = nil
    valid = ['h', 'v']
    until valid.include?(orientation)
      orientation = prompt(msg)
    end
    orientation
  end

  def add_player
    name = prompt('What is your name?')
    player = Player.new(name)
    clear
    @visuals.draw_player_board(player)
    SHIPS.each do |type, length|
      begin
        input, position = prompt_position("Where do you want to place your #{type}? [A1]")
        orientation = prompt_orientation('What orientation? [h/v]').to_sym
        ship = @board.ship(type, position, length, orientation)
        player.add_ship(ship)
      rescue Errors::ShipPlacementError => e
        orient_str = {h: 'horizontal', v: 'vertical'}[orientation]
        puts "Can't place #{type} at #{input} with a #{orient_str} orientation!"
        puts " - #{e.message}"
        retry
      end
      clear
      @visuals.draw_player_board(player)
    end 
    wait
    player
  end

  def prompt(msg)
    print("#{msg} ")
    gets.chomp
  end

  def wait(msg = 'Hit ENTER to continue.')
    prompt(msg)
    clear
  end

  def clear
    system('clear')
  end

  def boards_puts(msg)
    clear
    @visuals.draw_game_board(@player, @opponent)
    puts(msg)
  end
end
