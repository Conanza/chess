require 'byebug'

class InvalidMoveError < StandardError
  def message
    'Invalid move.'
  end
end

class Piece
  attr_accessor :symbol, :color, :pos, :moved, :board
  attr_reader :display

  def initialize(color, pos, board)
    @color, @pos, @board = color, pos, board
    @moved = false
  end

  def valid_moves
    # This Applies To All Pieces
    # You can't have a piece between you and the destination.
    # Your destination cannot contain a piece of your color.
    raise NotImplementedError
  end

  def on_board?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end

  def legal_move?(pos)
    @board[pos] == nil || @board[pos].color != @color
  end
end


class SteppingPiece < Piece
  def valid_moves
    results = deltas.map { |delta| [delta[0] + @pos[0] ,delta[1] + @pos[1]] }
    results.select { |pos| legal_move?(pos) && on_board?(pos) }
  end
end

class King < SteppingPiece
  DELTAS = [
    [ 0,  1],
    [ 1,  1],
    [ 1,  0],
    [ 1, -1],
    [ 0, -1],
    [-1, -1],
    [-1,  0],
    [-1,  1]
  ]

  def initialize(color, pos, board)
    super
    @symbol = :King
    @display = '♚'.send(@color)
  end

  def deltas
    DELTAS
  end
end

class Knight < SteppingPiece
  DELTAS = [
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [-2, -1],
    [-2,  1],
    [ 2, -1],
    [ 2,  1]
  ]


  def initialize(color, pos, board)
    super
    @symbol = :Knight
    @display = '♞'.send(@color)
  end

  def deltas
    DELTAS
  end
end

class SlidingPiece < Piece
  CARDINAL_STEPS = [[1, 0],
                    [-1, 0],
                    [0, 1],
                    [0, -1]
                  ]

  DIAGONAL_STEPS = [           # REFORMAT
            [1, 1],
            [1, -1],
            [-1, -1],
            [-1, 1]
          ]

  def valid_moves
    results = []

    results += generate_moves(DIAGONAL_STEPS) if @slide_dirs.include?(:diagonal)
    results += generate_moves(CARDINAL_STEPS) if @slide_dirs.include?(:cardinal)

    results
  end

  def generate_moves(deltas)
    results = []

    deltas.each do |delta|
      current_pos = @pos
      loop do
        current_pos = [current_pos[0] + delta[0], current_pos[1] + delta[1]]
        break unless on_board?(current_pos)
        break if @board.occupied_by_friend?(@color, current_pos)

        results << current_pos
        break if @board.occupied_by_enemy?(@color, current_pos)
      end
    end

    results
  end
end

class Rook < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Rook
    @display = '♜'.send(@color)
    @slide_dirs = [:cardinal]
  end
end

class Bishop < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Bishop
    @display = '♝'.send(@color)
    @slide_dirs = [:diagonal]
  end
end

class Queen < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Queen
    @display = '♛'.send(@color)
    @slide_dirs = [:cardinal, :diagonal]
  end
end

class Pawn < Piece
  ATTACKS = [[1, -1], [1, 1]]

  def initialize(color, pos, board)
    super
    @symbol = :Pawn
    @display = '♟'.send(@color)
  end

  def valid_moves
    get_steps + get_attacks
  end

  def get_steps
    direction = color == :black ? 1 : -1

    results = []
    poss_move = [2 * direction + @pos.first, 0 + @pos.last]
    results << poss_move if !@board.occupied?(poss_move) && !@moved
    poss_move = [1 * direction + @pos.first, 0 + @pos.last]
    results << poss_move unless @board.occupied?(poss_move)

    results
  end

  def get_attacks
    direction = color == :black ? 1 : -1

    poss_attacks = ATTACKS.map do |attack|
      [attack[0] * direction + pos[0], attack[1] + pos[1]]
    end

    poss_attacks.select { |pos| @board.occupied_by_enemy?(@color, pos) }
  end
end
