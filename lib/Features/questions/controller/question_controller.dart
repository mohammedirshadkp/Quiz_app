import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/question_repostory.dart';

final getDataProvider = FutureProvider(
    (ref) => ref.read(quizControllerProvider.notifier).fetchData());
final getDataFromHiveProvider = FutureProvider(
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
  QuizController(this._repository) : super(const AsyncValue.loading());
  Future<List<dynamic>> fetchData() async {
    final result = await _repository.fetchData();
    return result.fold(
      (failure) {
        return <dynamic>[];
      },
      (quizData) {
        return quizData;
      },
    );
  }

  Future<void> saveDataLocally(List<dynamic> data) async {
      await _repository.saveDataLocally(data);
  }

  Future<List<dynamic>> getDataFromHive() async {
    final result = await _repository.getDataFromHive();
    return result;
  }
}
