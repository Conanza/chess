require_relative 'board.rb'

class Game
  def initialize(player1, player2)
    @board = Board.new
    @player1, @player2 = player1, player2
    @current_payer = player1
  end

  def play
    until @board.checkmate?(@current_player.color)
      @current_player.make_move


      switch_current_player
    end

    switch_current_player
    puts "Game Over. #{@current_player.color} won!"
  end

  def switch_current_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

end

class Player
  def initialize(color)
    @color = color
  end

  def make_move
    puts "#{@current_player.color} make your move."
    
    begin
      input = gets.upcase.chomp
      unless input.length == 4 && input =~ /^[RGBYOP]*$/
        raise InvalidGuessError.new
      end
    rescue InvalidGuessError
      puts "Please type in 4 of the following: R, G, B, Y, o or P."
      retry
    end
  end
end

class HumanPlayer

end
