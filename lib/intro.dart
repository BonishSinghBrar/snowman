import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(SnowmanWordGame());
}

class SnowmanWordGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> words = ['DART', 'BRAR', 'SGNR'];
  late String selectedWord;
  late List<String> displayedWord;
  List<String> guessedLetters = [];
  int attemptsLeft = 6;
  int snowmanParts = 0;
  int score = 0; // Added score variable
  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    selectedWord = words[random.nextInt(words.length)];
    displayedWord = List.generate(selectedWord.length, (index) => '_');
    guessedLetters.clear();
    attemptsLeft = 4;
    snowmanParts = 0;
  }

  void guessLetter(String letter) {
    setState(() {
      if (!guessedLetters.contains(letter)) {
        guessedLetters.add(letter);
        if (selectedWord.contains(letter)) {
          for (int i = 0; i < selectedWord.length; i++) {
            if (selectedWord[i] == letter) {
              displayedWord[i] = letter;
            }
          }
        } else {
          attemptsLeft--;
          snowmanParts++;
        }
      }
      if (attemptsLeft == 0 || displayedWord.join() == selectedWord) {
        // Game over
        if (displayedWord.join() == selectedWord) {
          score++; // Increase score if the user wins
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text(attemptsLeft == 0 ? 'Sorry, you lose!' : 'Congratulations, you win!\nScore: $score'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame();
                  },
                  child: Text('Play Again'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Snowman Word Guessing Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display Snowman
          Text(
            'Attempts left: $attemptsLeft',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Image.asset(
            'assets/snowman$snowmanParts.jpg',
            height: 200,
          ),
          SizedBox(height: 20),
          // Display Word Placeholder
          Text(
            displayedWord.join(' '),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Display Score
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          // Keyboard
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: 26,
            itemBuilder: (BuildContext context, int index) {
              String letter = String.fromCharCode(index + 65);
              return GestureDetector(
                onTap: () => guessLetter(letter),
                child: Container(
                  margin: EdgeInsets.all(2), // Added margin for spacing
                  decoration: BoxDecoration(
                    color: guessedLetters.contains(letter) ? Colors.grey[300] : Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05), // Adjust font size based on screen width
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
