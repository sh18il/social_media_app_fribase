import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final ChessBoardController controller = ChessBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                controller.resetBoard();
              },
              icon: Icon(Icons.rotate_left_sharp))
        ],
        foregroundColor: Colors.white,
        shadowColor: Colors.black26,
        title: const Text(
          'Chess ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          // Chessboard widget
          Expanded(
            flex: 4,
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.orange,
                boardOrientation: PlayerColor.white,
                enableUserMoves: true,
                onMove: () {
                  // Add any additional actions you want to perform on a move
                  print('Move made: ${controller.getSan()}');
                },
              ),
            ),
          ),
          // Move history and control buttons
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Displaying move history
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<Chess>(
                      valueListenable: controller,
                      builder: (context, game, _) {
                        final sanMoves = controller.getSan();
                        return ListView.builder(
                          itemCount: sanMoves.length,
                          itemBuilder: (context, index) {
                            return Text(
                              sanMoves[index] ?? '',
                              style: const TextStyle(fontSize: 16),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // Control buttons
              ],
            ),
          ),
        ],
      ),
    );
  }
}
