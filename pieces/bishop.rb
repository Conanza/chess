require_relative "sliding_piece"

class Bishop < SlidingPiece
  def initialize(color, pos, board)
    super
    @symbol = :Bishop
    @display = '♝'.send(@color)
    @slide_dirs = [:diagonal]
  end
end
