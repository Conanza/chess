class InvalidGuessError < StandardError
end

input = ''
begin
  input = gets.upcase.chomp
  unless input.length == 4 && input =~ /^[RGBYOP]*$/
    raise InvalidGuessError.new
  end
rescue InvalidGuessError
  puts "Please type in 4 of the following: R, G, B, Y, o or P."
  retry
end
p input
