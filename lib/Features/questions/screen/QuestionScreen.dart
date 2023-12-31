import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/Core/global_variables.dart';
import 'package:quiz_app/Core/pallete.dart';
import 'package:quiz_app/Features/result/screen/result.dart';
import 'dart:math' as math;

class QuizScreen extends StatefulWidget {
  final List data;
  const QuizScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _time = 40; // Total time for the quiz
  Timer? _timer;
  int _currentQuestionIndex = 0; // Track the current question index
  int? _selectedAnswerIndex; // Track the selected answer
  bool _answerChosen = false;
  int _correctAnswers = 0;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_time == 0) {
        timer.cancel();
        setState(() {
          if (_currentQuestionIndex < widget.data.length - 1) {
            if (_selectedAnswerIndex != null) {
              // Check if an answer was chosen before moving to the next question
              bool isCorrect = widget.data[_currentQuestionIndex]["options"]
                  [_selectedAnswerIndex!]["isCorrect"];
              _correctAnswers += isCorrect ? 1 : 0;
            }
            _currentQuestionIndex++; // Move to the next question index
            _time = 40; // Reset timer for the next question
            _selectedAnswerIndex = null; // Reset selected answer index
            _answerChosen = false; // Reset answer chosen flag
            startTimer(); // Start the timer for the new question
          } else {
            if (_selectedAnswerIndex != null) {
              bool isCorrect = widget.data[_currentQuestionIndex]["options"]
                  [_selectedAnswerIndex!]["isCorrect"];
              _correctAnswers += isCorrect ? 1 : 0;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizResultPage(
                  totalQuestions: widget.data.length,
                  correctAnswers: _correctAnswers,
                ),
              ),
            );
          }
        });
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    Map<dynamic, dynamic> currentQuestion = widget.data[_currentQuestionIndex];
    List<dynamic> currentOptions = currentQuestion["options"];
    if (widget.data.isNotEmpty && _currentQuestionIndex < widget.data.length) {
      currentQuestion = widget.data[_currentQuestionIndex];
      currentOptions = currentQuestion["options"];
    }
    Color progressColor =
        _time <= 10 ? Colors.red : const Color.fromRGBO(195, 83, 214, 1);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallete.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.027,
                    width: deviceWidth * 0.78,
                    child: Transform.rotate(
                      angle: -math.pi,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(15),
                        value: 1 - (_time / 40), // Adjust the value here
                        backgroundColor: const Color.fromRGBO(108, 38, 119, 1),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0, // Position the timer on the left
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '$_time', // Display the time remaining
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.02),
              SizedBox(
                width: deviceWidth * 0.7,
                height: deviceHeight * 0.1,
                child: currentQuestion != null
                    ? Center(
                        child: Text(
                          currentQuestion["question"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Pallete.secondaryColor,
                          ),
                        ),
                      )
                    : const Text('No question available'),
              ),
              SizedBox(height: deviceHeight * 0.03),
              SizedBox(
                height: deviceHeight * 0.5,
                width: deviceWidth * 0.75,
                child: ListView.builder(
                  itemCount: currentOptions.length,
                  itemBuilder: (context, index) {
                    bool isCorrect = currentOptions[index]["isCorrect"];
                    bool isSelected = _selectedAnswerIndex != null &&
                        _selectedAnswerIndex == index;
                    bool isWrongSelected = isSelected && !isCorrect;
                    // Update the selected answer and correct answer color conditionally
                    Color optionColor = _answerChosen
                        ? isCorrect
                            ? Colors.green // Set correct answer to green
                            : isWrongSelected
                                ? Colors.red // Set wrong answer to red
                                : Colors.transparent // Default color
                        : Colors
                            .transparent; // Default color when no answer is chosen

                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: _answerChosen
                          ? null
                          : () {
                              setState(() {
                                _selectedAnswerIndex = index;
                                _answerChosen = true;
                              });
                            },
                      child: Padding(
                        padding: EdgeInsets.only(top: deviceHeight * 0.03),
                        child: Container(
                          height: deviceHeight * 0.07,
                          width: deviceWidth * 0.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: optionColor,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: deviceWidth * 0.1,
                                top: deviceHeight * 0.02),
                            child: Text(
                              "${index + 1}.${currentOptions[index]["text"]}",
                              style: const TextStyle(
                                color: Pallete.secondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (_selectedAnswerIndex != null) {
                      // Check if the selected answer is correct
                      if (currentOptions[_selectedAnswerIndex!]['isCorrect']) {
                        _correctAnswers++; // Increment correct answers count
                      }
                      if (_currentQuestionIndex < widget.data.length - 1) {
                        _currentQuestionIndex++;
                        _selectedAnswerIndex = null; // Reset selected answer
                        _answerChosen = false; // Reset answer chosen flag
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizResultPage(
                              totalQuestions: widget.data.length,
                              correctAnswers: _correctAnswers,
                            ),
                          ),
                        );
                      }
                      _time = 40; // Reset timer for the next question
                    }
                  });
                },
                child: Container(
                  height: deviceHeight * 0.06,
                  width: deviceWidth * 0.4,
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(color: Pallete.primaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}
