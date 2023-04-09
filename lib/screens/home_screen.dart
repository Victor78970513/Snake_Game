import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/widgets/blank_pixel.dart';
import 'package:snake_game/widgets/food_pixel.dart';
import 'package:snake_game/widgets/snake_pixel.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomeScreenState extends State<HomeScreen> {
  // grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;
  bool gameHasStarted = false;

  // user score
  int currentScore = 0;

  // snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  // snake direction
  var currentDirection = snake_Direction.RIGHT;

  // food position
  int foodPos = 55;

  // start the game;
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep the snake moving
        moveSnake();

        // check if the game is over
        if (gameOver()) {
          timer.cancel();

          // display a message
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over'),
                  content: Column(
                    children: [
                      Text('Your score is: ' + currentScore.toString()),
                      const TextField(
                        decoration:
                            InputDecoration(hintText: 'Introduce tu nombre'),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      color: Colors.pink,
                      onPressed: () {
                        submitScore();
                        newGame();
                        Navigator.pop(context);
                      },
                      child: const Text('Guardar Score'),
                    )
                  ],
                );
              });
        }

        // snake is eating food
      });
    });
  }

  void submitScore() {
    // add data to firebase
  }

  void newGame() {
    setState(() {});
    snakePos = [0, 1, 2];
    currentDirection = snake_Direction.RIGHT;
    gameHasStarted = false;
    currentScore = 0;
  }

  void eatFood() {
    currentScore++;

    // making sure the new food is not where the snake
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          // add a new head
          //if snake is at the right wall, nee to re-adjust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          // add a new head
          //if snake is at the right wall, nee to re-adjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          // add a new head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          // add a new head
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // remove the tail
      snakePos.removeAt(0);
    }
  }

  // game over
  bool gameOver() {
    // the game is over when the snake runs into itself
    // this occurs when there is a duplicate position in the snakePos list
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // high scores
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // user score
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Score: '),
                      Text(
                        currentScore.toString(),
                        style: const TextStyle(fontSize: 36),
                      ),
                    ],
                  ),

                  // highsocres, top 5 or 10
                  Text('HighScores..')
                ],
              ),
            ),

            // game grid
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != snake_Direction.UP) {
                    print('MOVIMIENTO HACIA ABAJO');
                    currentDirection = snake_Direction.DOWN;
                  } else if (details.delta.dy < 0 &&
                      currentDirection != snake_Direction.DOWN) {
                    print('MOVIEMIENTO HACIA ARRIBA');
                    currentDirection = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != snake_Direction.LEFT) {
                    print('MOVIMIENTO HACIA DERECHA');
                    currentDirection = snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      currentDirection != snake_Direction.RIGHT) {
                    print('MOVIEMIENTO HACIA IZQUIERDA');
                    currentDirection = snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalNumberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  },
                ),
              ),
            ),

            // play button
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    color: gameHasStarted ? Colors.grey : Colors.pink,
                    onPressed: gameHasStarted ? () {} : startGame,
                    child: const Text('JUGAR'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
