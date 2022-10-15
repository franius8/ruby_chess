# Handles the printing of the board

module BoardPrinting
  def print_board(position = [], moves = [])
    print_letters
    print_divider
    print_rows_with_numbers(position, moves)
    print_letters
  end

  def print_divider
    1..3.times { print ' ' }
    1..33.times { print '-' }
    print "\n"
  end

  def print_letters
    letter = 'a'
    1..5.times { print ' ' }
    1..8.times do
      print "#{letter}   "
      letter = letter.next
    end
    print "\n"
  end

  def print_rows_with_numbers(position, moves)
    number = 1
    @board.each_index do |row|
      print " #{number} |"
      @board[row].each_index do |space|
        if @board[row][space].instance_of?(String) && moves.include?([row, space])
          print '   '.colorize(color: :white, background: :light_blue)
          print '|'
        elsif board[row][space] == '*'
          print '   |'
        elsif moves.include?([row, space])
          print " #{@board[row][space].symbol} ".colorize(color: :white, background: :magenta)
          print '|'
        elsif position == @board[row][space].position
          print " #{@board[row][space].symbol} ".colorize(color: :white, background: :red)
          print '|'
        else
          print " #{@board[row][space].symbol} |"
        end
      end
      print " #{number}"
      print "\n"
      print_divider
      number += 1
    end
  end
end
