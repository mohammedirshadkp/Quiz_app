import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/Core/constants.dart';
import 'package:quiz_app/Core/pallete.dart';
import 'package:quiz_app/splash_screen.dart';
import '../../../Core/global_variables.dart';

class QuizResultPage extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  const QuizResultPage(
      {super.key, required this.totalQuestions, required this.correctAnswers});
  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    int percentage =
        ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    return Scaffold(
      backgroundColor: Pallete.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              width: deviceWidth * 0.75,
              height: deviceHeight * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.congrats,
                    width: deviceWidth * 0.45,
                    height: deviceHeight * 0.1,
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  Text('$percentage% Score', // Display the percentage score
                      style: GoogleFonts.kanit(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: percentage >= 50 ? Colors.green : Colors.red,
                      )),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'You attempt ',
                            style: GoogleFonts.kanit(color: Colors.black)),
                        TextSpan(
                          text: '${widget.totalQuestions} Questions',
                          style: GoogleFonts.kanit(color: Colors.pink),
                        ),
                        TextSpan(
                          text: 'and',
                          style: GoogleFonts.kanit(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'from that ',
                          style: GoogleFonts.kanit(color: Colors.black),
                        ),
                        TextSpan(
                          text: '${widget.correctAnswers} Answer',
                          style: GoogleFonts.kanit(color: Colors.green),
                        ),
                        TextSpan(
                          text: ' is correct.',
                          style: GoogleFonts.kanit(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ));
            },
            child: Container(
              height: deviceHeight * 0.06,
              width: deviceWidth * 0.4,
              decoration: BoxDecoration(
                color: percentage >= 80 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(deviceWidth * 0.03),
              ),
              child: Center(
                  child: Text(
                percentage >= 80 ? 'Back.!' : 'Try Again..!',
                style: GoogleFonts.kanit(
                    color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
