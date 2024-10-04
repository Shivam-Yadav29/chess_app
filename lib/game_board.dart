import 'package:flutter/material.dart';
import 'package:chess_app/components/dead_piece.dart';
import 'package:chess_app/components/piece.dart';
import 'package:chess_app/components/square.dart';
import 'package:chess_app/helper/helper_methods.dart';
import 'package:chess_app/components/app_bar.dart';
import 'package:chess_app/helper/chess_logic.dart';
import 'package:chess_app/helper/board_initializer.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //A 2-d list representing the chessboard
  late List<List<ChessPiece?>> board;

  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;

  // list of valid moves of selected piece
  List<List<int>> validMoves = [];
  // A list of white pieces that have been taken by the black player
  List<ChessPiece> whitePiecesTaken = [];
  // A list of black pieces that have been taken by the white player
  List<ChessPiece> blackPiecesTaken = [];

  //A boolean to see whose turn it is
  bool isWhiteTurn = true;

  //initial position of kings
  List<int> whiteKingPosition = [7, 3];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  //state variables for undo/redo functionality
  List<List<List<ChessPiece?>>> boardHistory = [];
  List<List<int>> selectedPieceHistory = [];
  List<bool> turnHistory = [];
  int historyIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _saveBoardState();
  }

  //Initialize board
  void _initializeBoard() {
    board = BoardInitializer.initializeBoard();
  }

  // pieces selection
  void pieceSelected(int row, int col) {
    setState(() {
      // No piece has been selected yet, this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }
      //There is a piece already selected, but user can select another one of their pieces
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      //if there is a piece selected and user taps on a square that is valid move, move there
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      // if piece selected, calculate it's valid moves
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  //real valid moves
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves =
        ChessLogic.calculateRawValidMoves(row, col, piece, board);
    //after generating all candidate moves, filter out any that would result in check
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        //this will simulate the future move to see if it's safe
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  //Move pieces
  void movePiece(int newRow, int newCol) {
    //save the current state before moving
    _saveBoardState();
    //If the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      //Add the captured piece to the appropriate list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    //check if the piece being moved for check to king
    if (selectedPiece!.type == ChessPieceType.king) {
      // update the appropriate king position
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }
    //move piece and clear old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // Check for pawn promotion
    if (selectedPiece!.type == ChessPieceType.pawn) {
      if ((selectedPiece!.isWhite && newRow == 0) ||
          (!selectedPiece!.isWhite && newRow == 7)) {
        _promotePawn(newRow, newCol);
        return;
      }
    }

    // Complete the move
    _completeMoveAfterPromotion();
  }

  void _promotePawn(int row, int col) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promote Pawn'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _promotionButton(ChessPieceType.queen, row, col),
              _promotionButton(ChessPieceType.rook, row, col),
              _promotionButton(ChessPieceType.bishop, row, col),
              _promotionButton(ChessPieceType.knight, row, col),
            ],
          ),
        );
      },
    );
  }

  Widget _promotionButton(ChessPieceType pieceType, int row, int col) {
    String pieceCode;
    switch (pieceType) {
      case ChessPieceType.queen:
        pieceCode = 'q';
        break;
      case ChessPieceType.rook:
        pieceCode = 'r';
        break;
      case ChessPieceType.knight:
        pieceCode = 'n';
        break;
      case ChessPieceType.bishop:
        pieceCode = 'b';
        break;
      default:
        pieceCode = 'q';
    }

    String colorCode = selectedPiece!.isWhite ? 'l' : 'd';
    String imagePath = 'assets/images/Chess_$pieceCode${colorCode}t60.png';
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          board[row][col] = ChessPiece(
            type: pieceType,
            isWhite: selectedPiece!.isWhite,
            imagePath: imagePath,
          );
        });
        _completeMoveAfterPromotion();
      },
      child: Image.asset(imagePath, width: 50, height: 50),
    );
  }

  void _completeMoveAfterPromotion() {
    //see if any king are under attack
    checkStatus = isKingInCheck(!isWhiteTurn);

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    //check if it's checkmate
    if (isCheckMate(!isWhiteTurn)) {
      String winner = isWhiteTurn ? "White" : "Black";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("CHECKMATE! $winner Wins!"),
          content:
              const Text("The game is over. Would you like to play again?"),
          actions: [
            //play again button
            TextButton(
              onPressed: resetGame,
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    } else {
      // Change turns
      isWhiteTurn = !isWhiteTurn;
    }
  }

  void _saveBoardState() {
    boardHistory = boardHistory.sublist(0, historyIndex + 1);
    boardHistory.add(List.generate(8, (i) => List.from(board[i])));
    historyIndex++;
  }

  void undoMove() {
    if (historyIndex > 0) {
      historyIndex--;
      setState(() {
        board =
            List.generate(8, (i) => List.from(boardHistory[historyIndex][i]));
      });
    }
  }

  void redoMove() {
    if (historyIndex < boardHistory.length - 1) {
      historyIndex++;
      setState(() {
        board =
            List.generate(8, (i) => List.from(boardHistory[historyIndex][i]));
      });
    }
  }

  //Is king in check?
  bool isKingInCheck(bool isWhiteKing) {
    //get position of king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    //check if king's position is in piece's valid moves
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //check if king's position is in this piece's valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  // simulate a future move to see if it's safe (doesn't put your own king under attack)
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    //save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    //if piece is king, save it's current position and update to new one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //update the king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    //simulate move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //check if our own king is under attack
    bool kingInCheck = isKingInCheck((piece.isWhite));
    //restore board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;
    //if the piece was king, restore it original position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  // Is it check mate
  bool isCheckMate(bool isWhiteKing) {
    //if king is not in check, then it's not checkmate
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    //if there is at least one legal move for any of the player's pieces, then it's not checkmate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);
        //if this piece have any valid moves, then it's not checkmate
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }
    //if none of the above conditions are met, then there are no legal moves to left, it's checkmate
    return true;
  }

  void resetGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text('Are you sure you want to reset the game?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGameInternal();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGameInternal() {
    //clear the history
    boardHistory.clear();
    selectedPieceHistory.clear();
    turnHistory.clear();
    historyIndex = -1;

    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 3];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onLeadingPressed: () => Navigator.pop(context),
        onSettingsPressed: () {},
        showBackButton: true,
      ),
      backgroundColor: const Color.fromARGB(255, 212, 209, 159),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-img-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Game Status and Control Buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.undo, undoMove, 'Undo'),
                  const SizedBox(width: 16),
                  _buildControlButton(Icons.redo, redoMove, 'Redo'),
                  const SizedBox(width: 16),
                  _buildControlButton(Icons.restart_alt, resetGame, 'Reset'),
                ],
              ),
            ),

            //White pieces taken
            Expanded(
              child: GridView.builder(
                itemCount: whitePiecesTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: whitePiecesTaken[index].imagePath,
                  isWhite: true,
                ),
              ),
            ),

            //Game Status
            // Text(checkStatus ? "CHECK!" : ""),
            //Chess board
            Expanded(
              flex: 4,
              child: GridView.builder(
                  itemCount: 8 * 8,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;

                    bool isSelected = selectedRow == row && selectedCol == col;
                    bool isValidMove = false;
                    for (var position in validMoves) {
                      if (position[0] == row && position[1] == col) {
                        isValidMove = true;
                      }
                    }
                    bool isKingInCheckSquare = checkStatus &&
                        ((isWhiteTurn &&
                                row == whiteKingPosition[0] &&
                                col == whiteKingPosition[1]) ||
                            (!isWhiteTurn &&
                                row == blackKingPosition[0] &&
                                col == blackKingPosition[1]));

                    return Square(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () => pieceSelected(row, col),
                      isInCheck: isKingInCheckSquare,
                    );
                  }),
            ),

            //black piece taken
            Expanded(
              child: GridView.builder(
                itemCount: blackPiecesTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imagePath: blackPiecesTaken[index].imagePath,
                  isWhite: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
      IconData icon, VoidCallback onPressed, String tooltip) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
