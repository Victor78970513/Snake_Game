import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // grid dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // high scores
          Expanded(
            child: Container(),
          ),

          // game grid
          Expanded(
            flex: 3,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalNumberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSize),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          // play button
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
