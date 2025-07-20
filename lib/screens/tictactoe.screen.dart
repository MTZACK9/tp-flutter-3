import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.screen.dart';

class TicTacToeScreen extends StatelessWidget {
  final String login;

  const TicTacToeScreen({required this.login});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe - Joueur: $login'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('login');
              await prefs.remove('password');

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: TicTacToeGame(),
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  bool _xTurn = true;

  void _handleTap(int index) {
    setState(() {
      if (_board[index] == '') {
        _board[index] = _xTurn ? 'X' : 'O';
        _xTurn = !_xTurn;
        _checkWinner();
      }
    });
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _xTurn = true;
    });
  }
  void _checkWinner() {
    final lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (_board[a] != '' && _board[a] == _board[b] && _board[a] == _board[c]) {
        _showResultDialog('Le joueur "${_board[a]}" a gagné !');
        return;
      }
    }

    if (!_board.contains('')) {
      _showResultDialog("Égalité !");
    }
  }
  void _showResultDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Résultat'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          shrinkWrap: true,
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _handleTap(index),
              child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    _board[index],
                    style: TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _resetGame,
          child: Text('Réinitialiser'),
        )
      ],
    );
  }
}
