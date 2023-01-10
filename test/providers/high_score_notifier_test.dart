import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:yatrix/providers/providers.dart';

//class MockPreferencesRepository extends Mock implements PreferencesRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepository(
    ref.read(sharedPreferencesProvider),
  ),
);

final highScoreNotifier =
    NotifierProvider<HighScoreNotifier, HighScoreState>(HighScoreNotifier.new);

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  ProviderContainer makeProviderContainer(
      MockSharedPreferences mockSharedPreferences) {
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

//  MockPreferencesRepository mockPreferencesRepository;
  MockSharedPreferences mockSharedPreferences;
  group('highScoreNotifier  - ', () {
    test('userName', () {
//      mockPreferencesRepository = MockPreferencesRepository();
      mockSharedPreferences = MockSharedPreferences();
      when(() => mockSharedPreferences.getString('userName'))
          .thenReturn('aTestUser');
      final container = makeProviderContainer(mockSharedPreferences);
//      final listener = Listener<HighScoreState>();
      // listen to the provider and call [listener] whenever its value changes
      // container.listen(
      //   highScoreNotifier,
      //   listener,
      //   fireImmediately: true,
      // );
      final userName = container.read(highScoreNotifier).userName;
      expect(userName, 'aTestUser');
    });

    test('scores are sorted descending by points', () {
      mockSharedPreferences = MockSharedPreferences();

      when(() => mockSharedPreferences.getString('userName'))
          .thenReturn('aTestUser');
      when(() => mockSharedPreferences.getStringList('scores'))
          .thenReturn(testScores);
      final container = makeProviderContainer(mockSharedPreferences);
      final scores = container.read(highScoreNotifier).scores;
//      print(scoreItems);
      expect(
        scores,
        scoreItems
          ..sort(
            (e1, e2) => e2.points.compareTo(e1.points),
          ),
      );
    });
  });
}


final scoreItems = [
  const ScoreItem(userName: 'user1', points: 1000, rows: 10),
  const ScoreItem(userName: 'user4', points: 4000, rows: 40),
  const ScoreItem(userName: 'user3', points: 3000, rows: 30),
  const ScoreItem(userName: 'user2', points: 2000, rows: 20),
];

List<String> get testScores {
  return scoreItems.map((item) => item.toJson()).toList();
}
