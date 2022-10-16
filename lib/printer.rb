# Handles the printing of elements other than the board and getting variables
module Printer
  def position_selector
    loop do
      print 'Type the position of the piece you want to move: '
      position = gets.chomp
      transformed_position = transform_position_from_user(position)
      piece = @parent.board.board[transformed_position[0]][transformed_position[1]]
      return transformed_position if position_valid?(transformed_position, piece) && @check == false
      return transformed_position if piece.type == 'king' && @check == true
      print 'Invalid selection. Reason: '
      if !transformed_position[0].between?(0, 7) || !transformed_position[1].between?(0, 7)
        print 'Position outside range.'
      elsif piece == '*'
        print 'Space empty.'
      elsif piece.color != @color
        print "Space occupied by opponent's piece."
      elsif piece.possible_moves_with_capture.empty?
        print 'No possible moves.'
      elsif piece.type != 'king' && @check == true
        print "Only the king may be moved in check."
      else
        print 'Unspecified'
      end
      print "\n"
    end
  end

  def transform_position_from_user(position)
    transformed_position = []
    transformed_position << position.slice(1).to_i - 1
    transformed_position << position.slice(0).downcase.ord - 97
  end

  def transform_position_to_user(move)
    transformed_move = ''
    transformed_move += (move[1] + 97).chr
    transformed_move += (move[0] + 1).to_s
  end

  def position_valid?(transformed_position, piece)
    transformed_position[0].between?(0, 7) &&
      transformed_position[1].between?(0, 7) &&
      @parent.board.board[transformed_position[0]][transformed_position[1]] != '*' &&
      @parent.board.board[transformed_position[0]][transformed_position[1]].color == @color &&
      !piece.possible_moves_with_capture.empty?
  end

  def print_transformed_moves(piece)
    print 'You may move to the following positions:'
    piece.possible_moves_with_capture.each do |move|
      transformed_move = transform_position_to_user(move)
      print " #{transformed_move}"
    end
    print "\n"
  end

  def move_selector(piece)
    loop do
      print 'Type the position to which you want to move: '
      move = gets.chomp
      transformed_move = transform_position_from_user(move)
      return transformed_move if piece.moves_ary.include?(transformed_move)

      print "Invalid selection. Not a possible move.\n"
    end
  end

  def transformation_message
    loop do
      print 'Your pawn has reached the last line. Type the piece that you want to transform it into: '
      piece = gets.chomp
      return piece if PIECES.include?(piece)

      print 'Invalid selection. Try again.'
    end
  end

  def check_message
    puts 'Check!'
  end

  PIECES = %w[rook knight bishop queen]
end
