# frozen_string_literal: true

# Handles the printing of elements other than the board and getting variables from the player
module Printer
  def load_saved_game?
    print 'Do you want to load a saved game? Type Y to load, anything else to play a new game: '
    return true if gets.chomp.downcase == 'y'
  end

  def collect_loadfile_name
    loop do
      print 'Enter the name of the save to load (case insensitive): '
      loadfile_name = gets.chomp.downcase
      return loadfile_name if File.exist?(loadfile_name)

      puts 'No file found. Try again'
    end
  end

  def no_directory_message
    puts 'No saves directory found.'
  end

  def collect_and_check_savefile_name
    loop do
      print 'Enter the name of your save. Only letters are allowed up to 12 characters (case insensitive): '
      savefile_name = gets.chomp.downcase
      return savefile_name if savefile_name_valid?(savefile_name)

      puts 'Incorrect save name. Enter it again.'
    end
  end

  def succesful_save_message
    puts 'Game saved succesfully.'
  end

  def message_before_move(player)
    puts "Turn of the #{player.color} player."
  end

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
        print 'Only the king may be moved in check.'
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
    piece.possible_moves_with_capture.uniq.sort.each do |move|
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
    print "+-------------------------------------+\n"
    print "|               Check!                |\n"
    print "+-------------------------------------+\n"
  end

  def mate_message(mated_color)
    print "+-------------------------------------+\n"
    print "|               Mate!                 |\n"
    print "+-------------------------------------+\n"
    print "The game ended with a mate and #{mated_color} lost."
  end

  PIECES = %w[rook knight bishop queen].freeze
end
