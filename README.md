# Ruby Chess

A ruby version of chess. Currently the project is a work in progress any many features are not present.

This readme file will be updated once the project is finished.

## How to play?

This aims to follow the standard rules of chess available on https://www.fide.com/FIDE/handbook/LawsOfChess.pdf.

The players input their moves by first choosing the piece to move and then typing
in the desired space using standard algebraic notation.

Currently the following special moves are supported:
  1. promotion
  
Currently the following special moves are **not** supported (they will be added in the future):
  1. castling
  2. *en passant*
  
  The game ends when one of the kings is in check and cannot make any valid moves. 
  
  Currently any other game endings are **not** supported (they will be added in the future).
  
  ## Saving and loading
  
  The game may be loaded at the beginning when the player is asked to choose.
  
  At any point during the game, the player can save by typing 'save' instead of their move. The savefiles are stored 
  in the human-readable YAML format in the 'saves' directory. They may be manually edited to recreate challenes or 
  moved between devices.
  
  ## Bugs and feautures suggestions
  
  Any bugs may be reported and feature suggestions presented with the use of issue functionality of GitHub.
