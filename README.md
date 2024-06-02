# Chess

This is the Ruby Final Project for the [Odin Project](https://www.theodinproject.com/lessons/ruby-ruby-final-project).

## Some resources

- [Rules](https://www.chessvariants.org/d.chess/chess.html)

- [Chess Notation](https://en.wikipedia.org/wiki/Chess_notation)

## Requirements

- Build a command line Chess game where two players can play against each other.

- The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.

- Make it so you can save the board at any time (remember how to serialize?)

- Write tests for the important parts. You don’t need to TDD it (unless you want to), but be sure to use RSpec tests for anything that you find yourself typing into the command line repeatedly.

- Do your best to keep your classes modular and clean and your methods doing only one thing each. This is the largest program that you’ve written, so you’ll definitely start to see the benefits of good organization (and testing) when you start running into bugs.

- Have fun! Check out the unicode characters for a little spice for your gameboard.

### Extra credit

- Build a very basic AI computer player (perhaps who does a random legal move).

## Initial plan of action and some notes

[Done] Will use RSpec to test the units.

[Done] Also will practice Git, developing on a separate branch, adding new features on features branches and then merging using the rebase workflow.

Chess notation is saved as: "1. Bb5 a6", "2. d3 Bb4+", each row contains the white and black move with the piece and destination, along with other information. Therefore game history + state can be saved in one long 2D array: [["first white move", "first black move"],["second", "second"],["third", "third"]]. If the chess engine goes through the list and makes the move, you will arrive at the current state of the game (save/load game).

[Done] A #render method will render the gameboard with the symbols. Rendering is easy, but the current game board also has to be saved somewhere, such as a 8x8 array, where each element can contain a piece.

[Done]  New game generates all pieces (objects of classes) for both players, sets board position for them and initialises the history of moves.

[Done] The game engine keeps track of the history of moves, starting at zero: first turn, white move, then black.

[Done] Input can be from the user simply: 1. Piece (B, N, R...), 2. Destination.

[Done] Pieces can each be separate classes with a main class Chesspiece that gives them basic behaviour, such as color, position on the board. Each piece then has its class with special #move method and special behaviour.

## To do

[ ] Castling for kings

[ ] Promoting a pawn

[ ] Stalemate checks

[ ] Save and load PGN format

[ ] Tie "1/2-1/2"

### Rules to consider

Movement of the pieces:

1. Rook
  1.1. Moves in a straight line, horizontally or vertically.
  1.2. Squares between start and end must be empty.
  1.3. If an opponent piece is on the end square, it is taken.

2. Bishop
  1.1. Moves in diagonal lines.
  1.2. Cannot jump over other pieces.
  1.3. If an opponent piece is on the end square, it is taken.

3. Queen
  1.1. Moves straight and in diagonal.
  1.2. Cannot jump over other pieces.
  1.3. If an opponent piece is on the end square, it is taken.

4. Knight
  1.1. Makes a move constisting of one step straight, then one in diagonal.
  1.2. Knight jumps over other pieces.

5. Pawn
  1.1. Usually moves one space forward.
  1.2. First move can be two spaces forward.
  1.3. Taking, pawn moves one space diagonally.
  1.4. Special rule *en-passant* - when a pawn makes a double step from the second row to the fourth row, and there is an enemy pawn on an adjacent square on the fourth row, then this enemy pawn inthe next move may move diagonally to the square that was passed over by the double-stepping pawn, which is on the third row. In this same move, the double-stepping pawn is taken. This taking en-passant must be done directly: if the player who could take en-passant does not do this in the first move after the double step, this pawn cannot be taken anymore by an en-passant move.
  1.5. Special rule *promote* - reaching the last row, pawn is replaced by a queen, rook, knight or bishop.

6. King
  1.1. Moves one square in any direction.
  1.2. Special move *castling*:
    1.1.1. The king that makes the castling move has not yet moved in the game.
    1.1.2. The rook that makes the castling move has not yet moved in the game.
    1.1.3. The king is not in check.
    1.1.4. When castling, there may not be an enemy piece that can move to a square that is moved over by the king.
    1.1.5. You may not castle and end the move with the king in check.
    1.1.6. All squares between the rook and king before the castling move are empty.
    1.1.7. King and rook occupy the same row.

There are some game over conditions:

1. Mate (player is checked so that he cannot move away)

2. Stalemate (player is not checked, but cannot make any legal move)

---

Loading the game from .pgn format

First, read in the information
1) The metadata can go into a hash
2) The game string needs to be parsed

Split the string at numbers 1., 2., 18. etc.

Each turn will contain one or two symbols:
1. d4 d5 
2. f3 Qd6
3. Bh6  Qxh6 
4. Qd3  Qc1+ 
5. Qd1 Qxd1+

History array:
[["d4", "d5"], ["f3", "Qd6"], ["Bh6", "Qxh6"], ["Qd3", "Qc1+"], ["Qd1", "Qxd1+"]]

PGN:
1. d4 d5 2. f3 Qd6 3. Bh6  Qxh6 4. Qd3  Qc1+ 5. Qd1 Qxd1

*Reminder:*
    # Special events:
    # 0-0: kingside castle
    # 0-0-0: queenside castle
    # 1-0 or 0-1: white wins, black wins

    # Appended:
    # x: captures
    # +: check
    # #: checkmate

    # Pieces:
    #  :  pawn (no symbol)
    # R:  rook
    # B:  bishop
    # N:  knight
    # Q:  queen
    # K:  king
