# Class to handle interaction with players
class Player
  include Printer

  attr_accessor :color, :check

  def initialize(color, parent)
    @color = color
    @parent = parent
    @check = false
  end

  def move_piece
    if @check == true && mate?
      @parent.mate = true
      @parent.mated_color = @color
      return
    end
    selected_position, piece = select_piece
    process_possible_moves(selected_position, piece)
    process_move(selected_position, piece)
    @check = false
    handle_check if check?(piece)
  end

  def select_piece
    selected_position = position_selector
    piece = @parent.board.board[selected_position[0]][selected_position[1]]
    [selected_position, piece]
  end

  def process_possible_moves(selected_position, piece)
    possible_moves = piece.possible_moves_with_capture
    @parent.board.print_board(selected_position, possible_moves)
    print_transformed_moves(piece)
  end

  def process_move(selected_position, piece)
    selected_move = move_selector(piece)
    @parent.board.board[selected_position[0]][selected_position[1]] = '*'
    @parent.board.board[selected_move[0]][selected_move[1]] = piece
    piece.position = selected_move
    piece.remove_excess_pawn_moves
    piece.handle_pawn_transformation
    @parent.board.print_board
  end

  def check?(piece)
    piece.possible_moves_with_capture
    piece.moves_ary.each do |move|
      @space = @parent.board.board[move[0]][move[1]]
      return true if @space.instance_of?(Piece) && @space.type == 'king' && @space.color != @color
    end
    false
  end

  def handle_check
    check_message
    @parent.determine_checked_player(self)
  end

  def mate?
    kings = @parent.board.pieces_ary.select { |piece| piece.type == 'king' }
    player_king = kings.find { |king| king.color == @color }
    return true if player_king.possible_moves_with_capture.empty?

    false
  end
end
