require_relative 'board.rb'

class InvalidGuessError < StandardError
end

class WrongColorError < StandardError
end

class Game
  def initialize(player1, player2)
    @board = Board.new
    @player1, @player2 = player1, player2
    @current_player = player1
  end

  def play
    @board.display
    until @board.checkmate?(@current_player.color)
      puts "#{current_color}, please make your move."
      begin
        start_pos, end_pos = @current_player.get_move
        if @board[start_pos].color != @current_player.color
          raise WrongColorError.new #so we don't need the new?
        end
        @board.move(start_pos, end_pos)
      rescue WrongColorError
        puts "You may only move #{current_color} pieces."
        retry
      rescue InvalidMoveError
        puts "That is not a valid move."
        retry
      end

      switch_current_player
      @board.display
    end

    switch_current_player
    puts "Game Over. #{current_color} won!"
  end

  def switch_current_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def current_color
    @current_player.color.to_s.capitalize
  end
end

class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move()

  end
end

class HumanPlayer < Player
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

  def get_move
    begin
      input = gets.downcase.chomp
      unless input.length == 5 && input =~ /\A[a-h][1-8] [a-h][1-8]\z/
        raise InvalidGuessError.new #so we don't need the new?
      end
    rescue InvalidGuessError
      puts "Please format like this example: e4 a4"
      retry
    end
    parse_input(input)
  end

  def parse_input(input)
    start, fin = input.split
    [
      [to_row(start[1]), to_column(start[0])],
      [to_row(fin[1]), to_column(fin[0])]
    ]
  end

  def to_row(char)
    ROW_HASH[char]
  end

  def to_column(char)
    COLUMN_HASH[char]
  end


end

chess = Game.new(HumanPlayer.new(:white), HumanPlayer.new(:black))
chess.play
