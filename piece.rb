require 'byebug'

class InvalidMoveError < StandardError
  def message
    'Invalid move.'
  end
end

class Piece
  attr_accessor :symbol, :color, :pos, :moved, :board

  def initialize(color, pos, board)
    @color, @pos, @board = color, pos, board
    @moved = false
  end

  def move(destination)
    # if valid_moves.include?(destination)
      @board[@pos] = nil
      @pos = destination
      @board[destination] = self
    # else
    #   raise InvalidMoveError
    # end
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
    @symbol = :K
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
    @symbol = :H
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
    @symbol = :R
    @slide_dirs = [:cardinal]
  end
end

class Bishop < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :B
    @slide_dirs = [:diagonal]
  end
end

class Queen < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Q
    @slide_dirs = [:cardinal, :diagonal]
  end
end

class Pawn < Piece
  ATTACKS = [[1, -1], [1, 1]]

  BLACK_STEPS =[
    [2, 0],
    [1, 0],
    [1, -1],
    [1, 1]
  ]

  WHITE_STEPS = [
    [-2, 0],
    [-1, 0],
    [-1, -1],
    [-1, 1]
  ]

  def initialize(color, pos, board)
    super
    @symbol = :P
    @delta = color == :black ? BLACK_STEPS : WHITE_STEPS
  end

  def valid_moves
    my_delta = @moved ? @delta.shift : @delta

    results = []

    case

    poss_move = [@delta[0][0] + @pos.first, @delta[0][1] + @pos.last]
    results << poss_move unless @board.occupied?(poss_move) && !@moved
    poss_move = [@delta[1][0] + @pos.first, @delta[1][1] + @pos.last]
    results << poss_move unless @board.occupied?(poss_move)
    poss_move = [@delta[2][0] + @pos.first, @delta[2][1] + @pos.last]
    results << poss_move if @board.occupied_by_enemy?(@color, poss_move)
    poss_move = [@delta[3][0] + @pos.first, @delta[3][1] + @pos.last]
    results << poss_move if @board.occupied_by_enemy?(@color, poss_move)



    # if moved = false, jump step is valid
    # otherwise:
      # if unoccupied for forwards
      # diagonals: only if diagonal occupied by enemy
  end
end
