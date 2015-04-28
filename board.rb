require "colorize"
require_relative 'piece'

class Board
  def initialize
    @board = Array.new(8) { Array.new(8) { nil } }
  end

  def display
    @board.each_with_index do |row, i|
      display_string = ""
      row.each do |space|
        space.nil? ? display_string += '_ ' : display_string += space.symbol.to_s + " "
      end
      puts "#{display_string}\n"
    end
  end

  # def self.setup_board
  #   row_of_pawns = [pawns, pawns]
  #   other_row
  #
  #
  #   @board[1] = row_of_pawns
  #
  #
  # end

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

  end

  def deep_dup

  end
end

puts "Cat".red.on_blue
puts "♔ ".red.on_blue
puts "♔ ".blue

b = Board.new
pos = [1,1]
b[[2, 0]] = King.new(:black, [2, 0], b)
b[[5, 5]] = King.new(:white, [5, 5], b)

b[pos] = Queen.new(:black, pos, b)
# p b[pos].valid_moves

b[[2,2]] = Pawn.new(:white, [2,2], b)
p b[[2,2]].valid_moves
# b.display
# k = King.new(:w, [4,4], b)
# b[[1,1]]
#
#
# k.move([5,5])
# puts
# b.display
# k.move([3, 3])
# puts
# b.display
#
# puts "I am a string!".on_red
# k.valid_moves
