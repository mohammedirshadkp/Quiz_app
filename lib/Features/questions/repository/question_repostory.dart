import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../../Core/faliure.dart';
import '../../../Core/type_def.dart';

final quizRepositoryProvider = Provider((ref) => QuizRepository());

class QuizRepository {
  FutureEither<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('https://nice-lime-hippo-wear.cyclic.app/api/v1/quiz'));
      if (response.statusCode == 200) {
        // List<dynamic> question = json.decode(response.body);

        return right(json.decode(response.body));
      } else {
        throw Exception('Fail to ld data');
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> saveDataLocally(List<dynamic> data) async {
    final box = await Hive.openBox('data box');
    await box.put('daaKey', data);
    await box.close();
  }

  Future<dynamic> getDataFromHive() async {
    try {
      final box = await Hive.openBox('dataBox');
      final savedData = box.get('data key');
      await box.close();
      return savedData;
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
