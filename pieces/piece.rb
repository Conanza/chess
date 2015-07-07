class InvalidMoveError < StandardError
end

class Piece
  attr_accessor :pos, :moved
  attr_reader :display, :symbol, :color

  def initialize(color, pos, board)
    @color, @pos, @board = color, pos, board
    @moved = false
  end

  def dup(new_board)
    piece_type = self.class
    position = @pos.dup
    color = @color
    piece_type.new(color, position, new_board)
  end

  def valid_moves
    moves.select { |pos| !move_into_check?(pos) }
  end

  private

    def legal_move?(pos)
      @board[pos].nil? || @board[pos].color != @color
    end

    def move_into_check?(pos)
      new_board = @board.deep_dup
      new_board.move!(@pos, pos)
      new_board.check?(@color)
    end

    def on_board?(pos)
      pos[0].between?(0, 7) && pos[1].between?(0, 7)
    end
end
