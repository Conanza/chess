require_relative "stepping_piece"

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
