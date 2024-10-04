import 'package:chess_app/components/piece.dart';

class BoardInitializer {
  static List<List<ChessPiece?>> initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));
    _placePawns(newBoard);
    _placeRooks(newBoard);
    _placeKnights(newBoard);
    _placeBishops(newBoard);
    _placeQueens(newBoard);
    _placeKings(newBoard);

    return newBoard;
  }

  static void _placePawns(List<List<ChessPiece?>> newBoard) {
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'assets/images/Chess_pdt60.png',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'assets/images/Chess_pdt60.png',
      );
    }
  }

  static void _placeRooks(List<List<ChessPiece?>> newBoard) {
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/images/Chess_rdt60.png',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/images/Chess_rdt60.png',
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/images/Chess_rdt60.png',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/images/Chess_rdt60.png',
    );
  }

  static void _placeKnights(List<List<ChessPiece?>> newBoard) {
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/images/Chess_ndt60.png',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/images/Chess_ndt60.png',
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/images/Chess_ndt60.png',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/images/Chess_ndt60.png',
    );
  }

  static void _placeBishops(List<List<ChessPiece?>> newBoard) {
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/images/Chess_bdt60.png',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/images/Chess_bdt60.png',
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/images/Chess_bdt60.png',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/images/Chess_bdt60.png',
    );
  }

  static void _placeQueens(List<List<ChessPiece?>> newBoard) {
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'assets/images/Chess_qdt60.png',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'assets/images/Chess_qdt60.png',
    );
  }

  static void _placeKings(List<List<ChessPiece?>> newBoard) {
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'assets/images/Chess_kdt60.png',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'assets/images/Chess_kdt60.png',
    );
  }
}
