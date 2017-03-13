class Visuals
  WATER = '░'

  SHIP_TL = '╭'
  SHIP_TR = '╮'
  SHIP_BL = '╰'
  SHIP_BR = '╯' 

  SIDES = {
    h: '━',
    v: '┃'
  }

  HIT = '#'
  MISS = '♨'

  def initialize(board)
    @board = board
  end

  def draw_game_board(player, opponent)
    player_board = water
    player.ships.each do |ship|
      player_board = plot_ship(player_board, ship)
      ship.damaged_points.each { |point| player_board = put_chars(player_board, point, [HIT*2]*2) }
    end
    opponent.misses.each { |point| player_board = put_chars(player_board, point, [MISS*2]*2) }

    opponent_board = water
    opponent.ships.flat_map(&:damaged_points).each do |point|
      opponent_board = put_chars(opponent_board, point, [HIT*2]*2)
    end
    player.misses.each { |point| opponent_board = put_chars(opponent_board, point, [MISS*2]*2) }

    draw_boards(player_board, opponent_board)
  end

  def draw_player_board(player)
    board = water
    player.ships.each { |ship| board = plot_ship(board, ship) }
    draw_boards(board)
  end

  def draw_boards(*boards)
    lines = boards.first.zip(*boards[1 .. -1]).map { |*lines| lines.join('   ┋   ') }
    gap = 4
    x_coords = (' '*gap) + ('A' .. 'Z').map { |x| x.ljust(2) }[0 ... @board.width].join()
    y_lines = lines.each_with_index.map do |line, y|
      text = (y % 2 == 0) ? (y/2+1).to_s : ''
      "#{text.ljust(gap)}#{line}"
    end
    $stdout.write(([x_coords] + y_lines).join("\n"))
    $stdout.write("\n\n")
  end

private

  def put_chars(lines, point, chars)
    if point.empty?
      return lines
    end
    x, y = point
    lines[y*2][x*2 ... (x+1)*2] = chars[0]
    lines[y*2+1][x*2 ... (x+1)*2] = chars[1]
    lines
  end

  def plot_ship(lines, ship, tl_chr = SHIP_TL, tr_chr = SHIP_TR, bl_chr = SHIP_BL, br_chr = SHIP_BR, side_chr = SIDES)
    # Draw the sides of the ships
    side = side_chr[ship.orientation]
    ship.points.each do |point|
      lines = put_chars(lines, point, [side * 2] * 2)
    end
    # Draw the ends of the ships
    if ship.orientation == :h
      bow_chars = ["#{tl_chr}#{side}", "#{bl_chr}#{side}"]
      stern_chars = ["#{side}#{tr_chr}", "#{side}#{br_chr}"]
      lines = put_chars(lines, ship.points.first, bow_chars)
      lines = put_chars(lines, ship.points.last, stern_chars)
    elsif ship.orientation == :v
      bow_chars = ["#{tl_chr}#{tr_chr}", "#{side}#{side}"]
      stern_chars = ["#{side}#{side}", "#{bl_chr}#{br_chr}"]
      lines = put_chars(lines, ship.points.first, bow_chars)
      lines = put_chars(lines, ship.points.last, stern_chars)
    end
    lines
  end

  def water(w_chr = WATER)
    (0 ... @board.height*2).map { |_| w_chr * @board.width * 2 }
  end
end
