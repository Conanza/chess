require "colorize"
require_relative 'piece'
require "byebug"

class Board
  BASE_ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  ROW_BORDER = "    A  B  C  D  E  F  G  H    "
  COLUMN_BORDER = [' 8 ', ' 7 ', ' 6 ', ' 5 ', ' 4 ', ' 3 ', ' 2 ', ' 1 ']

  def initialize(should_setup = true)
    @board = Array.new(8) { Array.new(8) { nil } }
    setup_board if should_setup
  end

  def display
    puts ROW_BORDER.white.on_black
    @board.each_with_index do |row, i|
      # background = i.even? ? :on_yellow: :on_yellow
      # border = COLUMN_BORDER[i].red.send(background)
      border = COLUMN_BORDER[i].white.on_black
      display_string = border
      row.each_with_index do |space, j|
        color = (i + j).even? ? :on_blue : :on_magenta
        space.nil? ? display_string += '   '.send(color) : display_string += " #{space.display} ".send(color)
      end
      puts "#{display_string + border}"
    end
    puts ROW_BORDER.white.on_black
  end

  def border_string

  end

  def setup_board
    BASE_ROW.each_with_index do |piece, idx|
      @board[0][idx] = piece.new(:black, [0, idx], self)
      @board[7][idx] = piece.new(:white, [7, idx], self)
    end

    8.times { |idx| @board[1][idx] = Pawn.new(:black, [1, idx], self) }
    8.times { |idx| @board[6][idx] = Pawn.new(:white, [6, idx], self) }
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos

    @board[row][col] = value
  end

  def pieces_of(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  def occupied?(pos)
    !self[pos].nil?
  end

  def occupied_by_friend?(my_color, pos)
    occupied?(pos) && self[pos].color == my_color
  end

  def occupied_by_enemy?(my_color, pos)
    occupied?(pos) && self[pos].color != my_color
  end

  def checkmate?(color)
    check?(color) && pieces_of(color).all? { |piece| piece.valid_moves.empty? }
  end

  def where_is_my_king(color)
    @board.flatten.compact.find do |piece|
      piece.is_a?(King) && piece.color == color
    end
  end

  def check?(color)
    king_pos = where_is_my_king(color).pos
    @board.flatten.compact.any? { |piece| piece.moves.include?(king_pos) }
    #return true if tile.is_a?(Piece) && tile.valid_moves.include?(king_pos)
  end

  def deep_dup
    new_board = Board.new(false)

    @board.flatten.compact.each do |piece|
      new_board[piece.pos] = piece.dup(new_board)
    end

    new_board
  end

  def move(start_pos, end_pos)
    #whatever calls this should be damn ready to catch and InvalidMoveError
    piece = self[start_pos]
    if piece.valid_moves.include?(end_pos)
      move!(start_pos, end_pos)
      piece.moved = true
    else
      raise InvalidMoveError
    end
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]

    self[start_pos] = nil
    piece.pos = end_pos
    self[end_pos] = piece
  end
end

b = Board.new(false)
b[[0,0]] = King.new(:white, [0,0], b)
b[[4,7]] = King.new(:black, [4,7], b)
b[[6,1]] = Rook.new(:black, [6,1], b)
b[[7,0]] = Rook.new(:black, [7,0], b)
b[[7,4]] = Rook.new(:white, [7,4], b)
b.display
# puts "Added A Knight"
# p b.check?(:white)
# p b.checkmate?(:white)
