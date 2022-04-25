import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';

main() {
  test("Word adding test", () {
    List<String> words = ['ABASE',
      'ABASED',
      'ABASEMENT',
      'ABASEMENTS',
      'ABASER',
      'ABASES',
      'ABASH',
      'ABASHED',
      'ABASHEDLY',
      'ABASHES',
      'ABASHING',
      'ABASHMENT',
      'ABASING',
      'ABATE',
      'ABATED',
      'ABATEMENT',
      'ABATEMENTS',
      'ABATER',
      'ABATES',
      'ABATING'];
    Dawg dawg = new Dawg();
    dawg.addWords(words);
    for (String word in words) {
      assert(dawg.contains(word));
    }
  });
  test("All words test", () {
    Dawg dawg = new Dawg();
    dawg.addWords(validWords.toList());
    List<String> words = ['ABASE',
      'ABASED',
      'ABASEMENT',
      'ABASEMENTS',
      'ABASER',
      'ABASES',
      'ABASH',
      'ABASHED',
      'ABASHEDLY',
      'ABASHES',
      'ABASHING',
      'ABASHMENT',
      'ABASING',
      'ABATE',
      'ABATED',
      'ABATEMENT',
      'ABATEMENTS',
      'ABATER',
      'ABATES',
      'ABATING'];
    for (String word in words) {
      assert(dawg.contains(word));
    }
  });
}
