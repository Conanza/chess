require_relative 'board.rb'
require_relative 'keypress.rb'
require "yaml"

class InvalidGuessError < StandardError
end

class NoPieceError < StandardError
end

class WrongColorError < StandardError
end

class Game
  def initialize(player1, player2)
    @board = Board.new
    @player1 = player1.new(:white, @board)
    @player2 = player2.new(:black, @board)
    @current_player = @player1
  end

  def play
    system("clear")
    @board.display
    sleep(1)
    until @board.checkmate?(@current_player.color)
      update_message(" #{current_color}, please make your move.")
      begin
        start_pos, end_pos = @current_player.get_move

        if start_pos == "save"
          update_message("  Game Saved. Come back soon! ")

          File.open("chess_game.yml", "w") do |f|
            f.puts(self.to_yaml)
          end

          exit 0
        end

        raise NoPieceError if @board[start_pos].nil?
        raise WrongColorError if @board[start_pos].color != @current_player.color

        @board.move(start_pos, end_pos)
      rescue NoPieceError
        update_message("  Pick a square with a piece. ")
        retry
      rescue WrongColorError
        update_message("  Please move a #{current_color} piece.  ")
        retry
      rescue InvalidMoveError
        update_message("   That is not a valid move.  ")
        retry
      end

      system("Clear")
      switch_current_player
      @board.display
    end

    switch_current_player
    update_message("     Game Over. #{current_color} won!     ")
  end

  def update_message(string)
    @board.message_row = string
    system "clear"
    @board.display
  end

  private

    def current_color
      @current_player.color.to_s.capitalize
    end

    def switch_current_player
      @current_player = @current_player == @player1 ? @player2 : @player1
    end


end

class HumanPlayer
  COLUMN_HASH = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }

  ROW_HASH = {
    '8' => 0,
    '7' => 1,
    '6' => 2,
    '5' => 3,
    '4' => 4,
    '3' => 5,
    '2' => 6,
    '1' => 7
  }

  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  # def get_move_o
  #   begin
  #     input = gets.downcase.chomp
  #     unless input.length == 5 && input =~ /\A[a-h][1-8] [a-h][1-8]\z/
  #       raise InvalidGuessError.new #so we don't need the new?
  #     end
  #   rescue InvalidGuessError
  #     puts "Please format like this example: e4 a4"
  #     retry
  #   end
  #   parse_input(input)
  # end

  def get_move
    @start_pos, @end_pos = nil, nil
    until !@start_pos.nil? && !@end_pos.nil?
      parse_char(read_char)
    end
    [@start_pos, @end_pos]
  end

  def parse_char(input)
    case input
    when "\r" # Enter
       @start_pos.nil? ? @start_pos = @board.cursor : @end_pos = @board.cursor
    when "\e" || "\u0003" # Escape or ctr c
      exit 0
    when "\e[A" # Up
      pos_cursor = [@board.cursor[0] - 1, @board.cursor[1]]
      @board.cursor = pos_cursor if on_board?(pos_cursor)
    when "\e[B" # Down
      pos_cursor = [@board.cursor[0] + 1, @board.cursor[1]]
      @board.cursor = pos_cursor if on_board?(pos_cursor)
    when "\e[C" # Right
      pos_cursor = [@board.cursor[0], @board.cursor[1] + 1]
      @board.cursor = pos_cursor if on_board?(pos_cursor)
    when "\e[D" # Left
      pos_cursor = [@board.cursor[0], @board.cursor[1] - 1]
      @board.cursor = pos_cursor if on_board?(pos_cursor)
    when "\177" # Backspace
      @start_pos = nil
    when "s"
      @start_pos, @end_pos = "save", "also save"
    end

    system "clear"
    @board.display
  end

  private

    def on_board?(pos)
      pos[0].between?(0, 7) && pos[1].between?(0, 7)
    end

    def parse_input(input)
      start, fin = input.split
      [
        [to_row(start[1]), to_column(start[0])],
        [to_row(fin[1]), to_column(fin[0])]
      ]
    end

    def to_column(char)
      COLUMN_HASH[char]
    end

    def to_row(char)
      ROW_HASH[char]
    end
end

if $PROGRAM_NAME == __FILE__
  if ARGV[0].nil?
    chess = Game.new(HumanPlayer, HumanPlayer)
    chess.play
  else
    filename = ARGV.shift
    game = YAML.load_file(filename)
    game.update_message("         Welcome back!        ")
    game.play
  end
end
