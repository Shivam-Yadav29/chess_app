import 'package:flutter/material.dart';
import 'package:chess_app/components/piece.dart';
import 'package:chess_app/values/colors.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  final bool isInCheck;

  const Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap,
      required this.isValidMove,
      required this.isInCheck,});

  @override
  Widget build(BuildContext context) {
    Color? squareColor = isWhite ? foregroundColor : backgroundColor;

    if (isSelected) {
      squareColor = Colors.green;
    }
    if (isInCheck) {
      squareColor = Colors.red;
    }
    // else if (isValidMove) {
    //   squareColor = Colors.green[300];
    // } else {
    //   squareColor = isWhite ? foregroundColor : backgroundColor;
    // }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            color: squareColor,
            child: piece != null
                ? Image.asset(
                    piece!.imagePath,
                    color: piece!.isWhite
                        ? const Color(0xFFfbf5de)
                        : const Color(0xFF333333),
                  )
                : null,
          ),
          if (isValidMove)
            Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF008000),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
