import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Core/global_variables.dart';
import 'package:quiz_app/Core/pallete.dart';
import 'package:quiz_app/Core/utiles.dart';
import 'Features/questions/controller/question_controller.dart';
import 'Features/questions/screen/QuestionScreen.dart';
import 'Core/constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  List questionsFromDb = [];
  List questionsFromHive = [];

  var d;
  getData() async {
    d = await ref.read(getDataProvider.future);
    await ref.read(quizControllerProvider.notifier).saveDataLocally(d);
    questionsFromHive = await ref.read(getDataFromHiveProvider.future);
  }

  @override
  Future<void> didChangeDependencies() async {
    await getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Pallete.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: deviceHeight * 0.2,
            ),
            Image.asset(
              Constants.quixtime2,
              width: deviceWidth * 0.8,
            ),
            InkWell(
              onTap: () async {
                if (questionsFromHive.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        data: questionsFromHive,
                      ),
                    ),
                  );
                } else {
                  showSnackBar(context, 'Loading...');
                }
              },
              child: Container(
                height: deviceHeight * 0.07,
                width: deviceWidth * 0.4,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(133, 20, 225, 1),
                  borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                ),
                child: const Center(
                    child: Text(
                  'Start Quiz',
                  style: TextStyle(color: Pallete.secondaryColor),
                )),
              ),
            ),
            SizedBox(height: deviceHeight * 0.03),
            const Column(
              children: [
                Text(
                  'Powered by ',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Text(
                  'www.artifitia.com',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
