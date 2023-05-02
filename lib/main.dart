//Пятнашки
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Пятнашки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Пятнашки'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _tiles = [];
  int _size = 3;
  int _emptyTileIndex = -1;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    // Generate random order of tiles
    var rng = Random();
    _tiles = List.generate(_size * _size, (index) => index)..shuffle(rng);

    // Find index of empty tile
    _emptyTileIndex = _tiles.indexOf(0);
    setState(() {});
  }

  void _onTilePressed(int tileIndex) {
    // Check if tile can be moved
    if (_canTileMove(tileIndex)) {
      // Swap tile and empty tile
      _tiles[_emptyTileIndex] = _tiles[tileIndex];
      _tiles[tileIndex] = 0;
      _emptyTileIndex = tileIndex;
      setState(() {});

      // Check if puzzle is solved
      if (_isPuzzleSolved()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Поздравляем!'),
            content: Text('Вы решили головоломку!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startNewGame();
                },
                child: Text('Новая игра'),
              ),
            ],
          ),
        );
      }
    }
  }

  bool _canTileMove(int tileIndex) {
    // Check if tile is adjacent to empty tile
    return _getAdjacentTileIndices(_emptyTileIndex).contains(tileIndex);
  }

  bool _isPuzzleSolved() {
    // Check if all tiles are in correct order
    for (int i = 0; i < _size * _size - 1; i++) {
      if (_tiles[i] != i + 1) {
        return false;
      }
    }
    return true;
  }

  List<int> _getAdjacentTileIndices(int tileIndex) {
    // Get row and column of tile
    int row = tileIndex ~/ _size;
    int col = tileIndex % _size;

    // Get indices of adjacent tiles
    List<int> adjacentTileIndices = [];
    if (row > 0) {
      adjacentTileIndices.add(tileIndex - _size); // Top
    }
    if (row < _size - 1) {
      adjacentTileIndices.add(tileIndex + _size); // Bottom
    }
    if (col > 0) {
      adjacentTileIndices.add(tileIndex - 1); // Left
    }
    if (col < _size - 1) {
      adjacentTileIndices.add(tileIndex + 1); // Right
}
return adjacentTileIndices;

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(widget.title),
),
body: GridView.builder(
padding: EdgeInsets.all(16.0),
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: _size,
mainAxisSpacing: 16.0,
crossAxisSpacing: 16.0,
),
itemCount: _tiles.length,
itemBuilder: (context, index) {
// Get tile number
int tileNumber = _tiles[index];
      // Determine tile color and text
      Color tileColor = Colors.grey.shade300;
      String tileText = '';
      if (tileNumber != 0) {
        tileColor = Colors.blue;
        tileText = '${tileNumber}';
      }

// Create tile widget
return GestureDetector(
  onTap: () => _onTilePressed(index),
  child: PhysicalModel(
    color: tileColor,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(16.0),
    child: Center(
      child: Text(
        tileText,
        style: TextStyle(
          fontSize: 32.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);

    },
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: _startNewGame,
    tooltip: 'Новая игра',
    child: Icon(Icons.refresh),
  ),
);
}
}