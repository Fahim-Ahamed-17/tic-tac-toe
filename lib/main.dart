import "package:flutter/material.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const MyAppBar(),
          toolbarHeight: height * 0.1,
        ),
        body: const Center(
          child: AppBody(),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        width: width * 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              spreadRadius: width * 0.00001,
              blurRadius: width * 0.01,
              offset: Offset(width * 0.009, width * 0.009),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Tic Tac Toe",
            style: TextStyle(
              fontSize: width * 0.12,
              color: const Color.fromARGB(255, 44, 44, 44),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({super.key});
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  List<String> board = List.generate(9, (int index) {
    return " ";
  });
  List<bool> boardState = List.generate(9, (int index) {
    return false;
  });
  List<Color> boardColor = List.generate(9, (int index) {
    return Colors.white;
  });

  int count = 0;
  String winner = "None";
  int xScore = 0;
  int oScore = 0;

  bool checkWinner() {
    bool isfinished = false;
    int trueCounter = 0; // how many tiles are active
    for (int i = 0; i < board.length; i += 3) {
      if (((board[i] == board[i + 1]) && (board[i] == board[i + 2])) &&
          (board[i] != " ")) {
        winner = count % 2 == 0 ? "O" : "X";
        isfinished = true;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (((board[i] == board[i + 3]) && (board[i] == board[i + 6])) &&
          (board[i] != " ")) {
        winner = count % 2 == 0 ? "O" : "X";
        isfinished = true;
      }
    }
    if (((board[0] == board[4]) && (board[0] == board[8])) &&
        (board[0] != " ")) {
      winner = count % 2 == 0 ? "O" : "X";
      isfinished = true;
    }
    if (((board[2] == board[4]) && (board[2] == board[6])) &&
        (board[2] != " ")) {
      winner = count % 2 == 0 ? "O" : "X";
      isfinished = true;
    }
    for (int i = 0; i < boardState.length; i++) {
      if (boardState[i] == false) {
        trueCounter++;
      }
    }

    if (isfinished != false) {
      return true;
    } else if (trueCounter == 0) {
      winner = "Tie";
      return true;
    } else {
      return false;
    }
  }

  void reset() {
    setState(() {
      count = 0;
      board = List.filled(9, " ");
      boardState = List.filled(9, false);
      boardColor = List.filled(9, Colors.white);
    });
  }

  void updateBoard(int i) {
    setState(() {
      if (boardState[i] == false) {
        if (count % 2 == 0) {
          board[i] = "X";
          boardColor[i] = Colors.red;
        } else {
          board[i] = "O";
          boardColor[i] = Colors.blue;
        }
        count++;
        boardState[i] = true;

        bool winnerState = checkWinner();
        if (winnerState == true && winner != "Tie") {
          count % 2 == 0 ? oScore++ : xScore++;
          for (int i = 0; i < boardState.length; i++) {
            boardState[i] = true;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: width * 1.3,
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: width * 0.005,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            spreadRadius: width * 0.00001,
            blurRadius: width * 0.01,
            offset: Offset(width * 0.009, width * 0.009),
          ),
        ],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Board(
            board: board,
            func: updateBoard,
            boardColor: boardColor,
          ),
          ScoreCard(
            winner: winner,
            xScore: xScore,
            reset: reset,
            oScore: oScore,
          )
        ],
      ),
    );
  }
}

class Board extends StatefulWidget {
  final List<String> board;
  final List<Color> boardColor;
  final Function(int) func;

  const Board({
    super.key,
    required this.board,
    required this.func,
    required this.boardColor,
  });

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> tiles = List.generate(
      9,
      (int index) {
        return Tile(
          index: index,
          handlePress: widget.func,
          text: widget.board[index],
          color: widget.boardColor[index],
        );
      },
    );

    return Container(
      width: width * 0.9,
      height: width * 0.9,
      color: Colors.black,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: width * 0.01,
          mainAxisSpacing: width * 0.01,
        ),
        itemBuilder: (BuildContext context, int index) {
          return tiles[index];
        },
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index;
  final String text;
  final Color color;
  final Function(int) handlePress;

  const Tile(
      {super.key,
      required this.index,
      required this.handlePress,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: width * 0.2, color: color),
        ),
        onPressed: () => handlePress(index),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final String winner;
  final int xScore;
  final int oScore;
  final Function() reset;

  const ScoreCard(
      {super.key,
      required this.winner,
      required this.xScore,
      required this.reset,
      required this.oScore});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.02),
      width: width * 0.9,
      height: height * 0.15,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: height * 0.004),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Winner : $winner",
                  style: TextStyle(fontSize: width * 0.08),
                ),
                Text(
                  "X Score : $xScore",
                  style: TextStyle(fontSize: width * 0.05),
                ),
                Text(
                  "O Score : $oScore",
                  style: TextStyle(fontSize: width * 0.05),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: reset,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: SizedBox(
              height: height * 0.08,
              width: height * 0.08,
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: height * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
