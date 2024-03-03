import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:flutter/rendering.dart';

class YahtzeePage extends StatefulWidget {
  const YahtzeePage({super.key});

  @override
  _YahtzeePageState createState() => _YahtzeePageState();
}

class _YahtzeePageState extends State<YahtzeePage> {
  final Random random = Random();
  List<int> dice = [0, 0, 0, 0, 0]; // Initializing all dice values to 0
  List<bool> heldDice = [
    false,
    false,
    false,
    false,
    false
  ]; // Holds the state of each die

  List<int?> scores =
      List.generate(13, (index) => null); // Scorecard with all 13 categories

  // Yahtzee category names
  final List<String> categoryNames = [
    'Ones',
    'Twos',
    'Threes',
    'Fours',
    'Fives',
    'Sixes',
    'Three of a Kind',
    'Four of a Kind',
    'Full House',
    'Small Straight',
    'Large Straight',
    'Chance',
    'Yahtzee',
  ];

  int filledCategories = 0; // Number of categories filled with score
  int rollsLeft = 3; // Number of rolls left in the current turn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yahtzee Game'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 5; i++)
                    Die(
                      value: dice[i],
                      held: heldDice[i],
                      onTapped: () {
                        if (rollsLeft < 3) {
                          setState(() {
                            // Toggling the "held" state of the die
                            heldDice[i] = !heldDice[i];
                          });
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              rollsLeft > 0
                  ? ElevatedButton(
                      onPressed: () {
                        if (rollsLeft > 0) {
                          // Implementing the logic to roll dice
                          _rollDice();
                        }
                      },
                      child: Text('Roll Dice ($rollsLeft)'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        // Implementing the logic to end the turn and calculate scores
                        _endTurn();
                      },
                      child: const Text('End Turn'),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        for (int i = 0; i < 6; i++)
                          GestureDetector(
                            onTap: () {
                              if (scores[i] == null) {
                                setState(() {
                                  scores[i] = _calculateScore(i);
                                  filledCategories++;
                                  _showScoreDialog();
                                });
                              }
                            },
                            child: ScoreCardItem(
                              categoryName: categoryNames[i],
                              score: scores[i],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        for (int i = 6; i < 13; i++)
                          GestureDetector(
                            onTap: () {
                              if (scores[i] == null) {
                                setState(() {
                                  scores[i] = _calculateScore(i);
                                  filledCategories++;
                                  _showScoreDialog();
                                });
                              }
                            },
                            child: ScoreCardItem(
                              categoryName: categoryNames[i],
                              score: scores[i],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ScoreCardItem(
                categoryName: 'Current Score',
                score: _calculateTotalScore(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rollDice() {
    // Rolling the dices
    if (rollsLeft > 0) {
      setState(() {
        for (int i = 0; i < 5; i++) {
          if (!heldDice[i]) {
            // Only rolling unheld dice
            dice[i] = random.nextInt(6) + 1;
          }
        }
        rollsLeft--;
      });
    }
  }

  void _endTurn() {
    // Reseting all dice values to 0 at the beginning of every turn
    setState(() {
      dice = [0, 0, 0, 0, 0];
      heldDice = [false, false, false, false, false];
      rollsLeft = 3;
    });
  }

  int? _calculateScore(int categoryIndex) {
    // Dice values, sorting in ascending order
    List<int> sortedDice = dice.toList()..sort();

    switch (categoryIndex) {
      case 0: // Ones
        return _calculateSingleNumberScore(sortedDice, 1);
      case 1: // Twos
        return _calculateSingleNumberScore(sortedDice, 2);
      case 2: // Threes
        return _calculateSingleNumberScore(sortedDice, 3);
      case 3: // Fours
        return _calculateSingleNumberScore(sortedDice, 4);
      case 4: // Fives
        return _calculateSingleNumberScore(sortedDice, 5);
      case 5: // Sixes
        return _calculateSingleNumberScore(sortedDice, 6);
      case 6: // Three of a Kind
        return _calculateThreeOfAKindScore(sortedDice);
      case 7: // Four of a Kind
        return _calculateFourOfAKindScore(sortedDice);
      case 8: // Full House
        return _calculateFullHouseScore(sortedDice);
      case 9: // Small Straight
        return _calculateSmallStraightScore(sortedDice);
      case 10: // Large Straight
        return _calculateLargeStraightScore(sortedDice);
      case 11: // Chance
        return _calculateChanceScore(sortedDice);
      case 12: // Yahtzee
        return _calculateYahtzeeScore(sortedDice);
    }
    return null;
  }

  int? _calculateSingleNumberScore(List<int> sortedDice, int targetNumber) {
    // Calculating the score for a category that counts a single number
    return sortedDice.where((die) => die == targetNumber).length * targetNumber;
  }

  int? _calculateThreeOfAKindScore(List<int> sortedDice) {
    // Calculating three of a kind score
    if (sortedDice[0] == sortedDice[2] ||
        sortedDice[1] == sortedDice[3] ||
        sortedDice[2] == sortedDice[4] ||
        sortedDice[0] == sortedDice[3] ||
        sortedDice[1] == sortedDice[4] ||
        sortedDice[0] == sortedDice[4]) {
      return sortedDice.reduce((a, b) => a + b);
    }
    return 0; // If there is no Three of a Kind, score is 0
  }

  int? _calculateFourOfAKindScore(List<int> sortedDice) {
    // Calculating the score for Four of a Kind category
    if (sortedDice[0] == sortedDice[3] ||
        sortedDice[1] == sortedDice[4] ||
        sortedDice[0] == sortedDice[4]) {
      return sortedDice.reduce((a, b) => a + b);
    }
    return 0; // If there is no Four of a Kind, score is 0
  }

  int? _calculateFullHouseScore(List<int> sortedDice) {
    // Calculating the score for Full House category
    if ((sortedDice[0] == sortedDice[1] && sortedDice[2] == sortedDice[4]) ||
        (sortedDice[0] == sortedDice[2] && sortedDice[3] == sortedDice[4])) {
      return 25;
    }
    return 0; // If there is no Full House, score is 0
  }

  int? _calculateSmallStraightScore(List<int> sortedDice) {
    //Calculating small straight score
    if ((sortedDice.contains(1) &&
            sortedDice.contains(2) &&
            sortedDice.contains(3) &&
            sortedDice.contains(4)) ||
        (sortedDice.contains(2) &&
            sortedDice.contains(3) &&
            sortedDice.contains(4) &&
            sortedDice.contains(5)) ||
        (sortedDice.contains(3) &&
            sortedDice.contains(4) &&
            sortedDice.contains(5) &&
            sortedDice.contains(6))) {
      return 30;
    }
    return 0; // If there is no Small Straight, score is 0
  }

  int? _calculateLargeStraightScore(List<int> sortedDice) {
    // Calculating the large straight score
    if ((sortedDice.contains(1) &&
            sortedDice.contains(2) &&
            sortedDice.contains(3) &&
            sortedDice.contains(4) &&
            sortedDice.contains(5)) ||
        (sortedDice.contains(2) &&
            sortedDice.contains(3) &&
            sortedDice.contains(4) &&
            sortedDice.contains(5) &&
            sortedDice.contains(6))) {
      return 40;
    }
    return 0; // If there is no Large Straight, score is 0
  }

  int? _calculateChanceScore(List<int> sortedDice) {
    // Calculating the score for Chance category
    return sortedDice.reduce((a, b) => a + b);
  }

  int? _calculateYahtzeeScore(List<int> sortedDice) {
    // Calculating the score for Yahtzee category
    if (sortedDice.every((die) => die == sortedDice[0])) {
      return 50;
    }
    return 0; // If there is no Yahtzee, score is 0
  }

  int _calculateTotalScore() {
    // Calculating the total score (sum of all categories)
    int totalScore = 0;
    for (int? score in scores) {
      if (score != null) {
        totalScore += score;
      }
    }
    return totalScore;
  }

  void _resetGame() {
    setState(() {
      // Reseting all dice values to 0 and held states
      dice = [0, 0, 0, 0, 0];
      heldDice = [false, false, false, false, false];
      rollsLeft = 3;

      // Reseting scores
      scores = List.generate(13, (index) => null);

      filledCategories = 0; // Reset filled categories
    });
  }

  void _showScoreDialog() {
    // Showing the Dialog box with Play again button
    if (filledCategories == 13) {
      // All categories are filled
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Round Complete'),
            content: Text('Your Total Score: ${_calculateTotalScore()}'),
            actions: <Widget>[
              TextButton(
                child: const Text('Play Again'),
                onPressed: () {
                  // Reseting the game for the next round
                  _resetGame();
                  Navigator.of(context).pop(); // Closing the dialog box
                },
              ),
            ],
          );
        },
      );
    }
  }
}
