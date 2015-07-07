require_relative "sliding_piece"

class Rook < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Rook
    @display = '♜'.send(@color)
    @slide_dirs = [:cardinal]
  end
end
