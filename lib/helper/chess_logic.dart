import 'package:chess_app/components/piece.dart';

class ChessLogic {
  static List<List<int>> calculateRawValidMoves(
      int row, int col, ChessPiece? piece, List<List<ChessPiece?>> board) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    int direction = piece.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
        _calculatePawnMoves(row, col, direction, piece, board, candidateMoves);
        break;
      case ChessPieceType.rook:
        _calculateRookMoves(row, col, piece, board, candidateMoves);
        break;
      case ChessPieceType.knight:
        _calculateKnightMoves(row, col, piece, board, candidateMoves);
        break;
      case ChessPieceType.bishop:
        _calculateBishopMoves(row, col, piece, board, candidateMoves);
        break;
      case ChessPieceType.queen:
        _calculateQueenMoves(row, col, piece, board, candidateMoves);
        break;
      case ChessPieceType.king:
        _calculateKingMoves(row, col, piece, board, candidateMoves);
        break;
    }
    return candidateMoves;
  }

  static void _calculatePawnMoves(
      int row,
      int col,
      int direction,
      ChessPiece piece,
      List<List<ChessPiece?>> board,
      List<List<int>> candidateMoves) {
    if (isInBoard(row + direction, col) &&
        board[row + direction][col] == null) {
      candidateMoves.add([row + direction, col]);
    }
    // pawns can move 2 square forward if at initial position
    if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
      if (isInBoard(row + 2 * direction, col) &&
          board[row + 2 * direction][col] == null &&
          board[row + direction][col] == null) {
        candidateMoves.add([row + 2 * direction, col]);
      }
    }
    // pawn can kill diagonally
    if (isInBoard(row + direction, col - 1) &&
        board[row + direction][col - 1] != null &&
        board[row + direction][col - 1]!.isWhite != piece.isWhite) {
      candidateMoves.add([row + direction, col - 1]);
    }
    if (isInBoard(row + direction, col + 1) &&
        board[row + direction][col + 1] != null &&
        board[row + direction][col + 1]!.isWhite != piece.isWhite) {
      candidateMoves.add([row + direction, col + 1]);
    }
  }

  static void _calculateRookMoves(int row, int col, ChessPiece piece,
      List<List<ChessPiece?>> board, List<List<int>> candidateMoves) {
    var directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ];
    for (var direction in directions) {
      var i = 1;
      while (true) {
        var newRow = row + i * direction[0];
        var newCol = col + i * direction[1];
        if (!isInBoard(newRow, newCol)) {
          break;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          }
          break;
        }
        candidateMoves.add([newRow, newCol]);
        i++;
      }
    }
  }

  static void _calculateKnightMoves(int row, int col, ChessPiece piece,
      List<List<ChessPiece?>> board, List<List<int>> candidateMoves) {
    var knightMoves = [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
      [2, -1],
      [2, 1],
    ];
    for (var move in knightMoves) {
      var newRow = row + move[0];
      var newCol = col + move[1];
      if (!isInBoard(newRow, newCol)) {
        continue;
      }
      if (board[newRow][newCol] != null) {
        if (board[newRow][newCol]!.isWhite != piece.isWhite) {
          candidateMoves.add([newRow, newCol]);
        }
        continue;
      }
      candidateMoves.add([newRow, newCol]);
    }
  }

  static void _calculateBishopMoves(int row, int col, ChessPiece piece,
      List<List<ChessPiece?>> board, List<List<int>> candidateMoves) {
    var directions = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1],
    ];
    for (var direction in directions) {
      var i = 1;
      while (true) {
        var newRow = row + i * direction[0];
        var newCol = col + i * direction[1];
        if (!isInBoard(newRow, newCol)) {
          break;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          }
          break;
        }
        candidateMoves.add([newRow, newCol]);
        i++;
      }
    }
  }

  static void _calculateQueenMoves(int row, int col, ChessPiece piece,
      List<List<ChessPiece?>> board, List<List<int>> candidateMoves) {
    var directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1],
    ];
    for (var direction in directions) {
      var i = 1;
      while (true) {
        var newRow = row + i * direction[0];
        var newCol = col + i * direction[1];
        if (!isInBoard(newRow, newCol)) {
          break;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]); //capture
          }
          break; //blocked
        }
        candidateMoves.add([newRow, newCol]);
        i++;
      }
    }
  }

  static void _calculateKingMoves(int row, int col, ChessPiece piece,
      List<List<ChessPiece?>> board, List<List<int>> candidateMoves) {
    var directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1],
    ];
    for (var direction in directions) {
      var newRow = row + direction[0];
      var newCol = col + direction[1];
      if (!isInBoard(newRow, newCol)) {
        continue;
      }
      if (board[newRow][newCol] != null) {
        if (board[newRow][newCol]!.isWhite != piece.isWhite) {
          candidateMoves.add([newRow, newCol]); //capture
        }
        continue; //blocked
      }
      candidateMoves.add([newRow, newCol]);
    }
  }

  static bool isInBoard(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }
}
