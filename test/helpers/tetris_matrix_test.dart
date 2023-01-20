import 'package:flutter_test/flutter_test.dart';
import 'package:yatrix/helpers/tetris_matrix.dart';

void main() {
  testWidgets('tetris matrix level for row/col = 1/4 ', (tester) async {
    final sut = TetrisMatrix();
    sut.add(1, 4, 'z');
//    print(sut);
    final level = sut.level;
    expect(level, sut.rowCount - 1);
  });

  testWidgets('tetris matrix level for row/col = 2/4 ', (tester) async {
    final sut = TetrisMatrix();
    sut.add(2, 4, 'z');
    final level = sut.level;
    expect(level, sut.rowCount - 2);
  });

  testWidgets('tetris matrix level for row/col = 19/4 ', (tester) async {
    final sut = TetrisMatrix();
    sut.add(19, 4, 'z');
    final level = sut.level;
    expect(level, 1);
  });

  testWidgets('tetris matrix level for empty matrix ', (tester) async {
    final sut = TetrisMatrix();
    final level = sut.level;
    expect(level, 0);
  });
}
