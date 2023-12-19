import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/question_repostory.dart';

final getDataprovider = FutureProvider(
    (ref) => ref.read(quizControllerProvider.notifier).fetchData());
final getDataFromHiveprovider = FutureProvider(
    (ref) => ref.read(quizControllerProvider.notifier).getDataFromHive());
final quizControllerProvider =
    StateNotifierProvider<QuizController, AsyncValue<List<dynamic>>>(
  (ref) {
    final repository = ref.read(quizRepositoryProvider);
    return QuizController(repository);
  },
);

class QuizController extends StateNotifier<AsyncValue<List<dynamic>>> {
  final QuizRepository _repository;

  QuizController(this._repository) : super(AsyncValue.loading());

  Future<List<dynamic>> fetchData() async {
    final result = await _repository.fetchData();

    return result.fold(
      (failure) {
        // You need to return a value here even if it's null or an empty list
        return <dynamic>[]; // Return an empty list as a default value
      },
      (quizData) {
        return quizData; // Return the fetched data
      },
    );
  }

  Future<void> saveDataLocally(List<dynamic> data) async {
    try {
      await _repository.saveDataLocally(data);
      // You can update the state or perform any other actions after saving data locally
    } catch (e, stackTrace) {}
  }

  Future<List<dynamic>> getDataFromHive() async {
    final result = await _repository.getDataFromHive();
    return result;
  }
}
