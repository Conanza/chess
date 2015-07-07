require_relative "sliding_piece"

class Queen < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Queen
    @display = '♛'.send(@color)
    @slide_dirs = [:cardinal, :diagonal]
  end
end
