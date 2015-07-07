require_relative "piece"

class SteppingPiece < Piece
  def moves
    results = deltas.map { |delta| [delta[0] + @pos[0], delta[1] + @pos[1]] }
    results.select { |pos|  on_board?(pos) && legal_move?(pos) }
  end
end
