require_relative "piece"

class Pawn < Piece
  ATTACKS = [[1, -1], [1, 1]]

  def initialize(color, pos, board)
    super
    @symbol = :Pawn
    @display = '♟'.send(@color)
  end

  def moves
    get_steps + get_attacks
  end

  private

    def forward_dir
      color == :black ? 1 : -1
    end

    def get_attacks
      poss_attacks = ATTACKS.map do |attack|
        [attack[0] * forward_dir + pos[0], attack[1] + pos[1]]
      end.select do |pos|
        on_board?(pos) && @board.occupied_by_enemy?(@color, pos)
      end
    end

    def get_steps
      results = []
      poss_move = [2 * forward_dir + @pos.first, 0 + @pos.last]
      results << poss_move if !@moved && on_board?(poss_move) && !@board.occupied?(poss_move)
      poss_move = [1 * forward_dir + @pos.first, 0 + @pos.last]
      results << poss_move if on_board?(poss_move) && !@board.occupied?(poss_move)

      results
    end
end
