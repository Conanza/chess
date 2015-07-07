require_relative "stepping_piece"

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
