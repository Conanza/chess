require_relative "piece"

class SlidingPiece < Piece
  CARDINAL_STEPS = [
    [ 1,  0],
    [-1,  0],
    [ 0,  1],
    [ 0, -1]
  ]

  DIAGONAL_STEPS = [
    [ 1,  1],
    [ 1, -1],
    [-1, -1],
    [-1,  1]
  ]

  def moves
    results = []

    results += generate_moves(DIAGONAL_STEPS) if @slide_dirs.include?(:diagonal)
    results += generate_moves(CARDINAL_STEPS) if @slide_dirs.include?(:cardinal)

    results
  end

  private

    def generate_moves(deltas)
      results = []

      deltas.each do |delta|
        current_pos = @pos
        loop do
          current_pos = [current_pos[0] + delta[0], current_pos[1] + delta[1]]
          break if !on_board?(current_pos)
          break if @board.occupied_by_friend?(@color, current_pos)

          results << current_pos
          break if @board.occupied_by_enemy?(@color, current_pos)
        end
      end

      results
    end
end
