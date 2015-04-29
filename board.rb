require "colorize"
require_relative 'piece'

class Board
  BASE_ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  def initialize
    @board = Array.new(8) { Array.new(8) { nil } }
    #setup_board
  end

  def display
    @board.each_with_index do |row, i|
      display_string = ""
      row.each_with_index do |space, j|
        color = (i + j).even? ? :on_blue : :on_magenta
        space.nil? ? display_string += '   '.send(color) : display_string += " #{space.display} ".send(color)
      end
      puts "#{display_string}\n"
    end
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

  def on_board?

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

  def piece_at(pos)

  end

  def checkmate?(color)

  end

  def check?(color)
    false
  end

  def deep_dup
    new_board = Board.new

    @board.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        if !tile.nil?
          piece_type = tile.class
          position = tile.pos
          color = tile.color
          tile_copy = piece_type.new(color, position, new_board)
          new_board[[i, j]] = tile_copy
        end
      end
    end

    new_board
  end

  def move(start_pos, end_pos)
    #whatever calls this should be damn ready to catch and InvalidMoveError
    piece = self[start_pos]

    if piece.valid_moves.include?(end_pos)
      new_board = deep_dup
      new_board.move!(start_pos, end_pos)
      if !new_board.check?(piece.color)
        move!(start_pos, end_pos)
      end
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

b = Board.new

5.times { |i| b[[i,i]] = Pawn.new(:white, [i,i], b)}


b.display
p b[[4,4]].valid_moves
p b.object_id


puts
d = b.deep_dup

d[[3,5]] = Pawn.new(:black, [4,6], d)
d.display
p d[[4,4]].valid_moves
p d.object_id
puts

p b[[4,4]].valid_moves
p d[[4,4]].valid_moves

d.move([4,4],[3,3])
d.display
